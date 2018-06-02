library(xlsx)

d = read.xlsx('Fig4.xlsx',sheetName = 'CBR_SS')
ar.ar.ss = d$lnK_CBR
ar.ir.ss = d$lnK_IBR
ar.lnL.diff.ss = (ar.ar.ss-ar.ir.ss)*2
ar.lnL.diff.ss = ar.lnL.diff.ss[!is.na(ar.lnL.diff.ss)]

d = read.xlsx('Fig4.xlsx',sheetName = 'IBR_SS')
ir.ar.ss = d$lnK_CBR
ir.ir.ss = d$lnK_IBR
ir.lnL.diff.ss = (ir.ar.ss-ir.ir.ss)*2
ir.lnL.diff.ss = ir.lnL.diff.ss[!is.na(ir.lnL.diff.ss)]

d = read.xlsx('Fig4.xlsx',sheetName = 'CBR_CorrTest')
ar.corrtest = d$CorrTest

d = read.xlsx('Fig4.xlsx',sheetName = 'IBR_CorrTest')
ir.corrtest = d$CorrTest


## Fig. 4a (BF - SS)
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


## Fig. 4b (CorrScore)
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


## Fig. 4c BF at different significance levels
d = read.xlsx('Fig4.xlsx', sheetName = 'TPR_significance level', header=TRUE)
sigL = d$significance_level
ct.score = d$corrtest_score
ct.tpr = d$corrtest_TPR
bf.PP = d$BF_PP
bf.ss.tpr = d$BF_SS_TPR

with(d, plot(c(1:5), ct.tpr, type="l", col="red", lwd=2, lty=1, xaxt='n', xlab=NA, ylab=NA, ylim=c(0,1), xlim=c(1,5)))
lines(c(1:5), bf.ss.tpr, col="red", lwd=2, lty=3)
axis(side = 1, at=c(1,2,3,4,5), labels = c('0.50','0.79','0.87','0.96','1.00'))
axis(side = 3, at=c(1,2,3,4,5), labels = c('10e-6','0.25','0.5','0.83','1.00'))
mtext(side = 3, line = 3, 'CorrScore')
mtext(side = 1, line = 3, 'Bayes factor PP for CBR')
mtext(side = 2, line = 3, 'True positive rate')




