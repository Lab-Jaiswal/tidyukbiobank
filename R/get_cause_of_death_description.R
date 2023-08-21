#' A tidyUkBioBank function
#' Function output: a table with two columns: eid and cause of death description, which contains string matching the dscription variable given
#' 
#' @param description diagnosis of interest (string)
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords get cause of death description
#' @export
#' @examples
#' get_cause_of_death_description()

get_cause_of_death_description <- function(icd_list, ukb_data){
  COD_eid <- get_cause_of_death_eids(icd_list, ukb_data)
  filtered_for_COD <- ukb_data %>% filter(eid %in% COD_eid)
  COD_description <- select(filtered_for_COD, eid, contains("description_of_cause_of_death")) 
  COD_description
}
