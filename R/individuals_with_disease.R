#' A tools4ukbb function
#' Function output: a list of all individuals (identified by eid) that have been diagnosed with the icd_codes of interest
#' 
#' @param icd_list a list of the icd10 codes you wish to investigate
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords with
#' @export
#' @examples
#' individuals_with_disease()

individuals_with_disease <- function(icd_list, ukb_data, ...) {
  icd10_list <- grep("([A-Za-z].*[0-9])|[0-9].*[A-Za-z].*[0-9]", icd_list, value = TRUE)
  icd9_list <- grep("([A-Za-z].*[0-9])|[0-9].*[A-Za-z].*[0-9]", icd_list, value = TRUE, invert=TRUE)
  arguments <- list(...)
  
  if (length(icd9_list) > 0) {
    icd9_cols <- c("eid", "diagnoses_icd9", "diagnoses_secondary_icd9", "cancer_icd9")
    indiv_with_disease_icd9 <- search_icd_codes(icd9_cols, icd9_list, ukb_data) 
    } else {
      indiv_with_disease_icd9 = NA
    }
  
  if (length(icd10_list) > 0) {
    icd10_cols <- c("eid","diagnoses_icd10", "diagnoses_secondary_icd10", "underlying_primary_cause_of_death", "contributory_secondary_ca_", "cancer_icd10")
    indiv_with_disease_icd10 <- search_icd_codes(icd10_cols, icd10_list, ukb_data)
    } else {
    indiv_with_disease_icd10 = NA
    }
  
  if (length(arguments$cause_of_death) > 0){
    indiv_with_disease_COD <- map(arguments$cause_of_death, get_cause_of_death_eids, ukb_data) %>% flatten() %>% unlist() %>% unique()
  } else {
    indiv_with_disease_COD = NA
    }

  if(length(arguments$self_reported) > 0){
    self_reported_df <- arguments$self_reported
    cancer <- str_detect(self_reported_df, "cancer")
    if (cancer == TRUE) {
        self_reported_df <- str_remove(self_reported_df, "cancer")
        self_reported_df <- str_remove(self_reported_df, "_")
        self_reported_df <- str_remove(self_reported_df, " ")
    }
    indiv_with_disease_SR <- map(self_reported_df, get_self_reported_eids, ukb_data, cancer) %>% flatten() %>% unlist() %>% unique()
    } else {
    indiv_with_disease_SR = NA
    }


    indiv_with_disease_combined <- c(indiv_with_disease_icd10, indiv_with_disease_icd9, indiv_with_disease_COD, indiv_with_disease_SR) %>% unique() %>% unlist()
    indiv_with_disease_combined <- indiv_with_disease_combined[!is.na(indiv_with_disease_combined)]
    indiv_with_diseases_whole <- list(indiv_with_disease_combined, indiv_with_disease_icd9, indiv_with_disease_icd10, indiv_with_disease_COD, indiv_with_disease_SR)
    names(indiv_with_diseases_whole) <- c("combined", "icd9", "icd10", "cause_of_death", "self_reported")
  
  indiv_with_diseases_whole
 
}
