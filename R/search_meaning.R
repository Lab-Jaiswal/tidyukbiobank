#' A tidyUkBioBank function
#' Function output: row of the coding6 dataframe, which connects self reported diagnoses to their codes
#' 
#' @param element a string describing the self reported disease of interest (ex: "Lupus", "Dementia")
#' @keywords search meaning
#' @export
#' @examples
#' search_meaning()

search_meaning <- function(element){
  self_reported_df_loc <- system.file("extdata", "self_reported_df", package = "tidyUkBioBank")
  self_reported_df <- read_rds(self_reported_df_loc)
  element <- tolower(element)
  relevant_meaning <- filter(self_reported_df, str_detect(meaning, element))
  relevant_meaning
}
