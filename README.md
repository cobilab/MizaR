# MizaR
#

### Installation ###

If required, install art and cmake tools:
```
sudo apt-get install art-nextgen-simulation-tools
sudo apt-get install cmake
```
Then, install MizaR:
```
git clone https://github.com/cobilab/mizar
cd mizar/
chmod +x *.sh
./MizaR.sh --install
lzma -d VDB_MT_ALL_REF.fa.lzma
```

### Running ###

For compressing a metagenomic FASTQ file:
```
./Mizar --reads reads.fq --database VDB_MT_ALL_REF.fa \        
 --output compressed_reads.fq.mr --threads 8
```

### Parameters ###

To see the possible options type
```
./MizaR.sh
```
or
```
./MizaR.sh --help
```

The info menu contains the following information
```
 -------------------------------------------------------- 
                                                          
                        MizaR                             
                                                          
 Metagenomic information zone arrangement Encoder V1.0    
                                                          
 Program options ---------------------------------------- 
                                                          
 -h, --help                      Show this,               
 -i, --install                   Installation,            
                                                          
 -s <INT>, --similarity <INT>    Minimum similarity,      
 -y <DBL>, --sim-reads <DBL>     Reads similarity,        
 -c <INT>, --cache <INT>         Cache memory (max),      
                                 creating buckets,        
 -t <INT>, --threads <INT>       Number of threads,       
 -o <STR>, --output <STR>        Output file name,        
                                                          
 -f, --fqzcomp                   Run Fqzcomp compressor,  
 -l, --lzma                      Run lzma compressor,     
 -j, --jarvis                    Run JARVIS compressor,   
                                                          
 -r <STR>, --reads <STR>         FASTQ reads (input),     
 -d <STR>, --database <STR>      FASTA Viral Database.    
                                                          
 Example -----------------------------------------------  
                                                          
 ./MizaR.sh --reads reads.fq --database VDB.mfa \        
 --output compressed_reads.fq.mr --fqzcomp --threads 8
 
 -------------------------------------------------------
```

### Experiments ###

To run coverage and sequences experiments:
```
./RunAll.sh 1> report-stdout.txt 2> report-stderr.txt &
```
To run the respective plots:
```
./Plot_sequences.sh
./Plot_coverage.sh
```

### Internal programs ###

MizaR uses the following programs:
```
FALCON
MAGNET
GTO
FQZCOMP
JARVIS3
LZMA
```

### Citation ###

On using this software/method please cite:

* Article in revision

### Issues ###

For any issue let us know at [issues link](https://github.com/cobilab/mizar/issues).

### License ###

GPL v3.

For more information:
[http://www.gnu.org/licenses/gpl-3.0.html](http://www.gnu.org/licenses/gpl-3.0.html).
