library(xlsx)
library(vioplot)

d = read.xlsx('Fig3.xlsx', sheetName = 'Fig_3c')

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
