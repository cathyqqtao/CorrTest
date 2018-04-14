library(xlsx)
library(vioplot)

## Fig. 6a
d = read.xlsx('Fig6.xlsx',sheetName = 'v')
v = d$true_v
v.mc2t = d$MC2T_v

plot(v, v.mc2t, xlim=c(0,0.4), ylim=c(0,0.5), pch=18, cex=0.6, xaxs = "i", yaxs = "i", axes=FALSE, main='', xlab='', ylab='')
abline(0, 1.09, lwd=2, col='gray')
axis(1, cex.axis=1.3)
axis(2, cex.axis=1.3)
title(ylab='inferred v')
title(xlab='true v')

## Fig. 6b
d = read.xlsx('Fig6.xlsx', sheetName = 'taxonSampling')

ar.400 = d$AR_400taxa
ar.300 = d$AR_300taxa
ar.200 = d$AR_200taxa
ar.100 = d$AR_100taxa
ar.50 = d$AR_50taxa

plot(1, type='n', xlim=c(0.5,5.5),ylim=c(0,1),axes=FALSE,, xaxs = "i", yaxs = "i",  main='', xlab='', ylab='')
vioplot(ar.400, col='gold',colMed='black', rectCol = 'white', pchMed=18, drawRect=FALSE, at=1, add=TRUE)
vioplot(ar.300, col='gold',colMed='black', rectCol = 'white', pchMed=18, drawRect=FALSE, at=2, add=TRUE)
vioplot(ar.200, col='gold',colMed='black', rectCol = 'white', pchMed=18, drawRect=FALSE, at=3, add=TRUE)
vioplot(ar.100, col='gold',colMed='black', rectCol = 'white', pchMed=18, drawRect=FALSE, at=4, add=TRUE)
vioplot(ar.50, col='gold',colMed='black', rectCol = 'white', pchMed=18, drawRect=FALSE, at=5, add=TRUE)
axis(1, at=c(0.5,1,2,3,4,5,5.5), cex.axis=1.3)
axis(2, cex.axis=1.3)
title(xlab='taxon sampling')
title(ylab='CorrTest score')
