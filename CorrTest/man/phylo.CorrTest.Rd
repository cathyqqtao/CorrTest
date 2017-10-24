\name{phylo.CorrTest}
\alias{phylo.CorrTest}
\title{Detect rate correlation in a phylogeny}
\description{This function calculates CorrTest score that can be used to test the hypothesis of no-correlation of evolutionary rates in a phylogeny. 
}
\usage{
phylo.CorrTest = function(brlen_tree, timetree, outgroup)
}
\arguments{
  \item{brlen_tree}{an object of class "phylo" specifying the branch lengths}
  \item{timetree}{an object of class "phylo" specifying the divergence times}
  \item{outgroup}{a vector of character specifying outgroup tips to remove}

}
\examples{
phylo.CorrTest = function(brlen_tree, timetree, outgroup)
}
