CorrTest
==============

CorrTest tests the hypothesis of molecular rate independency in a phylogeny. 

Introduction
============

CorrTest contains 1 R fuction: `rate.CorrTest` 

`rate.CorrTest(brlen_tree, outgroup, outputFile)` requires 3 arguments:  

  `brlen_tree` is an object of class "phylo" specifying the branch lengths
	
  `outgroup` is a vector of character specifying all outgroup tips
	
  `outputFile` is a character string naming the output file that contains the CorrTest score and p-value
	

Users need to estimate branch lengths using their favorite method (ML, NJ, MP, etc.) and software (MEGA, RAxML, etc.) before run rate.CorrTest. This program calculates rates using the relative rates fromework (RRF, Tamura, et al. 2017) using the given branch length tree. Outgroups will automatically removed because the assumption of equal rates of evolution between the ingroup and outgroup sequences is not testable. 

Noted that this function has also been implemented in MEGA version 7.0.25(?). You can download the software from http://www.megasoftware.net/. More information about how to use CorrTest in MEGA can be found in (insert a help page).


Directory Structure
------------------- 

'code' directory contains rate.CorrTest R function.

'example' directory contains an example data and an example code to run rate.CorrTest.

'data' directory contains all empirical data, CorrTest results and Bayesian results in Tao et al. 

'Figure' derectory contains data and code for generating figures in Tao et al. 


Getting Started
---------------

To intall `rate.CorrTest` on your local machine, please follow the steps:

1. Download `rate.CorrTest` from code directory.
2. In R, type `setwd(<yout folder location>)` to change the working directory to be the folder that contains `rate.CorrTest` function. 
2. Type `import("rate.CorrTest")` to activate the funciton.
	

`rate.CorrTest` requires 4 external packages: ape, phangorn, stats and R.utils. Install them in advance before using the program. To do so, type the following command inside the R session and follow the instructions to complete the installation: 

	install.packages('ape')
	install.packages('phangorn')
	install.packages('stats')
	install.packages('R.utils')


To run `rate.CorrTest`, please install the program follow above steps first and then follow the following steps:

	setwd('example')
	t.ml = read.tree('dosReis_Mammals274_ML.nwk')
	out.tip = c('Ornithorhynchus_anatinus', 'Zaglossus_bruijni', 'Tachyglossus_aculeatus')
	
	phylo.CorrTest(t.ml, out.tip, 'CorrTest.txt')


Note that users need to provide a tree with branch lengths as the input for `rate.CorrTest`. To get the branch length tree, one can use existing softwares, such as RAxML and MEGA, or use the existing functions in `phangorn` as following steps.  
	
	setwd('example')

	dm = dist.ml(data, model='HKY')
	
	## To get a UPGMA tree ##
	treeUPGMA = upgma(dm)
	
	## To get a Neighbor-Joining tree ##
	treeNJ = NJ(dm)
	
	## To get a maximum likelihood tree ##
	fit = pml(treeNJ, data)
	fit = optim.pml(fit, model='HKY', rearrangements="NNI")
	bs = bootstrap.pml(fit, bs=100, control = pml.control(trace=0))
	
	## export the tree ##
	write.tree(bs, file="bootstrap_example.tre")

	
	
Currently, `rate.CorrTest` only allows binary trees.

If you have more questions, please email cathyqqtao@gmail.com (or qiqing.tao@temple.edu).



Citation
============
Tao et al.

If you use CorrTest from MEGA software (MEGA7-GUI). Please also cite:

Sudhir Kumar, Glen Stecher, and Koisgiro Tamura. MEGA7: Molecular Evolutionary Genetics Analysis version 7.0 for bigger datasets. Molecular Biology and Evolution(2016). 33(7):1870-1874.

If you use CorrTest from MEGA software (MEGA7-CC). Please also cite:

Sudhir Kumar, Glen Stecher, Daniel Peterson, and Koisgiro Tamura. MEGA-CC: computing core of molecular evolutionary genetics analysis program for automated and iterative data analysis. Bioinformatics(2012). 28(20):2685-2686.