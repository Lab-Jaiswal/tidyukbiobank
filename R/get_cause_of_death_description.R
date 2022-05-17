#' A tidyUkBioBank function
#' Function output: a table with two columns: eid and cause of death description, which contains string matching the dscription variable given
#' 
#' @param description diagnosis of interest (string)
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords get cause of death description
#' @export
#' @examples
#' get_cause_of_death_description()

get_cause_of_death_description <- function(description, ukb_data){
  COD <- select(ukb_data, eid, contains("description_of_cause_of_death"))
  COD_filtered <- filter(COD, str_detect(description_of_cause_of_death_f40010_0_0, description))
  COD_filtered
}
