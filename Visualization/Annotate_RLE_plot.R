
library(Sushi)
library(GenomicRanges)
library(rtracklayer)
library(Rsamtools)
gtf<-import("~/gene.gtf")
###Read homer annotate peak file  

a<-read.delim("~/peak.txt",header=T,sep=",")
####find total gene that are annotated in homer 
gene<-gtf[((mcols(gtf)$gene_id %in% a$ens.id))]
##subset based on gene type
gene1<-gene[((mcols(gene)$type =="gene"))]
###Add +/- 2000bp from Transcription start site 
last<-(gene1+2000)

### name last, the GRanges object of gene1 in 5 column the
names(last)<-mcols(gene1)[[5]]
######import the bigwig file or bed file in rle format 
Rle.test1<-import("~/test1.ChIP.bw",as="Rle")
####take runmean 
Rle.test11<-S4Vectors::runmean(Rle.test1,101,endrule ="constant")
#######

Rle.test2<-import("~/test2.bw",as="Rle")
Rle.test2<-S4Vectors::runmean(Rle.test2,101,endrule ="constant")

test1.Profiles<-Rle.test1[last]
for (i in 1:length(test1.Profiles)){
if(as.vector(strand(last))[i]=="-"){
test1.Profiles[[i]]<-rev(test1.Profiles[[i]])
}
}

test2.Profiles<-Rle.test2[last]
for (i in 1:length(test2.Profiles)){
if(as.vector(strand(last))[i]=="-"){
test2.Profiles[[i]]<-rev(test2.Profiles[[i]])
}
}

###stored the plot in images folder as a png format, later that can be visualize in html format uing hwriter

setwd("~/Desktop/images)

for(i in 1:length(test2.Profiles)) {
  png(file = paste(names(last)[i],".png",sep=""))
  par(mfrow=c(2,1))
  plot( test2.Profiles[[i]],type="l",xlab="Base",ylab="Reads",main=names(last)[i],
        axes=F,lwd=2,ylim=c(0,max(c(test2.Profiles[[i]],test1.Profiles[[i]]))))
  if(as.character(strand((last)[i]))=="+"){
    axis(side=1,at=c("0","2000", length(test2.Profiles[[i]])-2000, length(test2.Profiles[[i]])),labels=c("-2000","TSS","TTS","+2000"))
  }else{
    axis(side=1,at=c("0","2000", length(test2.Profiles[[i]])-2000, length(test.Profiles[[i]])),labels=c("+2000","TTS","TSS","-2000"))
  }
  axis(side=2)
  #axis(side=4,at=c("0"),labels=c("0"))
  box()
  #par(new=TRUE)
  par(new=TRUE)
  plot(test1.Profiles[[i]], type = "l", xlab="", ylab="", col = "red", lwd=2,axes=FALSE)
  axis(4, col="red",ylim=c(min(test1.Profiles), max(test1.Profiles)))
  mtext("test1.Profiles", side=4, line=0.2)
  legend("topright",c("test2.Profiles","test1.Profiles"),fill=c("black","red"))
  dev.off()
}
