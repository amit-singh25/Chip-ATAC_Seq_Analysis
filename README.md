
# Chip seq and ATAC seq analysis pipeline



# Table of content
* [Software Requirement](#QRequired-packages)
* [Quality control](#Quality-control)
* [Alignment and filtering](#Alignment-filtering )
* [Peak Calling](#Peak-Calling)
* [Visualization](#Visualization)
* [Peak annotation](#peak-annotation)
* [Identification of Super Enhancers](#peak-annotation)


## Software Requirement

Required packages for processing the ATAC-seq pipeline.

Required packages for processing the ATAC-seq pipeline.

The following software can be installed in the cluster either from source code or from [conda](https://conda.io/en/latest/) platform.

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

``` fasqc SRR446027_1.fastq ```

### Triming 
Quality-based trimming, as well as Adapter removal, can be done in [Flexbar](https://github.com/seqan/flexbar/wiki/Manual)


######## Removing adaptor and quality check for the paired-end result 
```flexbar -r $1 -t $2/$target -n 20 -z BZ2 -m 30 -u 0 -q 28 -a /biosw/flexbar/Adapter.fa -f sanger ```
``` flexbar -r $1 -p $2 -t $3/$target -n 20 -z GZ -m 30 -u 0 -q TAIL -qt 28 -a /biosw/flexbar/Adapter.f -qf sanger -j ```

## Alignment and filtering
#### Genome indexing

For many model organisms, the genome and pre-built reference indexes are available from [iGenomes](https://support.illumina.com/sequencing/sequencing_software/igenome.html). Bowtie2 indexes can be made directly from [FASTA](ftp://ftp.ensembl.org/pub/release-97/fasta/)genome file using bowtie2-build.

#### Alignment

The next step is to align the reads to a reference genome. There are many programs available to perform the alignment. Two of the most popular are [BWA](http://bio-bwa.sourceforge.net/bwa.shtml) and [Bowtie2](http://bowtie-bio.sourceforge.net/index.shtml). Here focus more on Bowtie2.

## Alignment Manipulation

#### Mitochondrial reads

It is a known problem that ATAC-seq datasets usually contain a large percentage of reads that are derived from mitochondrial DNA.
Regardless of lab protocol, it is obvious to have some mitochondrial reads in the sequence data. Other hands there are no ATAC-seq peaks of interest in the mitochondrial genome. Therefore, we need to remove the mitochondrial genome from further analysis.
Two ways one can proceed.

1. Remove the mitochondrial genome from the reference genome before aligning the reads. In this approach the alignment numbers will look much worse; all of the mitochondrial reads will count as unaligned.

2. Remove the mitochondrial reads after alignment.

#### PCR duplicates

During the library preparation procedure some PCR artifacts may arise that might interfere with the biological signal of interest
Therefore, they should be removed as part of the analysis pipeline before peak calling.
One commonly used program for removing PCR duplicates is Picard’s [MarkDuplicates](https://broadinstitute.github.io/picard/). Removal of PCR duplicates may not necessary in Chip seq data. To understand the flag number and [samtool format](https://www.samformat.info/sam-format-flag) look here.


```picard MarkDuplicates I=sample1_sort.bam O=sample1_sort_clean.bam M=dups.txt REMOVE_DUPLICATES=true```
``` macs2 filterdup -i "sample_sorted.bam" -f BAM -g hs --keep-dup=1  --verbose=3 -o "sample_sorted_filterdup.bed" ```

#### Non-unique alignments

ENCODE or in some papers, people are used to removing unmapped, duplicates, and properly mapped reads (samtoolf flag 1796 or 1804) using samtools

```samtools view -h -b -F 1804 -f 2 ${name}.bam > ${name}.filtered.bam ```

Remove multi-mapped reads

``` samtools view -h -q 30 ${name}.bam > ${name}.rmmulti.bam ```

## Peak Calling
Model-based Analysis of ChIP-Seq [(MACS2)](http://liulab.dfci.harvard.edu/MACS/index.html) is a program for detecting regions of genomic enrichment. Although MACS2 was initially designed for  ChIP-seq, it works nicely on ATAC-seq as well and other genome-wide enrichment assays that have narrow peaks.
predict fragment length

```macs2 predictd -i sample_sorted_filterdup.bed -g hs -m 5 20```

```macs2 callpeak -t sample1.fastq_sorted.bam-c control.fastq_sorted.bam -g hs -f BAM --keep-dup auto --bdg --outdir ~/Desktop/peak_folder```

### Select fragment size

```macs2 callpeak -t sample1.fastq_sorted.bam -c control.fastq_sorted.bam -g hs -f BAM --keep-dup auto --bdg --nomodel --extsize 270 --outdir ~/Desktop/peak_folder ```

## Visualization

#### Creating browser tracks
Create a bigWig file for visualizing the peak coverage using bamCoverage in deepTools.
An alternative visualization tool is [Integrative Genomics Viewer](https://software.broadinstitute.org/software/igv/). The Peak files can be loaded directly (File → Load from File). Viewing BAM files with IGV requires sorted (by coordinate) and indexing using SAMtools.
For making a plot BAM file can be converted to bed (bam to bed) using [bedtools](https://bedtools.readthedocs.io/en/latest/content/tools/bamtobed.html) and load to IGV.  

## Peak annotation

[HOMER](http://homer.ucsd.edu/homer/index.html) is a suite of software designed for motif discovery. It takes a MACS peak file bed format as input and checks for the enrichment of both known sequence motifs and de novo motifs and annotates the peak based on the genome coordinate.

## Identification of Super Enhancers
Three key characteristics are used to identify an enhancer region.
1. Active enhancers are found in open chromatin regions devoid of nucleosomes, which allows for binding of the transcriptional machinery, including RNA polymerase, transcription factors, and co-activators.
2. Active enhancer regions are typically enriched with a posttranslational modification histone mark such as monomethylation at H3 lysine 4 (H3K4me1) and acetylation at H3 lysine 27 (H3K27ac).
3. Putative enhancer regions often contain conserved DNA sequences for binding to specific transcription factors.

The tool can be used to find the super enhancer.
[ROSE](http://younglab.wi.mit.edu/super_enhancer_code.html) and
[Homer](http://homer.ucsd.edu/homer/ngs/peaks.html#Finding_Super_Enhancers)

