# MizaR
#

Prepare data and install tools:
```
apt-get install art-nextgen-simulation-tools
chmod +x *.sh
./MizaR.sh --install
lzma -d VDB_MT_ALL_REF.fa.lzma
```
For compressing a metagenomic FASTQ file:
```
./Mizar --reads reads.fq --database VDB_MT_ALL_REF.fa \        
 --output compressed_reads.fq.mr --threads 8
```
To run coverage and sequences experiments:

```
./RunAll.sh 1> report-stdout.txt 2> report-stderr.txt &
```
