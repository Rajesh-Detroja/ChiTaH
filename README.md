# ChiTaH
### A fast and accurate reference–based approach to identify known human chimeras or fusion genes

## Installations

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
