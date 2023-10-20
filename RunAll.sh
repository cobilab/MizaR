#!/bin/bash
#
DB="VDB_MT_ALL_REF.fa";
CACHE="50";
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
  --database $DB --cache $CACHE \
  --fqzcomp --lzma --jarvis \
  --similarity 50 --output compressed.mr
  #
  B_PERMUTATION=`cat report_permutations.txt | awk '{ print $1; }'`; 
  #
  B_NAMES_ORIGINAL_FQZ=`cat report_original_fqz.txt | grep Names | awk '{ print $4; }'`;
  B_BASES_ORIGINAL_FQZ=`cat report_original_fqz.txt | grep Bases | awk '{ print $4; }'`;
  B_QUALS_ORIGINAL_FQZ=`cat report_original_fqz.txt | grep Quals | awk '{ print $4; }'`;
  B_NAMES_SORTED_FQZ=`cat report_sorted_fqz.txt | grep Names | awk '{ print $4; }'`;
  B_BASES_SORTED_FQZ=`cat report_sorted_fqz.txt | grep Bases | awk '{ print $4; }'`;
  B_QUALS_SORTED_FQZ=`cat report_sorted_fqz.txt | grep Quals | awk '{ print $4; }'`;
  #
  B_TOTAL_ORIGINAL_LZMA=`ls -la merged_reads.fq.xz | awk '{ print $5; }'`;
  B_TOTAL_SORTED_LZMA=`ls -la compressed.mr.xz | awk '{ print $5; }'`;
  B_TOTAL_SORTED_PERMUTATION=`echo "$B_TOTAL_SORTED_LZMA + $B_PERMUTATION" | bc -l`;  
  #
  B_TOTAL_ORIGINAL_JARVIS=`ls -la merged_reads.fq.tar | awk '{ print $5; }'`;
  B_TOTAL_SORTED_JARVIS=`ls -la compressed.mr.tar | awk '{ print $5; }'`;
  B_TOTAL_SORTED_PERMUTATION=`echo "$B_TOTAL_SORTED_JARVIS + $B_PERMUTATION" | bc -l`;
  #
  B_TOTAL_ORIGINAL_FQZ=`ls -la merged_reads.fq.fqz | awk '{ print $5; }'`;
  B_TOTAL_SORTED_FQZ=`ls -la compressed.mr.fqz | awk '{ print $5; }'`;
  B_TOTAL_SORTED_PERMUTATION=`echo "$B_TOTAL_SORTED_FQZ + $B_PERMUTATION" | bc -l`;
  #
  printf "$x\t$B_NAMES_ORIGINAL_FQZ\t$B_BASES_ORIGINAL_FQZ\t$B_QUALS_ORIGINAL_FQZ\t$B_NAMES_SORTED_FQZ\t$B_BASES_SORTED_FQZ\t$B_QUALS_SORTED_FQZ\t$B_PERMUTATION\t$B_TOTAL_ORIGINAL\t$B_TOTAL_SORTED\t$B_TOTAL_SORTED_PERMUTATION\t$B_TOTAL_ORIGINAL_LZMA\t$B_TOTAL_SORTED_JARVIS\t$B_TOTAL_SORTED_PERMUTATION\t$B_TOTAL_ORIGINAL_FQZ\t$B_TOTAL_SORTED_FQZ\t$B_TOTAL_SORTED_PERMUTATION\n" >> sequences.txt
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
  --database $DB --cache $CACHE \
  --fqzcomp --lzma --jarvis \
  --similarity 50 --output compressed.mr
  #
  B_PERMUTATION=`cat report_permutations.txt | awk '{ print $1; }'`;
  #
  B_NAMES_ORIGINAL_FQZ=`cat report_original_fqz.txt | grep Names | awk '{ print $4; }'`;
  B_BASES_ORIGINAL_FQZ=`cat report_original_fqz.txt | grep Bases | awk '{ print $4; }'`;
  B_QUALS_ORIGINAL_FQZ=`cat report_original_fqz.txt | grep Quals | awk '{ print $4; }'`;
  B_NAMES_SORTED_FQZ=`cat report_sorted_fqz.txt | grep Names | awk '{ print $4; }'`;
  B_BASES_SORTED_FQZ=`cat report_sorted_fqz.txt | grep Bases | awk '{ print $4; }'`;
  B_QUALS_SORTED_FQZ=`cat report_sorted_fqz.txt | grep Quals | awk '{ print $4; }'`;
  #
  B_TOTAL_ORIGINAL_LZMA=`ls -la merged_reads.fq.xz | awk '{ print $5; }'`;
  B_TOTAL_SORTED_LZMA=`ls -la compressed.mr.xz | awk '{ print $5; }'`;
  B_TOTAL_SORTED_PERMUTATION=`echo "$B_TOTAL_SORTED_LZMA + $B_PERMUTATION" | bc -l`;
  #
  B_TOTAL_ORIGINAL_JARVIS=`ls -la merged_reads.fq.tar | awk '{ print $5; }'`;
  B_TOTAL_SORTED_JARVIS=`ls -la compressed.mr.tar | awk '{ print $5; }'`;
  B_TOTAL_SORTED_PERMUTATION=`echo "$B_TOTAL_SORTED_JARVIS + $B_PERMUTATION" | bc -l`;
  #
  B_TOTAL_ORIGINAL_FQZ=`ls -la merged_reads.fq.fqz | awk '{ print $5; }'`;
  B_TOTAL_SORTED_FQZ=`ls -la compressed.mr.fqz | awk '{ print $5; }'`;
  B_TOTAL_SORTED_PERMUTATION=`echo "$B_TOTAL_SORTED_FQZ + $B_PERMUTATION" | bc -l`;
  #
  printf "$x\t$B_NAMES_ORIGINAL_FQZ\t$B_BASES_ORIGINAL_FQZ\t$B_QUALS_ORIGINAL_FQZ\t$B_NAMES_SORTED_FQZ\t$B_BASES_SORTED_FQZ\t$B_QUALS_SORTED_FQZ\t$B_PERMUTATION\t$B_TOTAL_ORIGINAL\t$B_TOTAL_SORTED\t$B_TOTAL_SORTED_PERMUTATION\t$B_TOTAL_ORIGINAL_LZMA\t$B_TOTAL_SORTED_JARVIS\t$B_TOTAL_SORTED_PERMUTATION\t$B_TOTAL_ORIGINAL_FQZ\t$B_TOTAL_SORTED_FQZ\t$B_TOTAL_SORTED_PERMUTATION\n" >> coverage.txt
  #
  done
#
# ================================================
#
