% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_cause_of_death_eids.R
\name{get_cause_of_death_eids}
\alias{get_cause_of_death_eids}
\title{A tidyUkBioBank function
Function output: list of eids of individuals containing a match to the provided string in the cause of death columns}
\usage{
get_cause_of_death_eids(description, ukb_data)
}
\arguments{
\item{description}{diagnosis of interest (string)}

\item{ukb_data}{the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)}
}
\description{
A tidyUkBioBank function
Function output: list of eids of individuals containing a match to the provided string in the cause of death columns
}
\examples{
get_cause_of_death_eids()
}
\keyword{cause}
\keyword{death}
\keyword{eids}
\keyword{get}
\keyword{of}
