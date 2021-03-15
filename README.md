# ChiTaH
### A fast and accurate reference–based approach to identify known human chimeras or fusion genes

<br></br>

## Installations

**Download ChiTaH by using following command or Download as ZIP**

```bash
git clone https://github.com/Rajesh-Detroja/ChiTaH.git
```

**Download Bowtie2 index of pan-reference database and other reference files as follows:**

```bash
wget 
```

**Download test datasets as follows:**

```bash
wget 
```

**Following dependencies must be installed and setuped in your system profile**

**[Bowtie2 -v 2.3.3.1](https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.3.1/)**

**[sambamba -v 0.6.6](https://github.com/biod/sambamba/releases/tag/v0.6.6)**

**[bedtools -v 2.26.0](https://github.com/arq5x/bedtools2/releases/tag/v2.26.0)**

**[merge]()**

<br></br>

## Setting up config file

Config files is provided in ChiTaH packaged names as `ChiTaH.txt`

After downloading ChiTaH and it's index of pan-reference database and other reference files, please replace <FULL_PATH> with the complete path in your system.

<br></br>

## How to use ChiTaH for paired-end datasets

**Example Fastq files:**

```text
sample_1.R1.fastq.gz

sample_1.R2.fastq.gz

sample_2.R1.fastq.gz

sample_2.R2.fastq.gz
```

**Run ChiTaH:**

```bash
bash ChiTaH.sh -1 .R1.fastq.gz -2 .R2.fastq.gz -c config.txt
```

That's it! This command will automatically run paired-end datasets of sample 1 and sample 2 and it will generated output matrix table in the file `all_chimeras.tsv`

<br></br>

## How to use ChiTaH for single-end datasets

**Example Fastq files:**

```text
sample_1.fastq.gz

sample_2.fastq.gz
```

**Run ChiTaH:**

```bash
bash ChiTaH.sh -1 .fastq.gz -c config.txt
```

That's it! This command will automatically run single-end datasets of sample 1 and sample 2 and it will generate output matrix table in the file `all_chimeras.tsv`
