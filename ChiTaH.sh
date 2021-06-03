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
			(bowtie2 --local -p $threads -x $X -1 ${R1[i]} -2 ${R2[i]} | samclip --ref $X | grep -v -e "chr" -e "HLA" -e "ENST" > $sample.chimera.sam)2>$sample.chimera.log
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
			(bowtie2 --local -p $threads -x $X -U ${R1[i]} | samclip --ref $X | grep -v -e "chr" -e "HLA" -e "ENST" > $sample.chimera.sam)2>$sample.chimera.log
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

rm -rf *.chimera.sam.bam.sorted.bam.bed *.chimera.sam.bam.sorted.bam.bed.coverage *.chimera.sam.bam.sorted.bam.bed.coverage.junction chimeras.tsv exon_exon_chimeras_sequence.fnn#

echo "Done!"
