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
## peak calling:

macs2 callpeak -t ${data}/treat_sort.bam -c ${data}/control_sort.bam -f BAM -g mm B -q 0.01 --outdir macs2 -n test -

##broad peak calling: 
macs2 callpeak -t ${data}/treat_sort.bam -c ${data}/control_sort.bam --broad -g mm --broad-cutoff 0.1 --outdir macs2 -n test_brod

macs14 callpeak -t ${data}/treat_sort.bam -c ${data}/control_sort.bam -g mm -p 1e-6 --outdir macs2 -n test > MACS.out
