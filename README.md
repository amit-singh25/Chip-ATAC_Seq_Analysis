
# Chip seq and ATAC seq analysis pipeline



## Table of contents
* [Required packages](#QRequired-packages)
* [Quality control](#Quality-control)
* [Alignment](#Alignment)
* [Peak Calling](#Peak-Calling)
* [Peak annotation](#peak-annotation)







Required packages for executing basic ATAC-seq pipeline
When executing basic ATAC-seq pipeline, user should install following packages / libraries in the system:

Bowtie2 (we have used version 2.3.3.1) http://bowtie-bio.sourceforge.net/bowtie2/index.shtml

samtools (we have used version 1.6) http://samtools.sourceforge.net/

PICARD tools (we have used 2.7.1 version) https://broadinstitute.github.io/picard/

Utilities "bedGraphToBigWig", "bedSort", "bigBedToBed", "hubCheck" and "fetchChromSizes" downloaded from UCSC repository. Executables corresponding to the linux system, for example, is provided in this link: http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/

deepTools (we have used version 2.0) https://deeptools.readthedocs.io/en/develop/

MACS2 (we have used version 2.1.1) https://github.com/taoliu/MACS

HOMER (we recommend using the latest version) http://homer.ucsd.edu/homer/

R environment (we have used 3.4.3)

The R package ATACseqQC (https://bioconductor.org/packages/release/bioc/html/ATACseqQC.html) and its associated dependencies.

Python version 2.7, along with the package levenshtein (pip install python-levenshtein)

User should include the PATH of above mentioned libraries / packages inside their SYSTEM PATH variable. Some of these PATHS are also to be mentioned in a separate configuration file (mentioned below).

Required packages for executing IDR code













## Quality control
### FastQC
It is generally a good idea to generate some quality metrics for your raw sequence data using FastQC.

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
