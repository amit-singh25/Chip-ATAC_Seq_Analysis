
# Chip seq and ATAC seq analysis pipeline



## Table of contents
* [Required packages](#QRequired-packages)
* [Quality control](#Quality-control)
* [Alignment](#Alignment)
* [Peak Calling](#Peak-Calling)
* [Peak annotation](#peak-annotation)

Required packages for processing the ATAC-seq pipeline
Following softwear can be install in the cluster either from source code or from conda platform (https://conda.io/en/latest/) 

FastQC  https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
Bowtie2  http://bowtie-bio.sourceforge.net/bowtie2/index.shtml

samtools http://samtools.sourceforge.net/

PICARD tools https://broadinstitute.github.io/picard/

deepTools https://deeptools.readthedocs.io/en/develop/

MACS2  https://github.com/taoliu/MACS

HOMER http://homer.ucsd.edu/homer/

R environment 

The R package ATACseqQC (https://bioconductor.org/packages/release/bioc/html/ATACseqQC.html) and its associated dependencies.

## Quality control
### FastQC
It is generally a good idea to generate some quality metrics for raw sequence data using FastQC.

## Alignment
The next step is to align the reads to a reference genome. There are many programs available to perform the alignment. Two of the most popular are [BWA](http://bio-bwa.sourceforge.net/bwa.shtml) and [Bowtie2](http://bowtie-bio.sourceforge.net/index.shtml). We will focus on Bowtie2 here.

### Mitochondrial reads
It is known problem that ATAC-seq datasets usually contain a large percentage of reads that are derived from mitochondrial DNA.
Regardless of lab protocol, it is obvious to have some mitochondrial reads in the sequence data. Since there are no ATAC-seq peaks of interest in the mitochondrial genome, these reads will only complicate the subsequent steps. Therefore, we need to remove from further analysis.

1. Remove the mitochondrial genome from the reference genome before aligning the reads. In this approach the alignment numbers will look much worse; all of the mitochondrial reads will count as unaligned.

2. Remove the mitochondrial reads after alignment. A python script, creatively named removeChrom, is available in the ATAC-seq module to accomplish this. For example, to remove all 'chrM' reads from a BAM file, one would run this:



## Peak Calling
Model-based Analysis of ChIP-Seq [(MACS2)](http://liulab.dfci.harvard.edu/MACS/index.html) is a program for detecting regions of genomic enrichment. Altough MACS2 initially designed for  ChIP-seq, but it works nicely on ATAC-seq aswell and other genome-wide enrichment assays that have narrow peaks. 

## Peak annotation
[HOMER](http://homer.ucsd.edu/homer/index.html) is a suite of software designed for motif discovery. It takes a MACS peak file bed format as a input and checks for the enrichment of both known sequence motifs and de novo motifs and annotate the peak based on the genome co-ordinate.
