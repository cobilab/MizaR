#!/bin/bash
#
DB="VDB_MT_ALL_REF.fa";
#
./MizaR.sh --install
#
rm -f sequences.txt
for(( x = 100 ; x <= 1000 ; x += 100 ));
  do
  #
 ./Simulate.sh $DB $x 50
  #
  ./MizaR.sh --reads merged_reads.fq \
  --database $DB --cache 25 \
  --similarity 50 --output compressed.mr
  #
  B_NAMES_ORIGINAL=`cat report_original.txt | grep Names | awk '{ print $4; }'`;
  B_BASES_ORIGINAL=`cat report_original.txt | grep Bases | awk '{ print $4; }'`;
  B_QUALS_ORIGINAL=`cat report_original.txt | grep Quals | awk '{ print $4; }'`;
  B_NAMES_SORTED=`cat report_sorted.txt | grep Names | awk '{ print $4; }'`;
  B_BASES_SORTED=`cat report_sorted.txt | grep Bases | awk '{ print $4; }'`;
  B_QUALS_SORTED=`cat report_sorted.txt | grep Quals | awk '{ print $4; }'`;
  B_PERMUTATION=`cat report_permutations.txt | awk '{ print $1; }'`; 
  B_TOTAL_ORIGINAL=`ls -la compressed.mr.fqz | awk '{ print $5; }'`;
  B_TOTAL_SORTED=`ls -la merged_reads.fq.fqz | awk '{ print $5; }'`;
  #
  printf "$x\t$B_NAMES_ORIGINAL\t$B_BASES_ORIGINAL\t$B_QUALS_ORIGINAL\t$B_NAMES_SORTED\t$B_BASES_SORTED\t$B_QUALS_SORTED\t$B_PERMUTATION\t$B_TOTAL_ORIGINAL\t$B_TOTAL_SORTED\n" >> sequences.txt
  #
  done
#
# ================================================
#
rm -f coverage.txt
for(( x = 1 ; x <= 100 ; x += 10 ));
  do
  #
  ./Simulate.sh VDB_MT_ALL_REF.fa 500 $x
  #
  ./MizaR.sh --reads merged_reads.fq \
  --database $DB --cache 25 \
  --similarity 50 --output compressed.mr
  #
  B_NAMES_ORIGINAL=`cat report_original.txt | grep Names | awk '{ print $4; }'`;
  B_BASES_ORIGINAL=`cat report_original.txt | grep Bases | awk '{ print $4; }'`;
  B_QUALS_ORIGINAL=`cat report_original.txt | grep Quals | awk '{ print $4; }'`;
  B_NAMES_SORTED=`cat report_sorted.txt | grep Names | awk '{ print $4; }'`;
  B_BASES_SORTED=`cat report_sorted.txt | grep Bases | awk '{ print $4; }'`;
  B_QUALS_SORTED=`cat report_sorted.txt | grep Quals | awk '{ print $4; }'`;
  B_PERMUTATION=`cat report_permutations.txt | awk '{ print $1; }'`;
  B_TOTAL_ORIGINAL=`ls -la compressed.mr.fqz | awk '{ print $5; }'`;
  B_TOTAL_SORTED=`ls -la merged_reads.fq.fqz | awk '{ print $5; }'`;
  #
  printf "$x\t$B_NAMES_ORIGINAL\t$B_BASES_ORIGINAL\t$B_QUALS_ORIGINAL\t$B_NAMES_SORTED\t$B_BASES_SORTED\t$B_QUALS_SORTED\t$B_PERMUTATION\t$B_TOTAL_ORIGINAL\t$B_TOTAL_SORTED\n" >> coverage.txt
  #
  done
#
# ================================================
#
