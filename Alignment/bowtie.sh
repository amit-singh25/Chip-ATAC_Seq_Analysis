#!/bin/bash
#PBS -N bowtie 
##PBS -j oe 
##PBS -l file=100GB
#PBS-l mem=32G
#PBS -l walltime=50:13:59
#PBS -l nodes=1:ppn=8   
#PBS -o bowtie.stdout
#PBS -e bowtie.stderr

echo $PBS_JOBID
echo $PBS_JOBNAME
cd $PBS_O_WORKDIR

name=$1

index=~/igenome/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index
out=~/chip_ana
data=~/chip_data

#flexbar -r wcc_tap_1.fastq -t wcc_tap_1_trimmed -z GZ -m 30 -a Adapter.fa
#flexbar -r wcc_tap_1.fastq -t wcc_tap_1_trimmed -z GZ -m 30 -a adapter.fa

bowtie2 -p 8 -x ${index} -sensitive-local -q -1 ${data}/${name}_1.fastq -2 ${data}/${name}_2.fastq -S ${out}/${name}.sam
##convert sam file to bam 
samtools view -bS ${out}/${name}.sam > ${out}/${name}.bam
##sort bam file 
samtools sort ${out}/${name}.bam >${out}/${name}_sort.bam
##index bam file
samtools index ${out}/${name}_sort.bam
##convert bigwig file
bamCoverage -b ${out}/${name}_sort.bam -o ${out}/${name}_sort.bigWig
##convert bam file to bed file 
bedtools bamtobed -${out}/${name}_sort.bam > ${out}/${name}_sort.bed

picard MarkDuplicates \
INPUT=${name}_sort.bam \
OUTPUT=${name}_sort_marked.bam \
METRICS_FILE=${name}.sorted.metrics \
REMOVE_DUPLICATES=false \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=LENIENT 

# REMOVE_DUPLICATES=false: mark duplicate reads, not remove.
# Change it to true to remove duplicate reads.
#MarkDuplicates will add a FALG 1024 to duplicate reads, we can remove them using samtools:
samtools view -h -b -F 1024 ${name}_sort_marked.bam >${name}_sort_mark.rmDup.bam


##convert bigwig file
bamCoverage -b ${out}/${name}_sort.bam -o ${out}/${name}_sort.bigWig
##convert bam file to bed file 
bedtools bamtobed -${out}/${name}_sort.bam > ${out}/${name}_sort.bed


######single end
bowtie2 -p 8 -x ${index}/genome -sensitive-local -U ${data}/${name}.fastq -S ${out}/${name}.sam
samtools view -bS ${out}/${name}.sam > ${out}/${name}.bam
samtools sort ${out}/${name}.bam >${out}/${name}_sort.bam
samtools index ${out}/${name}_sort.bam
bedtools bamtobed -i ${out}/${name}_sort.bam >${out}/${name}_sort.bed
bamCoverage -b ${out}/${name}_sort.bam -o ${out}/${name}_sort.bigWig
