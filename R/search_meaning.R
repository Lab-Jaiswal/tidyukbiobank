#' A tidyUkBioBank function
#' Function output: row of the coding6 dataframe, which connects self reported diagnoses to their codes
#' 
#' @param element a string describing the self reported disease of interest (ex: "Lupus", "Dementia")
#' @param cancer
#' @keywords search meaning
#' @export
#' @examples
#' search_meaning()

search_meaning <- function(element, cancer){
    if (cancer != "TRUE"){
        self_reported_df_loc <- system.file("extdata", "coding6.rds", package = "tidyukbiobank")
        self_reported_df <- read_rds(self_reported_df_loc)
        element <- tolower(element)
        relevant_meaning <- filter(self_reported_df, str_detect(meaning, element))
        relevant_meaning
    } else {
        self_reported_df_loc <- system.file("extdata", "coding3.rds", package = "tidyukbiobank")
        self_reported_df <- read_rds(self_reported_df_loc)
        element <- tolower(element)
        relevant_meaning <- filter(self_reported_df, str_detect(meaning, element))
        relevant_meaning
    }
  }
