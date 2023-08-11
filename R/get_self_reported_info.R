#' A tidyUkBioBank function
#' Function output: row of the coding6 dataframe, which connects self reported diagnoses to their codes
#' 
#' @param element a number code or string describing the self reported disease of interest
#' @param cancer
#' @keywords self reported info
#' @export
#' @examples
#' get_self_reported_info()

get_self_reported_info <- function(disease_list, cancer){
  list_of_relevant_codes <- map2(disease_list, cancer, search_coding)
  list_of_relevant_names <- map2(disease_list, cancer, search_meaning)
  list_of_relevant_info <- append(list_of_relevant_codes, list_of_relevant_names)
  tibble_of_relevant_info <- bind_rows(list_of_relevant_info) %>% as_tibble %>% unique()
  if(nrow(tibble_of_relevant_info) >= 1) {
    tibble_of_relevant_info
  } else {
      print("You have not inputted a valid string. All strings must have no spaces. Please see coding6 and coding3 for appropriate entries")
  }
  
}
