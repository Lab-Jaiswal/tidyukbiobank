#' A tidyUkBioBank function
#' Function output: row of the coding6 dataframe, which connects self reported diagnoses to their codes
#' 
#' @param element a number code describing the self reported disease of interest
#' @param cancer
#' @keywords search coding
#' @export
#' @examples
#' search_coding()


search_coding <- function(element, cancer){
  if (cancer != TRUE) {
    self_reported_df_loc <- system.file("extdata", "coding6.rds", package = "tidyukbiobank")
    self_reported_df <- read_rds(self_reported_df_loc)
    element <- tolower(element)
    relevant_code <- filter(self_reported_df, str_detect(coding, element))
    relevant_code
  } else {
    self_reported_df_loc <- system.file("extdata", "coding3.rds", package = "tidyukbiobank")
    self_reported_df <- read_rds(self_reported_df_loc)
    element <- tolower(element)
    relevant_code <- filter(self_reported_df, str_detect(coding, element))
    relevant_code
  }
}
