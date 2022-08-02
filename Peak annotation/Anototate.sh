#!/bin/bash
#PBS -N macs
##PBS -j oe 
##PBS -l file=100GB
#PBS-l mem=100G
#PBS -l walltime=50:13:59
#PBS -l nodes=1:ppn=8   
#PBS -o macs.stdout
#PBS -e macs.stderr
name=$1
out=/home/bq_asingh/chip_ana
data=/home/bq_asingh/chip_data
genome=/home/bq_asingh/genome
## peak calling:

#####peak anotate by homer 
findMotifsGenome.pl ${name}.bed ${genome}/toplevel.fa OutputResults/
####anotate peak by homer eith gene id
annotatePeaks.pl ${name}.bed ${genome}/toplevel.fa -gtf ${genome}/gene.gtf -gid -hist 10 >peaks_annotate_gid.xls 
