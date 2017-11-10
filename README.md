CorrTest
==============

CorrTest tests the hypothesis of independence of evolutionary rates among lineages in a phylogeny.

Introduction
============

CorrTest contains 1 R fuction: `rate.CorrTest` 

`rate.CorrTest(brlen_tree, outgroup, outputFile)` requires 3 arguments:  

  `brlen_tree` is an object of class "phylo" specifying the branch lengths
	
  `outgroup` is a vector of character specifying all outgroup tips
	
  `outputFile` is a character string naming the output file that contains the CorrTest score and p-value
	

Users need to provide an evolutionary tree with branch lengths in order to run `rate.CorrTest`. To get a tree with branch lengths, we suggest that you use existing software (e.g., RAxML or MEGA) or functions in `phangorn` (https://cran.r-project.org/web/packages/phangorn/phangorn.pdf).  (See below for examples usage.)

The program will produce the probability that the null hypothesis of rate independency among lineages is rejected, as well as the associated prediction score. When the rate independence is rejected by CorrTest, then autocorrelation parameter can be estimated by using one of the Bayesian analysis software (e.g., MCMCTree).

Directory Structure
------------------- 

"code" directory contains `rate.CorrTest` R function.

"example" directory contains an example data and an example code to run `rate.CorrTest`.

"data" directory contains all empirical data, CorrTest results and Bayesian results in Tao et al. 

"Figure" derectory contains data and code for generating figures in Tao et al. 


Getting Started
---------------

To intall `rate.CorrTest` on your local machine, please follow the steps:

1. Download `rate.CorrTest` from code directory.
2. In R, type `setwd(<yout folder location>)` to change the working directory to be the folder that contains `rate.CorrTest` function. 
2. Type `source("rate.CorrTest.R")` to activate the funciton.
	

`rate.CorrTest` requires 4 external packages: ape, phangorn, stats and R.utils. Install them in advance before using the program. To do so, type the following command inside the R session and follow the instructions to complete the installation: 

	install.packages("ape")
	install.packages("phangorn")
	install.packages("stats")
	install.packages("R.utils")


To run `rate.CorrTest`, please install the program follow above steps and then follow the following steps:

	setwd("example")
	t.ml = read.tree("dosReis_Mammals274_ML.nwk")
	out.tip = c("Ornithorhynchus_anatinus", "Zaglossus_bruijni", "Tachyglossus_aculeatus")
	
	rate.CorrTest(t.ml, out.tip, "CorrTest.txt")


Note that users need to provide a tree with branch lengths as the input for `rate.CorrTest`. To get the branch length tree, one can use existing software, such as RAxML and MEGA, or use the existing functions in `phangorn` using the following steps. If you have more questions about how to estimate branch lengths, please refer to "phangorn" manual (https://cran.r-project.org/web/packages/phangorn/phangorn.pdf). 
	
	setwd("example")
	seq = read.phyDat("dosReis274_complete.fas", format="fasta", type="DNA")
		
	## NOT RUN: To estimate branch lengths based on a fixed topology
	topo = read.tree("dosReis_Mammals274_topology.nwk") 
	topo = acctran(topo, seq)
	fit.fix = pml(topo, data=seq, model="HKY", k=4)
	fit.fix = optim.pml(fit.fix, optNni = FALSE, optEdge = TRUE, rearrangements = "none")
	
	## NOT RUN: To estimate topogy and branch lengths together
	dm = dist.ml(seq)
	treeNJ = NJ(dm)
	fit.relax = pml(treeNJ, data=seq, model="HKY", k=4)
	fit.relax = optim.pml(fit.relax, optNni = TRUE, optEdge = TRUE, rearrangements = "NNI")
		
	## NOT RUN: export the tree 
	write.tree(fit.fix$tree, file="treeML_fix_topology.nwk")
	write.tree(fit.relax$tree, file="treeML.nwk")

	
Currently, `rate.CorrTest` only allows binary trees.

If you have more questions, please email cathyqqtao@gmail.com (or qiqing.tao@temple.edu).



Citation
============
Tao et al. (2017). Pervasive correlation of molecular evolutionary rates in the tree of life (submitted).
