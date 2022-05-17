#' A tidyUkBioBank function
#' Function output: internal function, code indicated by either provided code or string
#' Outputs a print statment with information about the self reported code selected
#' 
#' @param disease a number code or string describing the self reported disease of interest
#' @keywords parse self reported info
#' @export
#' @examples
#' parse_get_SR_table_input()

parse_get_SR_table_input <- function(disease){
  if (grepl("^[A-Za-z]+$", disease, perl = T)){
    SR_tibble <- search_meaning(disease) 
    coding <- SR_tibble[[1,1]]
    name <- SR_tibble %>% select(meaning)
    print(paste("You have selected the following self reported disease:", name, "(code:", coding, ")"))
  } else { 
    SR_tibble <- search_coding(disease)
    coding <- disease
    name <- SR_tibble %>% select(meaning)
    print(paste("You have selected the following self reported disease:", name, "(code:", coding, ")"))
  }
  coding
}