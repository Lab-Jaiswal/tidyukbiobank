% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/self_reported_counts.R
\name{self_reported_counts}
\alias{self_reported_counts}
\title{A tidyUkBioBank function
Function output: counts data of all individuals who reported the disease of interest (M/F breakdown, etc.)}
\usage{
self_reported_counts(disease, dataframe)
}
\arguments{
\item{disease}{diagnosis of interest (string or code)}

\item{ukb_data}{the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)}
}
\description{
A tidyUkBioBank function
Function output: counts data of all individuals who reported the disease of interest (M/F breakdown, etc.)
}
\examples{
self_reported_counts()
}
\keyword{counts}
\keyword{reported}
\keyword{self}
