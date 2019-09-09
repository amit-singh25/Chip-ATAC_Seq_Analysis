col = SushiColors(2)(2)[1]
bheight = 0.3
lheight = 0.3
bentline = TRUE
packrow = TRUE
maxrows = 10000
colorby = NULL
colorbyrange = NULL
colorbycol = colorRampPalette(c("blue","red"))
types = "exon"
plotgenetype = "box"
arrowlength = 0.005 
wigglefactor = 0.05
labeltext = TRUE
labeloffset = 0.4 
fontsize = 0.7
fonttype = 2
labelat = "middle"

labeltext=T
plotgenetype="arrow"
fontsize=1
arrowlength = 0.005
labeloffset=.4
maxrows=6


mergetypes <- function(exons) {
  newexons = c()
  for (subtype in names(table(exons[, 7]))) {
    subexons = exons[which(exons[, 7] == subtype), ]
    subexons = subexons[order(subexons[, 2]), ]
    if (nrow(subexons) == 0) {
      next
    }
    i = 0
    for (j in (1:nrow(subexons))) {
      i = i + 1
      if (i > 1) {
        if (subexons[j, 2] <= curstop) {
          subexons[j, 2] = curstart
          subexons[j, 3] = max(subexons[j, 3], curstop)
        }
      }
      curstart = subexons[j, 2]
      curstop = subexons[j, 3]
    }
    for (startpos in names(table(subexons[, 2]))) {
      subexons[which(subexons[2] == startpos), 3] = max(subexons[which(subexons[2] == 
                                                                         startpos), 3])
    }
    subexons = subexons[!duplicated(subexons), ]
    newexons = rbind(newexons, subexons)
  }
  return(newexons)
}
plottranscript <- function(exons, col, yvalue, bheight, lheight, 
                           bentline = TRUE, border = "black", arrowlength, bprange, 
                           strandlength = 0.04, strandarrowlength = 0.1, plotgenetype = "box", 
                           labeltext = TRUE, labeloffset = 0.4, fontsize = 0.7, 
                           fonttype = 2, labelat = "middle", ...) {
  strand = exons[1, 6]
  labellocation = mean(c(max(exons[, c(2, 3)]), min(exons[, 
                                                          c(2, 3)])))
  if (labeltext == TRUE) {
    if ((labelat == "start" & strand == 1) || (labelat == 
                                               "end" & strand == -1)) {
      labellocation = min(exons[, c(2, 3)])
    }
    if ((labelat == "start" & strand == -1) || (labelat == 
                                                "end" & strand == 1)) {
      labellocation = max(exons[, c(2, 3)])
    }
    adj = 0
    if (strand == 1) {
      adj = 1
    }
    text(labellocation, yvalue + labeloffset, labels = exons[1, 
                                                             4], adj = adj, cex = fontsize, font = fonttype)
    arrows(labellocation + strand * bprange * strandlength/4, 
           yvalue + labeloffset, labellocation + strand * 
             bprange * strandlength, yvalue + labeloffset, 
           length = strandarrowlength)
  }
  min = apply(exons[, c(2, 3)], 1, min)
  max = apply(exons[, c(2, 3)], 1, max)
  exons[, 2] = min
  exons[, 3] = max
  exons = mergetypes(exons)
  exons = exons[order(exons[, 2], exons[, 3]), ]
  allexons = exons
  allexons$types = "exon"
  allexons = mergetypes(allexons)
  if (nrow(allexons) > 1) {
    linecoords = cbind(allexons[(1:nrow(allexons) - 1), 
                                3], allexons[(2:nrow(allexons)), 2])
    linecoords = cbind(linecoords, apply(linecoords, 
                                         1, mean))
    top = yvalue
    if (bentline == TRUE) {
      top = yvalue + lheight
    }
    for (i in (1:nrow(linecoords))) {
      if ((linecoords[i, 2] - linecoords[i, 1]) > 0) {
        segments(x0 = linecoords[i, 1], x1 = linecoords[i, 
                                                        3], y0 = yvalue, y1 = top, col = col, ...)
        segments(x0 = linecoords[i, 3], x1 = linecoords[i, 
                                                        2], y0 = top, y1 = yvalue, col = col, ...)
      }
    }
  }
  for (i in (1:nrow(exons))) {
    height = bheight
    if (exons[i, 7] == "utr") {
      height = bheight/2
    }
    if (plotgenetype == "box") {
      rect(xleft = exons[i, 2], ybottom = yvalue - 
             height, xright = exons[i, 3], ytop = yvalue + 
             height, col = col, border = col, ...)
    }
    if (plotgenetype == "arrow") {
      strand = exons[i, 6]
      offset = bprange * arrowlength * strand * -1
      x = c(exons[i, 2], exons[i, 2] + offset, exons[i, 
                                                     3] + offset, exons[i, 3], exons[i, 3] + offset, 
            exons[i, 2] + offset, exons[i, 2])
      y = c(yvalue, yvalue + height, yvalue + height, 
            yvalue, yvalue - height, yvalue - height, yvalue)
      polygon(x = x, y = y, col = col, border = col, 
              ...)
    }
  }
}


