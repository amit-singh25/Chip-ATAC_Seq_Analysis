#!/bin/bash
#PBS -N bwa 
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

index=~/genome/mouse/bwa
out=~/chip_ana
data=~/chip_data

#### creat index first
#bwa index -a bwtsw mouse_genome.fa

bwa mem -t 16 ${index}/mouse_genome ${data}/${name}_1.fastq -2 ${data}/${name}_2.fastq >${out}/${name}.sam

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
