# MizaR
#

Prepare data and install tools:
```
apt-get install art-nextgen-simulation-tools
chmod +x *.sh
./MizaR.sh --install
lzma -d VDB_MT_ALL_REF.fa.lzma
```
Then, run the experiments:

```
./RunAll.sh 1> report-stdout.txt 2> report-stderr.txt &
```
