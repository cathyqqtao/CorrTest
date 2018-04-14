library(xlsx)

## Fig. 1a ancestral-descendant rates
d = read.xlsx('Fig2.xlsx', sheetName = 'anc-des-correlation')
acln.ra = d$CR.ra
acln.rd = d$CR.rd
ucln.ra = d$IR.ra
ucln.rd = d$IR.rd

acln.rard.fit = lm(acln.rd ~ acln.ra)
ucln.rard.fit = lm(ucln.rd ~ ucln.ra)


plot(ucln.ra, ucln.rd, pch=16, xlim=c(0,0.5), ylim=c(0,0.5), col='royalblue', cex=0.4, main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE, xpd = NA)
points(acln.ra, acln.rd, pch=16, cex=.4, col='red')
abline(ucln.rard.fit$coefficients[1], ucln.rard.fit$coefficients[2],col='royalblue')
abline(acln.rard.fit$coefficients[1], acln.rard.fit$coefficients[2],col='red')
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Rate on ancestral lineage', font.lab=2, cex.lab=1.0)
title(ylab='Rate on descendant lineage', font.lab=2, cex.lab=1.0)

## Fig. 1b sister rates
d = read.xlsx('Fig2.xlsx', sheetName = 'sister-correlation')
acln.r1 = d$CR.r1
acln.r2 = d$CR.r2
ucln.r1 = d$IR.r1
ucln.r2 = d$IR.r2

acln.r1r2.fit = lm(acln.r2 ~ acln.r1)
ucln.r1r2.fit = lm(ucln.r2 ~ ucln.r1)


plot(ucln.r1, ucln.r2, xlim=c(0,0.5), ylim=c(0,0.5), pch=16, col='royalblue', cex=0.4, main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE, xpd = NA)
points(acln.r1, acln.r2, pch=16, cex=.4, col='red')
abline(ucln.r1r2.fit$coefficients[1], ucln.r1r2.fit$coefficients[2],col='royalblue')
abline(acln.r1r2.fit$coefficients[1], acln.r1r2.fit$coefficients[2],col='red')
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Rate on sister lineage 1', font.lab=2, cex.lab=1.0)
title(ylab='Rate on sister lineage 2', font.lab=2, cex.lab=1.0)

## Fig. 1c ancestor-descendant correlation decay
d = read.xlsx('Fig2.xlsx', sheetName = 'correlationDecay')
l.skp = d$lineage.skipped
acln = d$ACLN.24
ucln = d$UCLN.31

acln.decay = (acln - acln[1])/acln[1] * 100
ucln.decay = (ucln - ucln[1])/ucln[1] * 100

plot(l.skp, ucln.decay,  ylim=c(-70, 0), type='o', cex=.6, lwd=2, col='royalblue', main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE, xpd = NA)
lines(l.skp, acln.decay, type='o', cex=.6, lwd=2, col='red')
Axis(side=1, at=c(0,1,2), cex.axis=1.0)
Axis(side=2, at=c(0,-10,-20,-30,-40,-50,-60,-70), cex.axis=1.0)
title(xlab='Number of skipped lineges', font.lab=2, cex.lab=1.0)
title(ylab='ancestral-descendant correlation decay (%)', font.lab=2, cex.lab=1.0)

## Fig. 1d ROC 
d = read.xlsx('Fig2.xlsx', sheetName = 'ROC')

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

plot(rho.ad.fpr, rho.ad.tpr, xlim=c(0,1), ylim=c(.5,1), type='l', lwd=2, col='forestgreen', main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE)
lines(rho.s.fpr, rho.s.tpr, type='l', lwd=2, col='darkorange')
lines(all.fpr, all.tpr, type='l', lwd=2, col='black')
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='False positive rate', font.lab=2, cex.lab=1.0)
title(ylab='True positive rate', font.lab=2, cex.lab=1.0)

## Fig. 1d, inset
plot(rho.ad.recall, rho.ad.precision, xlim=c(0,1), ylim=c(.6,1), type='l', lwd=2, col='forestgreen', main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE)
lines(rho.s.recall, rho.s.precision, type='l', lwd=2, col='darkorange')
lines(all.recall, all.precision, type='l', lwd=2, col='black')
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Recall', font.lab=2, cex.lab=1.0)
title(ylab='Precision', font.lab=2, cex.lab=1.0)

## Fig. 1e
plot(all.threshold , -log10(all.fpr), xlim=c(0,1), type='l', lwd=2, col='black', main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE)
points(0.827, -log10(0.01), col='red', pch=18)
points(0.489, -log10(0.05), col='blue', pch=18)
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Prediction score', font.lab=2, cex.lab=1.0)
title(ylab='-log(p-value)', font.lab=2, cex.lab=1.0)

