
# Chip seq and ATAC seq analysis pipeline
## Table of contents
* [Quality control](#Quality-control)
* [Alignment](#Alignment)
* [Peak Calling](#Peak-Calling)
* [Peak annotation](#peak-annotation)


## Quality control
### FastQC
It is generally a good idea to generate some quality metrics for your raw sequence data using FastQC.

## Alignment
The next step is to align the reads to a reference genome. There are many programs available to perform the alignment. Two of the most popular are [BWA](http://bio-bwa.sourceforge.net/bwa.shtml) and [Bowtie2](http://bowtie-bio.sourceforge.net/index.shtml). We will focus on Bowtie2 here.

## Peak Calling
Model-based Analysis of ChIP-Seq [(MACS2)](http://liulab.dfci.harvard.edu/MACS/index.html) is a program for detecting regions of genomic enrichment. Altough MACS2 initially designed for  ChIP-seq, but it works nicely on ATAC-seq aswell and other genome-wide enrichment assays that have narrow peaks. 

## Peak annotation
[HOMER](http://homer.ucsd.edu/homer/index.html) is a suite of software designed for motif discovery. It takes a MACS peak file bed format as a input and checks for the enrichment of both known sequence motifs and de novo motifs and annotate the peak based on the genome co-ordinate.
