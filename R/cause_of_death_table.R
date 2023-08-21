#' A tidyUkBioBank function
#' Function output: a table with two columns: eid and cause of death description, which contains string matching the dscription variable given
#' 
#' @param description diagnosis of interest (string)
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords get cause of death table
#' @export
#' @examples
#' cause_of_death_table()

cause_of_death_table <- function(icd_list, ukb_data, disease_name){
  COD_eids <- get_cause_of_death_eids(icd_list, ukb_data)
  COD_description <- get_cause_of_death_description(icd_list, ukb_data)

  COD_df <- select(ukb_data, eid) %>% mutate(hx = case_when(eid %in% COD_eids ~ 1, !eid %in% COD_eids ~ 0)) 
  
  COD_diagnosis <- str_c("Cause_of_Death_Included_", disease_name)
  colnames(COD_df) <- c("eid", COD_diagnosis) 

  COD_df_combined <- left_join(COD_df, COD_description)
  COD_df_combined     
}
