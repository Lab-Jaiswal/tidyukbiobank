#' A tools4ukbb function
#' 
#' Function output: a column of name "Hx_of_{disease_name}", column of eid values
#' "Hx_of_{disease_name}" contains 0's (indicating an absence of the diagnosis) or 1's (indicating the presence of a diagnosis)
#' 
#' @param icd_list a list of the icd10 codes you wish to investigate
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @param disease_name a string containing the name of the disease(s) of interest
#' @keywords hx
#' @export
#' @examples
#' dx_hx()

dx_hx<- function(icd_list, disease_name, ukb_data, ...){
  arguments <- list(...)

  indiv_with_disease <- individuals_with_disease(icd_list, ukb_data, self_reported = arguments$self_reported, cause_of_death = arguments$cause_of_death)[[1]]
  indiv_without_disease <- individuals_without_disease(icd_list, ukb_data, self_reported = arguments$self_reported, cause_of_death = arguments$cause_of_death)[[1]]
  
  hx_df <- select(ukb_data, eid) %>% mutate(hx = case_when(eid %in% indiv_with_disease ~ 1, eid %in% indiv_without_disease ~ 0)) 

  hx_diagnosis <- str_c("Hx_of_", disease_name)
  colnames(hx_df) <- c("eid", hx_diagnosis) 
  hx_df  
}
