#!/usr/bin

while getopts ":1:2:c:" opt; do
  case $opt in
    1) read_1="$OPTARG"
    ;;
    2) read_2="$OPTARG"
    ;;
    c) config="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

## Source config file
source $config


## MAPPING
## =======
X=$bowtie2_index

R1=(*$read_1)
R2=(*$read_2)

suffix="$read_1"

if [ ! -z $read_2 ];
then

	if [ ! -z $read_1 ] && [ ! -z $read_2 ] && [ ! -z $config ];
	then
		for ((i=0;i<${#R1[@]};i++)); do
			sample=${R1[i]%$suffix}
			(bowtie2 --local -p $threads -x $X -1 ${R1[i]} -2 ${R2[i]} | grep -v -e "chr" -e "HLA" -e "ENST" > $sample.chimera.sam)2>$sample.chimera.log
		done
	else
		echo "Issue!"
		exit;
	fi

else


	if [ ! -z $read_1 ] && [ -z $read_2 ] && [ ! -z $config ];
	then
		for ((i=0;i<${#R1[@]};i++)); do
			sample=${R1[i]%$suffix}
			(bowtie2 --local -p $threads -x $X -U ${R1[i]} | grep -v -e "chr" -e "HLA" -e "ENST" > $sample.chimera.sam)2>$sample.chimera.log
		done
	else
		echo "Issue!"
		exit;
	fi

fi

<< 'MULTILINE-COMMENT'
MULTILINE-COMMENT

for i in *.chimera.sam ; do sambamba view -t $threads -S -F "not unmapped and mapping_quality >= 10" -f bam -o $i.bam $i ; done

rm -rf *.chimera.sam

for i in *.chimera.sam.bam ; do sambamba sort --tmpdir=. -t $threads -o $i.sorted.bam $i ; done

rm -rf *.chimera.sam.bam

for i in *.chimera.sam.bam.sorted.bam ; do sambamba index -t $threads $i ; done

for i in *.chimera.sam.bam.sorted.bam ; do bedtools coverage -f 1.00 -a $chimera_bed -b $i > $i.bed ; done

for i in *.chimera.sam.bam.sorted.bam.bed ; do awk -v depth=$depth '($7 >= 1 && $4 >= depth)' $i | awk 'BEGIN { OFS="\t"; print "chimera", "start", "end", "depth", "covered_bp", "Junction_length", "coverage" } { print $0, "" }' > $i.coverage ; done

for i in *.chimera.sam.bam.sorted.bam.bed.coverage ; do if [[ $(wc -l < $i ) -lt 2 ]] ; then awk 'BEGIN { OFS="\t"; print "NO_Chimera", "NA", "NA", "NA", "NA", "NA", "NA" }' >> $i ; fi ; done

for i in *.chimera.sam.bam.sorted.bam.bed.coverage ; do awk 'NR>1 {print $1,"\t",$4}' $i > ${i}.junction ; done

for i in *.chimera.sam.bam.sorted.bam.bed.coverage.junction ; do file=TheFileName ; sed -i '1{h;s/.*/chimera '"${i%?????????????????????????????????????????????????}"'/;G}' "$i" ; done

merge -k -e "0" *.chimera.sam.bam.sorted.bam.bed.coverage.junction > chimeras.tsv

head -n 1 chimeras.tsv | awk '{$1=$1 "\t" "chimera_type" "\t" "gene1" "\t" "strand1" "\t" "gene2" "\t" "strand2" "\t" "junction_id" "\t" "Length"}1' OFS="\t" > all_chimeras.tsv

join $chimera_ANN <(sort -k1,1 chimeras.tsv) | awk -v OFS="\t" '$1=$1' | sort -k2,2 >> all_chimeras.tsv

#grep -e "^chimera" -e "exon-exon" all_chimeras.tsv | awk 'NR == 1; NR > 1 {print $0 | "sort -k9nr"}' > exon_exon_chimeras.tsv

## get junction and chimera sequences
#cut -f7 all_chimeras.tsv | grep -v "^junction_id" | sed 's/:/\t/g' | sed 's/-/\t/g' | bedtools getfasta -fi $chimera_fa -bed - > all_chimeras_junctions.fa

#cut -f7 all_chimeras.tsv | grep -v "^junction_id" | cut -d":" -f1 | while read id ; do samtools faidx $chimera_fa ${id} >> all_chimeras_sequence.fa ; done

#samtools faidx all_chimeras_sequence.fa


## Call consensus sequence
#samtools mpileup -uf $chimera_fa *.chimera.sam.bam.sorted.bam | bcftools call -c | vcfutils.pl vcf2fq | seqtk seq -AQ64 > consensus_sequence.fa

#samtools faidx consensus_sequence.fa

#cut -f7 all_chimeras.tsv | grep -v "^junction_id" | sed 's/:/\t/g' | sed 's/-/\t/g' | bedtools getfasta -fi consensus_sequence.fa -bed - > all_chimeras_consensus_junction.fa

#rm -rf consensus_sequence.fa all_chimeras_sequence.fa.fai


## Predict ORF / Protein Sequence

#chimera_out=exon_exon_chimeras_sequence.fa

#date && time getorf -sequence $chimera_out -outseq ${chimera_out%???}".fnn" -minsize 75 -find 1

#perl -pe '$. > 1 and /^>/ ? print "\n" : chomp' ${chimera_out%???}".fnn" > $chimera_out".1_line.fnn"

#cut -f7 exon_exon_chimeras.txt | grep -v "^junction_id" | cut -d":" -f1 | while read id ; do sed -n -e '/^>'${id}'_/{$!N;p;}' -e h $chimera_out".1_line.fnn" > ${id}".fnn" ; done

#cut -f7 exon_exon_chimeras.txt | grep -v "^junction_id" | cut -d":" -f1 | while read id ; do awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' ${id}".fnn" | awk -F '\t' '{printf("%d\t%s\n",length($2),$0);}' | sort -k1,1nr | cut -f 2- | tr "\t" "\n" | head -n 2 > ${id}".1.fnn" ; done

#cat *.1.fnn | sed '/^$/d' > exon_exon_chimeras_protein.fnn

#cut -f7 exon_exon_chimeras.txt | grep -v "^junction_id" | cut -d":" -f1 | while read id ; do rm -rf ${id}".fnn" ; done

#rm -rf *.1_line.fnn rm -rf *.1.fnn

#Rscript /home/morgensternlab/detrojar/scripts/RPKM_TPM.R chimeras.txt

rm -rf *.chimera.sam.bam.sorted.bam.bed *.chimera.sam.bam.sorted.bam.bed.coverage *.chimera.sam.bam.sorted.bam.bed.coverage.junction chimeras.tsv exon_exon_chimeras_sequence.fnn#

echo "Done!"
