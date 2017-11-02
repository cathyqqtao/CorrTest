library(xlsx)
library(MASS)


d = read.xlsx('Fig3.xlsx',sheetName = 'ACLN')
acln.score = d$CorrTest 
acln.ar = d$lnK_AR
acln.ur = d$lnK_UCLN
acln.lnL.diff = (acln.ar-acln.ur)*2

v = d$true_v
v.mc2t = d$MC2T_v

d = read.xlsx('Fig3.xlsx',sheetName = 'UCLN')
ucln.ur = d$lnK_UCLN
ucln.ar = d$lnK_AR
ucln.score = d$CorrTest 
ucln.lnL.diff = (ucln.ar-ucln.ur)*2

fit.acln.score = fitdistr((1-acln.score), 'lognormal')
fit.ucln.score = fitdistr(ucln.score, 'lognormal')

## Fig. 3a
plot(seq(0,1,0.01), dlnorm(seq(0,1,0.01), meanlog=fit.ucln.score$estimate[1], sdlog=fit.ucln.score$estimate[2]), ylim=c(0,15), type='l', lwd=2, lty=1, col='royalblue', xaxs = "i", yaxs = "i", axes=FALSE, main='', xlab='', ylab='')
lines((1-seq(0,1,0.01)), dlnorm(seq(0,1,0.01), meanlog=fit.acln.score$estimate[1], sdlog=fit.acln.score$estimate[2]), lwd=2, lty=1, col='red')
axis(1, cex.axis=1.3)
axis(2, at=c(0,15), labels=c(0,35), cex.axis=1.3)
title(xlab='CorrTest score')
title(ylab='Datasets (%)')

## Fig. 3b
h.acln.BF = hist(acln.lnL.diff, breaks = seq(-50,50,5),plot=FALSE)
h.ucln.BF = hist(ucln.lnL.diff, breaks = seq(-50,50,5),plot=FALSE)
plot(h.acln.BF, freq=FALSE, xlim=c(-50,50),ylim=c(0, 0.040), col='red')
plot(h.ucln.BF, freq=FALSE, col='royalblue', add=TRUE)

fit.acln.BF = fitdistr(acln.lnL.diff, 'normal')
fit.ucln.BF = fitdistr(ucln.lnL.diff, 'normal')

plot(seq(-50,50,1), dnorm(seq(-50,50,1), mean=fit.ucln.BF$estimate[1], sd=fit.ucln.BF$estimate[2]), ylim=c(0,0.04),type='l', lwd=2, lty=1, col='royalblue', xaxs = "i", yaxs = "i", axes=FALSE, main='', xlab='', ylab='')
lines(seq(-50,50,1), dnorm(seq(-50,50,1), mean=fit.acln.BF$estimate[1], sd=fit.acln.BF$estimate[2]), lwd=2, lty=1, col='red')
axis(1, at=c(-50,-40,-30,-20,-10,0,10,20,30,40,50), labels=c(-50,-40,-30,-20,-10,0,10,20,30,40,50), cex.axis=1.3)
axis(2, at=c(0,0.04), labels=c(0,20), cex.axis=1.3)
title(xlab='2lnK')
title(ylab='Datasets (%)')

## Fig. 3d
plot(v, v.mc2t, xlim=c(0,0.4), ylim=c(0,0.5), pch=18, cex=0.6, xaxs = "i", yaxs = "i", axes=FALSE, main='', xlab='', ylab='')
abline(0, 1.09, lwd=2, col='gray')
axis(1, cex.axis=1.3)
axis(2, cex.axis=1.3)
title(ylab='inferred v')
title(xlab='true v')



