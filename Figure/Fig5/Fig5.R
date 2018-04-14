library(xlsx)

d = read.xlsx('Fig5.xlsx', sheetName = 'TPR_significance level', header=TRUE)
sigL = d$significance_level
ct.score = d$corrtest_score
ct.tpr = d$corrtest_TPR
bf.PP = d$BF_PP
bf.hme.tpr = d$BF_HME_TPR
bf.ss.tpr = d$BF_SS_TPR

## Fig. 5a BF at different significance levels
with(d, plot(c(1:5), bf.hme.tpr, type="l", col="red", lwd=2, lty=2, xaxt='n', xlab=NA, ylab=NA, ylim=c(0,1), xlim=c(1,5)))
lines(c(1:5), bf.ss.tpr, col="red", lwd=2, lty=3)
axis(side = 1, at=c(1,2,3,4,5), labels = c('0.50','0.79','0.87','0.96','1.00'))
mtext(side = 1, line = 3, 'Bayes factor PP for CBR')
mtext(side = 2, line = 3, 'True positive rate')


## Fig. 5a CorrTest at different significance levels
with(d, plot(c(1:5), ct.tpr, type="l", col="red", lwd=2, lty=1, xaxt='n', xlab=NA, ylab=NA, ylim=c(0,1), xlim=c(1,5)))
axis(side = 1, at=c(1,2,3,4,5), labels = c('10e-6','0.25','0.5','0.83','1.00'))
mtext(side = 1, line = 3, 'CorrScore')
mtext(side = 2, line = 3, 'True positive rate')

