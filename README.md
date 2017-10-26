CorrTest
==============

CorrTest tests the variation pattern (independent or autocorrelated) of molecular rates in a phylogeny. 

Introduction
============

CorrTest contains 1 R fuction: phylo.CorrTest. 

This function requires 3 arguments: a branch length tree, a timetree and outgroup(s). Thus, users need to estimate branch lengthsusing their favorite methods (ML, NJ, MP, etc.) and software (MEGA, RAxML, etc.) before run phylo.CorrTest. Timetree should be estiamted using RelTime method that implemented in MEGA with the same topology as used the branch length tree and without any calibration. This program calculates relative rates using the given branch lengths and times. Outgroups will automatically removed because the assumption of equal rates of evolution between the ingroup and outgroup sequences is not testable. 

Noted that this function has been implemented in MEGA version 7.0.25(?). You can download the software from http://www.megasoftware.net/. More information about how to use CorrTest in MEGA can be found in (insert a help page).


Getting Started
---------------

This program requires 4 external packages: ape, phangorn, stats and R.utils. Install them in advance before installing CorrTest. To do so, type the following command inside the R session and follow the instructions to complete the installation: 

	install.packages('ape')
	install.packages('phangorn')
	install.packages('stats')
	install.packages('R.utils')

	
To intall CorrTest package, please follow the steps:
  *If your are using R studio:
	1. Download CorrTest folder from GitHub and save it to user specified location
	2. In R studio, go to "File" --> "Open Project in New Session"
	3. Find the location that contains the CorrTest folder and open CorrTest.Rproj 
	4. You should be able to see CorrTest in your packages
	5. type library("CorrTest") in Console to activate the package
	
  *If your are using R:
	1. Download CorrTest folder from GitHub and save it to user specified location


To run phylo.CorrTest, please install the CorrTest package follow above steps first and then follow the following steps:

	setwd('example')
	brlen_tree = read.tree('dosReis_Mammals274_ML.nwk')
	timetree = read.tree('dosReis_Mammals274_RelTime_oneCali_relTimes.nwk')
	out.tip = c('Ornithorhynchus_anatinus', 'Zaglossus_bruijni', 'Tachyglossus_aculeatus')
	
	phylo.CorrTest(brlen_tree, timetree, out.tip)


You can type ?phylo.CorrTest() for more information. 

This program only allows binary trees.

This program only takes trees that contain the same species. Please make sure the taxa names are the same in the branch length tree and timetree before you run the program. 

If you have more questions, please email cathyqqtao@gmail.com (or qiqing.tao@temple.edu).


Directory Structure
------------------- 

'CorrTest' directory contains all files that you need to install CorrTest package in R.

'example' directory contains an example data and an example code to run phylo.CorrTest.

'data' directory contains all empirical data, RelTime results, and Bayesian results that used in Tao et al. (2018?). 


Citation
============
Tao et al.

If you use CorrTest from MEGA software (MEGA7-GUI). Please also cite:
Sudhir Kumar, Glen Stecher, and Koisgiro Tamura. MEGA7: Molecular Evolutionary Genetics Analysis version 7.0 for bigger datasets. Molecular Biology and Evolution(2016). 33(7):1870-1874.

If you use CorrTest from MEGA software (MEGA7-CC). Please also cite:
Sudhir Kumar, Glen Stecher, Daniel Peterson, and Koisgiro Tamura. MEGA-CC: computing core of molecular evolutionary genetics analysis program for automated and iterative data analysis. Bioinformatics(2012). 28(20):2685-2686.