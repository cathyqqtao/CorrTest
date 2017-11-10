rate.CorrTest
==============

This function tests the null hypothesis of the independence of evolutionary rates among branches (lineages) in a phylogeny. 


Usage
-----
`rate.CorrTest(brlen_tree, outgroup, outputFile)`


Arguments
---------
**brlen_tree** is an object of class "phylo" specifying the branch lengths.
	
**outgroup** is	a vector of character specifying all outgroup tips.
	
**outputFile** is a character string naming the output file that contains the CorrTest score and p-value.
	
	
Details
-------
This function requires 4 external packages: ape, phangorn, stats and R.utils. Please install them in advance before using the program. 

Users need to provide a tree with branch lengths as the input for this function. To get the branch length tree, one can use existing softwares, such as RAxML and MEGA, or use the existing functions in `phangorn`. Please refer to "phangorn" manual (https://cran.r-project.org/web/packages/phangorn/phangorn.pdf) for more information. 

Currently, this function only allows binary trees. To use it with multifurcating trees, convert each polytomy into a series of bifurcations and set the length of the newly created branches to be 0.


Examples
--------
	setwd("example")
	t.ml = read.tree("dosReis_Mammals274_ML.nwk")
	out.tip = c("Ornithorhynchus_anatinus", "Zaglossus_bruijni", "Tachyglossus_aculeatus")
	
	rate.CorrTest(t.ml, out.tip, "CorrTest.txt")


Reference
---------
Tao et al. (2017). Pervasive correlation of molecular evolutionary rates in the tree of life (submitted).
