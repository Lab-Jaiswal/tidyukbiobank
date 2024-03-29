% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_cause_of_death_description.R
\name{get_cause_of_death_description}
\alias{get_cause_of_death_description}
\title{A tidyUkBioBank function
Function output: a table with two columns: eid and cause of death description, which contains string matching the dscription variable given}
\usage{
get_cause_of_death_description(description, ukb_data)
}
\arguments{
\item{description}{diagnosis of interest (string)}

\item{ukb_data}{the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)}
}
\description{
A tidyUkBioBank function
Function output: a table with two columns: eid and cause of death description, which contains string matching the dscription variable given
}
\examples{
get_cause_of_death_description()
}
\keyword{cause}
\keyword{death}
\keyword{description}
\keyword{get}
\keyword{of}
