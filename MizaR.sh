#!/bin/bash
#
RUN="0";
RUN_FQZ="1";
RUN_LZMA="0";
RUN_JARVIS="0";
INSTALL="0";
THREADS="8";
CACHE="10";
READS="";
DATABASE="VDB.mfa";
#
################################################################################
#
SHOW_MENU () {
  echo " -------------------------------------------------------- ";
  echo "                                                          ";
  echo "                        MizaR                             ";
  echo "                                                          ";
  echo "  Metagenomic information zone arrangement Encoder V1.0   ";
  echo "                                                          ";
  echo " Program options ---------------------------------------- ";
  echo "                                                          ";
  echo " -h, --help                      Show this,               ";
  echo " -i, --install                   Installation,            ";
  echo "                                                          ";
  echo " -s <INT>, --similarity <INT>    Minimum similarity,      ";
  echo " -c <INT>, --cache <INT>         Cache memory (max),      ";
  echo "                                 creating buckets,        ";
  echo " -t <INT>, --threads <INT>       Number of threads,       ";
  echo " -o <STR>, --output <STR>        Output file name,        ";
  echo "                                                          ";
  echo " -f, --fqzcomp                   Run Fqzcomp compressor,  ";
  echo " -l, --lzma                      Run lzma compressor,     ";
  echo " -j, --jarvis                    Run JARVIS compressor,   ";
  echo "                                                          ";
  echo " -r <STR>, --reads <STR>         FASTQ reads (input),     ";
  echo " -d <STR>, --database <STR>      FASTA Viral Database.    ";
  echo "                                                          ";
  echo " Example -----------------------------------------------  ";
  echo "                                                          ";
  echo " ./MizaR.sh --reads reads.fq --database VDB.mfa \\        ";
  echo " --output compressed_reads.fq.mr --fqzcomp --threads 8    ";
  echo "                                                          ";
  echo " -------------------------------------------------------  ";
  }
  #
################################################################################
#
CHECK_INPUT () {
  FILE=$1
  if [ -f "$FILE" ];
    then
    echo "Input filename: $FILE"
    else
    echo -e "\e[31mERROR: input file not found ($FILE)!\e[0m";
    SHOW_MENU;
    exit;
    fi
  }
#
################################################################################
#
PROGRAM_EXISTS () {
  printf "Checking $1 ... ";
  if ! [ -x "$(command -v $1)" ];
    then
    echo -e "\e[41mERROR\e[49m: $1 is not installed." >&2;
    echo -e "\e[42mTIP\e[49m: Try: ./MizaR.sh --install" >&2;
    exit 1;
    else
    echo -e "\e[42mSUCCESS!\e[49m";
    fi
  }
#
################################################################################
#
CHECK_PROGRAMS () {
  PROGRAM_EXISTS "./FALCON";
  PROGRAM_EXISTS "./MAGNET";
  PROGRAM_EXISTS "./gto_fasta_extract_read_by_pattern";
  PROGRAM_EXISTS "./gto_fasta_rand_extra_chars";
  PROGRAM_EXISTS "./fqzcomp";
  PROGRAM_EXISTS "./xz";
  PROGRAM_EXISTS "./JARVIS3.sh";
  }
#
################################################################################
#
#
if [[ "$#" -lt 1 ]];
  then
  HELP=1;
  fi
#
POSITIONAL=();
#
while [[ $# -gt 0 ]]
  do
  i="$1";
  case $i in
    -h|--help|?)
      HELP=1;
      shift
    ;;
    -i|-c|--install|--compile)
      INSTALL=1;
      shift
    ;;
    -t|--threads)
      THREADS="$2";
      shift 2;
    ;;
    -r|--input|--reads)
      READS="$2";
      RUN=1;
      shift 2;
    ;;
    -d|--database)
      DATABASE="$2";
      shift 2;
    ;;
    -c|--cache)
      CACHE="$2";
      shift 2;
    ;;
    -s|--similarity)
      SIMILARITY="$2";
      SHOW_HELP=0;
      shift 2;
    ;;
    -f|--fqzcomp)
      RUN_FQZCOMP=1;
      shift
    ;;
    -l|--lzma)
      RUN_LZMA=1;
      shift
    ;;
    -j|--jarvis)
      RUN_JARVIS=1;
      shift
    ;;
    -o|--output)
      OUTPUT="$2";
      shift 2;
    ;;
    -*) # unknown option with small
    echo "Invalid arg ($1)!";
    echo "For help, try: MizaR.sh -h"
    exit 1;
    ;;
  esac
  done
#
set -- "${POSITIONAL[@]}" # restore positional parameters
#
################################################################################
#
if [[ "$HELP" -eq "1" ]];
  then
  SHOW_MENU;
  exit;
  fi
#
################################################################################
#
if [[ "$INSTALL" -eq "1" ]];
  then
  #
  echo -e "\e[34m[MizaR]\e[32m Installing FALCON ...\e[0m";
  rm -rf v3.2.zip falcon-3.2
  wget https://github.com/cobilab/falcon/archive/refs/tags/v3.2.zip
  unzip v3.2.zip
  cd falcon-3.2/src/
  cmake .
  make
  cp FALCON ../../
  cd ../../
  #
  echo -e "\e[34m[MizaR]\e[32m Installing MAGNET ...\e[0m"; 
  rm -rf v23.2.zip magnet-23.2
  wget https://github.com/cobilab/magnet/archive/refs/tags/v23.2.zip
  unzip v23.2.zip
  cd magnet-23.2/src/
  cmake .
  make
  cp MAGNET ../../
  cd ../../
  #
  echo -e "\e[34m[MizaR]\e[32m Installing GTO ...\e[0m";
  rm -fr v1.6.3.zip gto-1.6.3
  wget https://github.com/cobilab/gto/archive/refs/tags/v1.6.3.zip
  unzip v1.6.3.zip
  cd gto-1.6.3/src/
  make
  cd ../bin/
  cp gto_fasta_extract_read_by_pattern ../../
  cp gto_fasta_rand_extra_chars ../../
  cd ../../
  #
  echo -e "\e[34m[MizaR]\e[32m Installing fqzcomp ...\e[0m";
  rm -fr fqzcomp-master fqzcomp
  wget https://github.com/jkbonfield/fqzcomp/archive/refs/heads/master.zip
  unzip master.zip
  cd fqzcomp-master/
  make
  cp fqzcomp ../
  cd ../ 
  #
  echo -e "\e[34m[MizaR]\e[32m Installing LZMA ...\e[0m";
  rm -fr v5.4.4.zip xz-5.4.4/
  wget https://github.com/tukaani-project/xz/archive/refs/tags/v5.4.4.zip
  unzip v5.4.4.zip 
  cd xz-5.4.4/
  cmake .
  make
  cp xz ../
  cd ..
  #
  echo -e "\e[34m[MizaR]\e[32m Installing JARVIS3 ...\e[0m";
  rm -fr jarvis3-3.3/ v3.3.zip extra
  wget https://github.com/cobilab/jarvis3/archive/refs/tags/v3.3.zip
  unzip v3.3.zip
  cd jarvis3-3.3/src/
  make
  cp -rf extra/ ../../ 
  cp -f JARVIS3.sh ../../ 
  cp -f JARVIS3 ../../ 
  cd ../../
  ./JARVIS3.sh --install
  #
  CHECK_PROGRAMS
  #
  fi
#
################################################################################
#
if [[ "$RUN" -eq "1" ]];
  then
  #
  CHECK_INPUT $READS
  CHECK_INPUT $DATABASE
  #
  ## RUN VIRAL METAGENOMIC COMPOSITION AND MTDNA ===============================
  #
  ./FALCON -v -n $THREADS -t 1000 -F -m 13:50:1:0/0 -m 19:500:1:5/10 \
  -g 0.85 -c $CACHE -x mizar-top.csv $READS $DATABASE
  #
  IDX=0;
  cp $READS mizar-tmp-reads.fq;
  #
  rm -f mizar-bucket-*.fq;
  mapfile -t GIS_DATA < mizar-top.csv;
  for vline in "${GIS_DATA[@]}"
    do
    #
    SIZE=`echo $vline | awk -F '\t| ' '{ print $2 }'`;
    SIMI=`echo $vline | awk -F '\t| ' '{ print $3 }'`;
    NAME=`echo $vline | awk -F '\t| ' '{ print $4 }'`;
    #
    if [[ "$SIMI" != "-" ]]; 
      then
      if (( $(bc <<<"$SIMI > $SIMILARITY") )); 
        then
        #
        echo -e "\e[34m[MizaR]\e[32m Processing $NAME ($SIMI) ...\e[0m";
        #
        # GET GID AND SEQUENCE...
        GID=`echo $NAME | sed -e 's/NC_//g' | tr '_' '\t' | awk '{ print $1}'`;
        gto_fasta_extract_read_by_pattern -p "$GID" < $DATABASE > mizar-ref.fa;
        #
        FSIZE=`ls -la mizar-tmp-reads.fq | awk '{ print $5; }'`;
        #
	if (( $(bc <<<"$FSIZE < 1 ") )); 
	  then
	  echo -e "\e[34m[MizaR]\e[32m All reads already in buckets ...\e[0m";
          break;
          else
          ./MAGNET --threads $THREADS --verbose --force --level 7 \
	  --similarity 0.5 -o mizar-bucket-$IDX.fq -2 mizar-unfiltered.fq \
	  mizar-ref.fa mizar-tmp-reads.fq
          mv mizar-unfiltered.fq mizar-tmp-reads.fq
	  fi
        #
        ((++IDX));
        fi
      fi
    #
    done
    #
  #
  cat mizar-bucket-*.fq mizar-tmp-reads.fq > $OUTPUT
  rm -f mizar-bucket-*.fq;
  #
  if [[ "$RUN_FQZ" -eq "1" ]];
    then
    ./fqzcomp -n 1 -s 1 -q 1 $READS $READS.fqz 2> report_original_fqz.txt 
    ./fqzcomp -n 1 -s 1 -q 1 $OUTPUT $OUTPUT.fqz 2> report_sorted_fqz.txt
    fi
  #
  if [[ "$RUN_LZMA" -eq "1" ]];
    then
    ./xz -9 --extreme $READS 2> report_original_lzma.txt
    ./xz -9 --extreme $OUTPUT 2> report_sorted_lzma.txt
    fi
  #
  if [[ "$RUN_JARVIS" -eq "1" ]];
    then
    ./JARVI3.sh --fastq --block 250MB --threads 2 --level 17 --input $READS 2> report_original_jarvis3.txt
    ./JARVI3.sh --fastq --block 250MB --threads 2 --level 17 --input $OUTPUT 2> report_sorted_jarvis3.txt
    fi
  #
  NLINES=`wc -l $READS | awk '{ print $1; }'`;
  echo "scale=2; ((($NLINES/4) * l($NLINES/4)/l(10)) - (($NLINES/4) * 1.442695))/8" \
  | bc -l > report_permutations.txt
  cat report_permutations.txt
  # 
  fi
#
################################################################################
#
