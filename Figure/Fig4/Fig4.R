library(xlsx)

d = read.xlsx('Fig4.xlsx',sheetName = 'AR_HME')
ar.ar.hme = d$lnK_AR
ar.ir.hme = d$lnK_UCLN
ar.lnL.diff.hme = (ar.ar.hme-ar.ir.hme)*2

d = read.xlsx('Fig4.xlsx',sheetName = 'IR_HME')
ir.ar.hme = d$lnK_AR
ir.ir.hme = d$lnK_UCLN
ir.lnL.diff.hme = (ir.ar.hme-ir.ir.hme)*2

d = read.xlsx('Fig4.xlsx',sheetName = 'AR_SS')
ar.ar.ss = d$lnK_AR
ar.ir.ss = d$lnK_UCLN
ar.lnL.diff.ss = (ar.ar.ss-ar.ir.ss)*2
ar.lnL.diff.ss = ar.lnL.diff.ss[!is.na(ar.lnL.diff.ss)]

d = read.xlsx('Fig4.xlsx',sheetName = 'IR_SS')
ir.ar.ss = d$lnK_AR
ir.ir.ss = d$lnK_UCLN
ir.lnL.diff.ss = (ir.ar.ss-ir.ir.ss)*2
ir.lnL.diff.ss = ir.lnL.diff.ss[!is.na(ir.lnL.diff.ss)]

d = read.xlsx('Fig4.xlsx',sheetName = 'AR_CorrTest')
ar.corrtest = d$CorrTest

d = read.xlsx('Fig4.xlsx',sheetName = 'IR_CorrTest')
ir.corrtest = d$CorrTest


## Fig. 4a (BF - HME)
h.ar.lnL.diff.hme = hist(ar.lnL.diff.hme, breaks = seq(-50,50,5),plot=FALSE)
h.ir.lnL.diff.hme = hist(ir.lnL.diff.hme, breaks = seq(-50,50,5),plot=FALSE)

h.ar.lnL.diff.hme$counts = h.ar.lnL.diff.hme$counts/sum(h.ar.lnL.diff.hme$counts)*100
h.ir.lnL.diff.hme$counts = h.ir.lnL.diff.hme$counts/sum(h.ir.lnL.diff.hme$counts)*100

plot(spline(h.ar.lnL.diff.hme$mids, h.ar.lnL.diff.hme$counts, n=200, method = "natural"),
     type='l', lwd=2, xlim=c(-50,50),ylim=c(0,20), col='red', xaxs = "i", yaxs = "i", axes=FALSE, main='', xlab='', ylab='')
lines(spline(h.ir.lnL.diff.hme$mids, h.ir.lnL.diff.hme$counts, n=200, method = "natural"), col='royalblue', lwd=2)
axis(1, at=c(-50,-40,-30,-20,-10,0,10,20,30,40,50), labels=c(-50,-40,-30,-20,-10,0,10,20,30,40,50), cex.axis=1.3)
axis(2, cex.axis=1.3)
title(xlab='2lnK')
title(ylab='Datasets (%)')


## Fig. 4b (BF - SS)
h.ar.lnL.diff.ss = hist(ar.lnL.diff.ss, breaks = seq(-20,20,2),plot=FALSE)
h.ir.lnL.diff.ss = hist(ir.lnL.diff.ss, breaks = seq(-20,20,2),plot=FALSE)

h.ar.lnL.diff.ss$counts = h.ar.lnL.diff.ss$counts/sum(h.ar.lnL.diff.ss$counts)*100
h.ir.lnL.diff.ss$counts = h.ir.lnL.diff.ss$counts/sum(h.ir.lnL.diff.ss$counts)*100

plot(spline(h.ar.lnL.diff.ss$mids, h.ar.lnL.diff.ss$counts, n=200, method = "natural"),
     type='l', lwd=2, xlim=c(-20,20),ylim=c(0,35), col='red', xaxs = "i", yaxs = "i", axes=FALSE, main='', xlab='', ylab='')
lines(spline(h.ir.lnL.diff.ss$mids, h.ir.lnL.diff.ss$counts, n=200, method = "natural"), col='royalblue', lwd=2)
axis(1, at=c(-20,-10,0,10,20), labels=c(-20,-10,0,10,20), cex.axis=1.3)
axis(2, at=c(0, 35), labels=c(0,35), cex.axis=1.3)
title(xlab='2lnK')
title(ylab='Datasets (%)')


## Fig. 4c (CorrScore)
h.ar.corrtest = hist(ar.corrtest, breaks = seq(0,1,0.05),plot=FALSE)
h.ir.corrtest = hist(ir.corrtest, breaks = seq(0,1,0.05),plot=FALSE)

h.ar.corrtest$counts = h.ar.corrtest$counts/sum(h.ar.corrtest$counts)*100
h.ir.corrtest$counts = h.ir.corrtest$counts/sum(h.ir.corrtest$counts)*100

plot(spline(h.ar.corrtest$mids, h.ar.corrtest$counts, n=200, method = "natural"),
     type='l', lwd=2, xlim=c(0,1),ylim=c(0,65), col='red', xaxs = "i", yaxs = "i", axes=FALSE, main='', xlab='', ylab='')
lines(spline(h.ir.corrtest$mids, h.ir.corrtest$counts, n=200, method = "natural"), col='royalblue', lwd=2)
axis(1, cex.axis=1.3)
axis(2, at=c(0, 65), labels=c(0,65), cex.axis=1.3)
title(xlab='CorrTest score')
title(ylab='Datasets (%)')

