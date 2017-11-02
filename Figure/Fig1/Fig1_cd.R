library(xlsx)

setwd('C:\\Users\\tuf33165\\Google Drive\\Kumar lab\\Draft\\Manuscript\\rateCorrelation\\Figure_v3')

library(xlsx)

d = read.xlsx('Fig1.xlsx', sheetName = 'ROC')

rho.s.fpr = d$rho_s_fpr
rho.s.tpr = d$rho_s_tpr 
rho.s.recall = d$rho_s_recall
rho.s.precision = d$rho_s_precision

rho.ad.fpr = d$rho_ad_fpr
rho.ad.tpr = d$rho_ad_tpr
rho.ad.recall = d$rho_ad_recall
rho.ad.precision = d$rho_ad_precision

all.fpr = d$all4_fpr
all.tpr = d$all4_tpr
all.recall = d$all4_recall
all.precision = d$all4_precision
all.threshold = d$all4_threshold

## Fig. 1c
plot(rho.ad.fpr, rho.ad.tpr, xlim=c(0,1), ylim=c(.5,1), type='l', lwd=2, col='forestgreen', main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE)
lines(rho.s.fpr, rho.s.tpr, type='l', lwd=2, col='darkorange')
lines(all.fpr, all.tpr, type='l', lwd=2, col='black')
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='False positive rate', font.lab=2, cex.lab=1.0)
title(ylab='True positive rate', font.lab=2, cex.lab=1.0)

## Fig. 1c, inset
plot(rho.ad.recall, rho.ad.precision, xlim=c(0,1), ylim=c(.6,1), type='l', lwd=2, col='forestgreen', main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE)
lines(rho.s.recall, rho.s.precision, type='l', lwd=2, col='darkorange')
lines(all.recall, all.precision, type='l', lwd=2, col='black')
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Recall', font.lab=2, cex.lab=1.0)
title(ylab='Precision', font.lab=2, cex.lab=1.0)

## Fig. 1d
plot(all.threshold , -log10(all.fpr), xlim=c(0,1), type='l', lwd=2, col='black', main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE)
points(0.827, -log10(0.01), col='red', pch=18)
points(0.489, -log10(0.05), col='blue', pch=18)
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Prediction score', font.lab=2, cex.lab=1.0)
title(ylab='-log(p-value)', font.lab=2, cex.lab=1.0)
