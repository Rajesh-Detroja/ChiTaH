# ChiTaH
### ChiTaH: A fast and accurate tool for identifying known human chimeric sequences from high-throughput sequencing data

Fusion genes or chimeras typically comprise sequences from two different genes. The chimeric RNAs of such joined sequences often serve as cancer drivers. Identifying such driver fusions in a given cancer or complex disease is important for diagnosis and treatment. The advent of next-generation sequencing technologies, such as DNA–Seq or RNA–Seq, together with the development of suitable computational tools, has made the global identification of chimeras in tumors possible. However, the testing of over 20 computational methods showed these to be limited in terms of chimera prediction sensitivity, specificity, and accurate quantification of junction reads. These shortcomings motivated us to develop the first "reference-based" approach termed ChiTaH (Chimeric Transcripts from High–throughput sequencing data). ChiTaH uses 43,466 non–redundant known human chimeras as a reference database to map sequencing reads and to accurately identify chimeric reads. We benchmarked ChiTaH and four other methods to identify human chimeras, leveraging both simulated and real sequencing datasets. ChiTaH was found to be the most accurate and fastest method for identifying known human chimeras from simulated and sequencing datasets. Moreover, especially ChiTaH uncovered heterogeneity of the BCR-ABL1 chimera in both bulk and single-cells of the K-562 cell line, which was confirmed experimentally.

<br></br>

## Installations

**Download ChiTaH by using following command or Download as ZIP**

```bash
git clone https://github.com/Rajesh-Detroja/ChiTaH.git
```

**Download Bowtie2 index of human-chimera-reference database and other reference files as follows:**

[human-chimera-reference](https://www.dropbox.com/s/0ut34s3tnoqxwcv/pan_reference.zip?dl=0)


**Download test datasets as follows:**

[Test Datasets](https://www.dropbox.com/s/qddy9cexbmali7n/test_datesets.zip?dl=0)


**Following dependencies must be installed and setuped in your system profile**

[Bowtie2 -v 2.3.3.1](https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.3.1/)

[samclip](https://github.com/tseemann/samclip)

[sambamba -v 0.6.6](https://github.com/biod/sambamba/releases/tag/v0.6.6)

[bedtools -v 2.26.0](https://github.com/arq5x/bedtools2/releases/tag/v2.26.0)

[merge](https://www.dropbox.com/s/2jyo4t3y8s1ftwf/merge.zip?dl=0)


<br></br>

## Setting up config file

Config files is provided in ChiTaH packaged named as **`ChiTaH.txt`**

After downloading ChiTaH and it's index of human-chimera-reference database and other reference files, please configure the **`ChiTaH.txt`** as follows:

**threads:** A total number of threads or CPUs (**Default:** 25)

**bowtie2_index:** Set a FULL PATH to the bowtie2 index of the human-chimera-reference database (**i.e.** Index of human_chimeras.fa)

**chimera_bed:** Set a FULL PATH to the BED file of chimeras (**i.e.** chimeras_43466.bed)

**chimera_ANN:** Set a FULL PATH to the ANNOTATION file of chimeras (**i.e.** chimeras_43466.ANN)

**chimera_fa:** Set a FULL PATH to the FASTA file of the chimeras (**i.e.** chimeras_43466.fa)

**depth:** Set a total number of reads to count at unique junctions of chimeras (**Default:** 5)


<br></br>

## How to use ChiTaH for paired-end datasets

**Test Fastq files:**

```text
hybrid_50.R1.fastq

hybrid_50.R2.fastq

hybrid_100.R1.fastq

hybrid_100.R2.fastq
```

**Run ChiTaH:**

```bash
bash ChiTaH.sh -1 .R1.fastq -2 .R2.fastq -c config.txt
```

That's it! This command will automatically run paired-end datasets of samples hybrid_50 and hybrid_100 and it will generated output matrix table in the file `all_chimeras.tsv`

<br></br>

## How to use ChiTaH for single-end datasets

**Test Fastq files:**

```text
hybrid_50.fastq

hybrid_100.fastq
```

**Run ChiTaH:**

```bash
bash ChiTaH.sh -1 .fastq -c config.txt
```

That's it! This command will automatically run single-end datasets of samples hybrid_50 and hybrid_100 and it will generate output matrix table in the file `all_chimeras.tsv`

<br></br>

## Descriptions of Results

**chimera:** GenBank ID of all identified chimera

**chimera_type:** Junction type of identified chimera

**gene1:** Gene name of the first gene in identified chimera

**strand1:** Gene strand of the first gene in identified chimera

**gene2:** Gene name of the second gene in identified chimera

**strand2:** Gene strand of the second gene in identified chimera

**junction_id:** Unique junction region of the identified chimera

**Length:** Length of the unique junction region of the identified chimera

**Sample_1:** A total number of unique junction reads identified in sample_1

**Sample_2:** A total number of unique junction reads identified in sample_2

**Sample_N:** A total number of unique junction reads identified in sample_N
