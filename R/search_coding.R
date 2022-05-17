#' A tidyUkBioBank function
#' Function output: row of the coding6 dataframe, which connects self reported diagnoses to their codes
#' 
#' @param element a number code describing the self reported disease of interest
#' @keywords search coding
#' @export
#' @examples
#' search_coding()


search_coding <- function(element){
  self_reported_df_loc <- system.file("extdata", "self_reported_df", package = "tools4ukbb")
  self_reported_df <- read_rds(self_reported_df_loc)
  element <- tolower(element)
  relevant_code <- filter(self_reported_df, str_detect(coding, element))
  relevant_code
}
