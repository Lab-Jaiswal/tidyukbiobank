#' A tidyUkBioBank function
#' Function output: a table with two columns: eid and cause of death description, which contains string matching the dscription variable given
#' 
#' @param description diagnosis of interest (string)
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @param disease_name string with disease name
#' @keywords get cause of death table
#' @export
#' @examples
#' cause_of_death_table()

cause_of_death_table <- function(icd_list, ukb_data, disease_name){
  COD_eids <- get_cause_of_death_eids(icd_list, ukb_data)
  COD_description <- get_cause_of_death_description(icd_list, ukb_data)

  COD_df <- select(ukb_data, eid) %>% mutate(hx = case_when(eid %in% COD_eids ~ 1, !eid %in% COD_eids ~ 0)) 
  COD_age <- cod_age(icd_list, disease_name, ukb_data)  
  COD_date <- cod_date(icd_list, disease_name, ukb_data)

  COD_df_combined <- left_join(COD_df, COD_date) %>% left_join(COD_age) %>% left_join(COD_description)

  COD_diagnosis <- str_c("Cause_of_Death_Included_", disease_name)
  names(COD_df_combined)[names(COD_df_combined) == 'hx'] <- COD_diagnosis

  COD_df_combined     
}
