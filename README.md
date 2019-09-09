
# Chip seq and ATAC seq analysis pipeline



## Table of contents
* [Required packages](#QRequired-packages)
* [Quality control](#Quality-control)
* [Alignment and filtering](#Alignment-filtering )
* [Peak Calling](#Peak-Calling)
* [Peak annotation](#peak-annotation)

Required packages for processing the ATAC-seq pipeline.

Following softwear can be install in the cluster either from source code or from conda platform (https://conda.io/en/latest/) 

[FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

[Flexbar](https://github.com/seqan/flexbar)

[Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)

[samtools](http://samtools.sourceforge.net/)

[PICARD](https://broadinstitute.github.io/picard)

[deepTools](https://deeptools.readthedocs.io/en/develop/)

[MACS2](https://github.com/taoliu/MACS)

[HOMER](http://homer.ucsd.edu/homer/)

R environment 

The R package [ATACseqQC](https://bioconductor.org/packages/release/bioc/html/ATACseqQC.html) and its associated dependencies.

## Quality control

### FastQC
It is generally a good idea to generate some quality metrics for raw sequence data using [FastQC]( https://www.bioinformatics.babraham.ac.uk/projects/fastqc/). 

Quality-based trimming as well as Adapter removal can be done in [Flexbar](https://github.com/seqan/flexbar)

## Alignment and filtering 
#### Genome indexing

For many model organisms, the genome and pre-built reference indexes are available from [iGenomes](https://support.illumina.com/sequencing/sequencing_software/igenome.html). Bowtie2 indexes can be made directly from [FASTA] (ftp://ftp.ensembl.org/pub/release-97/fasta/)genome file using bowtie2-buid. 

#### Alignment

The next step is to align the reads to a reference genome. There are many programs available to perform the alignment. Two of the most popular are [BWA](http://bio-bwa.sourceforge.net/bwa.shtml) and [Bowtie2](http://bowtie-bio.sourceforge.net/index.shtml). Here focus more on Bowtie2.

## Alignment Manipulation
#### Mitochondrial reads

It is known problem that ATAC-seq datasets usually contain a large percentage of reads that are derived from mitochondrial DNA.
Regardless of lab protocol, it is obvious to have some mitochondrial reads in the sequence data. Otehr hand there are no ATAC-seq peaks of interest in the mitochondrial genome. Therefore, we need to remove mitochondrial genome from further analysis.
Two way one can proceed.

1. Remove the mitochondrial genome from the reference genome before aligning the reads. In this approach the alignment numbers will look much worse; all of the mitochondrial reads will count as unaligned.

2. Remove the mitochondrial reads after alignment. 

#### PCR duplicates

During library preparation procedure some PCR artifacts may arise that might interfere with the biological signal of interest 
Therefore, they should be removed as part of the analysis pipeline before peak calling. 
One commonly used program for removing PCR duplicates is Picard’s MarkDuplicates (https://broadinstitute.github.io/picard/). Removal of PCR duplicates may not necessary in Chip seq data.To undertand the samtool format in https://www.samformat.info/sam-format-flag

#### Non-unique alignments

ENCODE or in some papers, people are used to remove unmapped, duplicates and properly mapped reads(samtoolf flag 1796 or 1804) uisng samtools
samtools view -h -b -F 1804 -f 2 ${name}.bam > ${name}.filtered.bam
# Remove multi-mapped reads (i.e. those with MAPQ < 30, using -q in SAMtools)
samtools view -h -q 30 ${sample}.bam > ${sample}.rmMulti.bam

Remove multi-mapped reads (i.e. those with MAPQ < 30, using -q in SAMtools)
## Peak Calling
Model-based Analysis of ChIP-Seq [(MACS2)](http://liulab.dfci.harvard.edu/MACS/index.html) is a program for detecting regions of genomic enrichment. Altough MACS2 initially designed for  ChIP-seq, but it works nicely on ATAC-seq aswell and other genome-wide enrichment assays that have narrow peaks. 

## Peak annotation
[HOMER](http://homer.ucsd.edu/homer/index.html) is a suite of software designed for motif discovery. It takes a MACS peak file bed format as a input and checks for the enrichment of both known sequence motifs and de novo motifs and annotate the peak based on the genome co-ordinate.
