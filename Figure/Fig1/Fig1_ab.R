library(xlsx)

d = read.xlsx('Fig1.xlsx', sheetName = 'ACLN-24_r1_r2')
acln.r1 = d$r1
acln.r2 = d$r2

d = read.xlsx('Fig1.xlsx', sheetName = 'ACLN-24_ra_rd')
acln.ra = d$ra
acln.rd = d$rd

d = read.xlsx('Fig1.xlsx', sheetName = 'UCLN-31_ra_rd')
ucln.ra = d$ra
ucln.rd = d$rd

d = read.xlsx('Fig1.xlsx', sheetName = 'UCLN-31_r1_r2')
ucln.r1 = d$r1
ucln.r2 = d$r2

acln.r1r2.fit = lm(acln.r2 ~ acln.r1)
ucln.r1r2.fit = lm(ucln.r2 ~ ucln.r1)

acln.rard.fit = lm(acln.rd ~ acln.ra)
ucln.rard.fit = lm(ucln.rd ~ ucln.ra)

## Fig. 1a
plot(acln.ra, acln.rd, pch=16, xlim=c(0.1,0.5), ylim=c(0.1,0.5), col='red', cex=0.4, main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE, xpd = NA)
points(ucln.ra, ucln.rd, pch=16, cex=.4, col='royalblue')
abline(acln.rard.fit$coefficients[1], acln.rard.fit$coefficients[2],col='red')
abline(ucln.rard.fit$coefficients[1], ucln.rard.fit$coefficients[2],col='royalblue')
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Rate on ancestral lineage', font.lab=2, cex.lab=1.0)
title(ylab='Rate on descendant lineage', font.lab=2, cex.lab=1.0)

## Fig. 1b
plot(acln.r1, acln.r2, xlim=c(0.1,0.5), ylim=c(0.1,0.5), pch=16, col='red', cex=0.4, main = '', xlab='',ylab='', xaxs = "i", yaxs = "i", axes=FALSE, xpd = NA)
points(ucln.r1, ucln.r2, pch=16, cex=.4, col='royalblue')
abline(acln.r1r2.fit$coefficients[1], acln.r1r2.fit$coefficients[2],col='red')
abline(ucln.r1r2.fit$coefficients[1], ucln.r1r2.fit$coefficients[2],col='royalblue')
Axis(side=1, cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Rate on sister lineage 1', font.lab=2, cex.lab=1.0)
title(ylab='Rate on sister lineage 2', font.lab=2, cex.lab=1.0)


