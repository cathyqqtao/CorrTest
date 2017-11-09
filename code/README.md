rate.CorrTest
==============

This function tests the hypothesis of molecular rate independency in a phylogeny. 


Usage
-----
`rate.CorrTest(brlen_tree, outgroup, outputFile)`


Arguments
---------
**brlen_tree**		an object of class "phylo" specifying the branch lengths
	
**outgroup**		a vector of character specifying all outgroup tips
	
**outputFile**		a character string naming the output file that contains the CorrTest score and p-value
	
	
Details
-------
This function requires 4 external packages: ape, phangorn, stats and R.utils. Please install them in advance before using the program. 

Users need to provide a tree with branch lengths as the input for this function. To get the branch length tree, one can use existing softwares, such as RAxML and MEGA, or use the existing functions in `phangorn`. Please refer to "phangorn" manual (https://cran.r-project.org/web/packages/phangorn/phangorn.pdf) for more information. 

Currently, this function only allows binary trees.

Noted that this function has also been implemented in MEGA version 7.1.1. You can download the software from http://www.megasoftware.net/.


Reference
---------
Tao et al.
Tamura et al.
