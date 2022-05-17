#' A tools4ukbb function
#' Function output: a list of all individuals (identified by eid) that have NOT been diagnosed with the icd_codes of interest
#' 
#' @param icd_list a list of the icd10 codes you wish to investigate
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords without
#' @export
#' @examples
#' individuals_without_disease()

individuals_without_disease <- function(icd_list, ukb_data, ...)  {
  arguments <- list(...)
  indiv_with_diseases <-  individuals_with_disease(icd_list, ukb_data, self_reported = arguments$self_reported, cause_of_death = arguments$cause_of_death)
  indiv_with_disease_combined <- indiv_with_diseases[[1]]
  
  
  all_indiv_eid<- ukb_data$eid
  
  indiv_without_disease_combined <- setdiff(all_indiv_eid, indiv_with_diseases[[1]])
  indiv_without_disease_icd9 <- setdiff(all_indiv_eid, indiv_with_diseases[[2]])
  indiv_without_disease_icd10 <- setdiff(all_indiv_eid, indiv_with_diseases[[3]])
  indiv_without_disease_COD <- setdiff(all_indiv_eid, indiv_with_diseases[[4]])
  indiv_without_disease_SR <- setdiff(all_indiv_eid, indiv_with_diseases[[5]])

  indiv_without_disease_whole <- list(indiv_without_disease_combined, indiv_without_disease_icd9, indiv_without_disease_icd10, indiv_without_disease_COD, indiv_without_disease_SR)
  names(indiv_without_disease_whole) <- c("combined", "icd9", "icd10", "cause_of_death", "self_reported")
  indiv_without_disease_whole
}
