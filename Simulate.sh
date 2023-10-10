#!/bin/bash
#
# INSTALLATION DEPENDENCIES:
#
# sudo apt-get install libopenblas-base
# conda install -c 'bioconda' art
#
DATABASE="$1";
SIZE="$2";
DEPTH="$3";
#
cat $DATABASE | grep ">" | sed -e 's/NC_//g' | tr '_' '\t' \
| awk '{ print $1}' | sort -R | tr -d '>' | head -n $SIZE > GIS.txt
#
rm -f sample.fa;
mapfile -t GIS_DATA < GIS.txt;
for vline in "${GIS_DATA[@]}"
  do
  GI=`echo $vline | awk -F '\t| ' '{ print $1 }'`;
  echo "Building $GI ...";
  gto_fasta_extract_read_by_pattern -p "$GI" < $DATABASE > sim-$GI.fa
  cat sim-$GI.fa >> sample.fa
  rm -f sim-$GI.fa;
  done
#
art_illumina -rs 0 -ss HS25 -i sample.fa -p -l 150 -f $DEPTH -m 200 -s 10 -o reads
#
rm -f GIS.txt;
#
# XXX: Adapt
cat reads1.fq reads2.fq > merged_reads.fq
#
# ============================================================================
