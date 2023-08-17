#' A tidyUkBioBank function
#' Function output: internal function, code indicated by either provided code or string
#' Outputs a print statment with information about the self reported code selected
#' 
#' @param disease a number code or string describing the self reported disease of interest
#' @param cancer
#' @keywords parse self reported info
#' @export
#' @examples
#' parse_get_SR_table_input()

parse_get_SR_table_input <- function(disease, cancer) {
  if (grepl("^[A-Za-z-_]+$", disease, perl = T)){
    SR_tibble <- search_meaning(disease, cancer) 
    if (nrow(SR_tibble) >= 1)  {
        coding <- SR_tibble[[1,1]]
        name <- SR_tibble %>% select(meaning)
        print(paste("You have selected the following self reported disease:", name, "(code:", coding, ")"))
    } else {
        print("You have not inputted a valid string for either the 'disease' field (in parse_get_SR_table_input, self_reported_table, or self_reported_counts) or the 'self_reported` field (in diagnoses_table or diagnoses_counts). Please see coding6 and coding3 for appropriate entries.")
    }
  } else { 
    SR_tibble <- search_coding(disease, cancer)    
    if (nrow(SR_tibble) >= 1) {
        coding <- disease
        name <- SR_tibble %>% select(meaning)
        print(paste("You have selected the following self reported disease:", name, "(code:", coding, ")"))
        } else {
        print("You have not inputted a valid code for either the 'disease' field (in parse_get_SR_table_input, self_reported_table, or self_reported_counts) or the 'self_reported` field (in diagnoses_table or diagnoses_counts). Please see coding6 and coding3 for appropriate entries.")
    }
  }
    coding
}
