#' A tidyUkBioBank function
#' Function output: row of the coding6 dataframe, which connects self reported diagnoses to their codes
#' 
#' @param element a number code or string describing the self reported disease of interest
#' @keywords self reported info
#' @export
#' @examples
#' get_self_reported_info()

get_self_reported_info <- function(disease_list){
  list_of_relevant_codes <- map(disease_list, search_coding)
  list_of_relevant_names <- map(disease_list, search_meaning)
  list_of_relevant_info <- append(list_of_relevant_codes, list_of_relevant_names)
  tibble_of_relevant_info <- bind_rows(list_of_relevant_info) %>% as_tibble %>% unique()
  tibble_of_relevant_info
}