#' Make a diagnoses_ages table
#' 
#' @param dataframe dataframe
#' @keywords diagnoses ages
#' @examples
#' @export
#' diagnoses_ages()

diagnoses_ages <- function(dataframe, ...){
  arguments <- list(...)
  icd_list <- arguments$icd_code_list
  COD <- arguments$cause_of_death
  SR <- arguments$self_reported
  
  if (length(icd_list) > 0 ){
    icd_list_additional <- c(icd_list, list(icd_list))
    icd_labels <- c(icd_list, "Combined_ICD_Codes")
    icd_ages <- map2(icd_list_additional, icd_labels, dx_age, dataframe)
    icd_ages <- icd_ages %>% reduce(full_join)
  } else {
    icd_ages = data.frame(eid = NA)
  }
  
  if (length(COD) > 0){
    COD_additional <- c(COD, list(COD))
    COD_labels <- c(COD, "Combined_Codes")
    COD_labels <- paste(COD_labels, "_COD", sep="")
    COD_ages <- map2(COD_additional, COD_labels, cod_age, dataframe) 
    COD_ages <- COD_ages %>% reduce(full_join)
  } else {
    COD_ages  = data.frame(eid = NA)
  }
  
  if (length(SR) >0){
    cancer <- str_detect(SR, "cancer")
    if (cancer == TRUE) {
      SR <- str_remove(SR, "cancer")
      SR <- str_remove(SR, "_")
      SR <- str_remove(SR, " ")
    }
    SR_ages <- sr_age(SR, SR, dataframe, cancer)
  } else {
    SR_ages = data.frame(eid = NA)
  }
  
  ages_df <- full_join(icd_ages, COD_ages) %>% full_join(SR_ages) %>% filter(!is.na(eid))
  ages_no_eid <- ages_df %>% ungroup %>% select(-eid)
  ages_no_eid$First_Age_Dx_with_All_Codes <- apply(ages_no_eid, 1, FUN = min, na.rm = TRUE)
  eid <- ages_df %>% select(eid)
  ages_df <- bind_cols(eid, ages_no_eid) 
  ages_df  
}
