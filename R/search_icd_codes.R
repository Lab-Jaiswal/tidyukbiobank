#' A tidyUkBioBank function
#' Function output: internal function, a list of individuals whose data contains the icd codes in the icd_list variable 
#' 
#' @param columns columns to be searched
#' @param icd_list list of icd codes
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords search icd codes
#' @export
#' @examples
#' search_icd_codes()

search_icd_codes <- function(columns, icd_list, ukb_data){
  ukb_data_subset <-select(ukb_data, contains(columns))
  ukb_data_filtered <- ukb_data_subset %>% filter_all(any_vars(. %in% icd_list)) %>% as_tibble()
  indiv_with_disease <- ukb_data_filtered$eid
  indiv_with_disease
}