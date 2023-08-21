#' A tidyUkBioBank function
#' Function output: list of eids of individuals containing a match to the provided string in the cause of death columns
#' 
#' @param description diagnosis of interest (string)
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords get cause of death eids
#' @export
#' @examples
#' get_cause_of_death_eids()

get_cause_of_death_eids <- function(icd_list, ukb_data){
  ukb_data_subset <- select(ukb_data, contains(c("eid", "underlying_primary_cause_of_death", "contributory_secondary_ca_")))
  ukb_data_filtered <- ukb_data_subset %>% filter_all(any_vars(. %in% icd_list)) %>% as_tibble()
  COD_eid <- ukb_data_filtered$eid
  COD_eid
}
