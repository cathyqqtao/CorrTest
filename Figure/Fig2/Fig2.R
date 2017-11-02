library(ggplot2)

## (a) GC contents
barplot(c(100,100,98), ylim=c(90,100), main="", xlab="", ylab='')
Axis(side=1, labels = c('<50%','50%-70%','>70%'), cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='GC content', font.lab=2, cex.lab=1.0)
title(ylab='Accuracy', font.lab=2, cex.lab=1.0)

## (b) Ts/Tv
barplot(c(100,99,94), ylim=c(90,100), main="", xlab="", ylab='')
Axis(side=1, labels = c('<3','3-5','>5'), cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Transition/transversion ratio', font.lab=2, cex.lab=1.0)
title(ylab='Accuracy', font.lab=2, cex.lab=1.0)

## (c) Rate
barplot(c(100,99,99), ylim=c(90,100), main="", xlab="", ylab='')
Axis(side=1, labels = c('<1','1-2','>2'), cex.axis=1.0)
Axis(side=2, cex.axis=1.0)
title(xlab='Rate', font.lab=2, cex.lab=1.0)
title(ylab='Accuracy', font.lab=2, cex.lab=1.0)


## (d) SeqLength and TaxaNum
df.m = expand.grid(seqLength = c('<500','500-1000','1000-2000','2000-3000','>3000'), taxaNum = c('50','100','200','300','400'))
df.m$value = c(82,84,88,94,100,86,95,95,89,100,96,95,99,100,100,96,98,99,100,100,100,98,99,100,100)

color.palette  <- colorRampPalette(c("#7abbff","#6195cc","#3d5d7f","#182533"), space='Lab')
p = ggplot(data = df.m, aes(x=taxaNum, y=seqLength)) + geom_tile(aes(fill = value)) + coord_equal()
p + scale_fill_gradientn(colours = color.palette(100)) + theme_bw() + theme(panel.border = element_blank())

## (e) SeqLength and TaxaNum_NJ
df.nj = expand.grid(seqLength = c('<500','500-1000','1000-2000','2000-3000','>3000'), taxaNum = c('50','100','200','300','400'))
df.nj$value = c(71,81,83,94,100,82,85,95,89,100,89,90,99,100,100,89,97,99,100,100,93,95,96,100,100)

color.palette  <- colorRampPalette(c("#c9e3ff", "#7abbff","#6195cc","#3d5d7f","#182533"), space='Lab')
p.nj = ggplot(data = df.nj, aes(x=taxaNum, y=seqLength)) + geom_tile(aes(fill = value)) + coord_equal()
p.nj + scale_fill_gradientn(colours = color.palette(100)) + theme_bw() + theme(panel.border = element_blank())

## (f) topological error
df.rf = expand.grid(topoError = c('>20%','15%-20%','10%-15%','5%-10%','<5%'), taxaNum = c('50','100','200','300','400'))
df.rf$value = c(57,88,75,93,88,77,88,87,96,96,80,94,100,98,100,89,100,98,98,100,91,100,96,97,100)

color.palette  <- colorRampPalette(c("#f1f8ff", "#c9e3ff", "#7abbff","#6195cc","#3d5d7f","#182533"), space='Lab')

p.rf = ggplot(data = df.rf, aes(x=taxaNum, y=topoError)) + geom_tile(aes(fill = value)) + coord_equal()
p.rf + scale_fill_gradientn(colours = color.palette(100)) + theme_bw() + theme(panel.border = element_blank())

