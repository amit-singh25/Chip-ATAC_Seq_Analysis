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

index=~/igenome/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index
out=~/chip_ana
data=~/chip_data

#### creat index first
#bwa index -a bwtsw mouse_genome.fa
