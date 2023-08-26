#' Make a diagnoses_dates table
#' 
#' @param dataframe dataframe
#' @keywords diagnoses dates
#' @examples
#' @export
#' diagnoses_dates()

diagnoses_dates <- function(dataframe, ...){
  arguments <- list(...)
  icd_list <- arguments$icd_code_list
  COD <- arguments$cause_of_death
  SR <- arguments$self_reported
    
  if (length(icd_list) > 0 ){
    icd_list_additional <- c(icd_list, list(icd_list))
    icd_labels <- c(icd_list, "Combined_ICD_Codes")
    icd_dates <- map2(icd_list_additional, icd_labels, dx_date, dataframe)
    icd_dates <- icd_dates %>% reduce(full_join)
  } else {
    icd_dates = data.frame(eid = NA)
  }
  
  if (length(COD) > 0){
    COD_additional <- c(COD, list(COD))
    COD_labels <- c(COD, "Combined_Codes")
    COD_labels <- paste(COD_labels, "_COD", sep="")
    COD_dates <- map2(COD_additional, COD_labels, cod_date, dataframe) 
    COD_dates <- COD_dates %>% reduce(full_join)
  } else {
    COD_dates = data.frame(eid = NA)
  }

  if (length(SR) >0){
    cancer <- str_detect(SR, "cancer")
    if (cancer == TRUE) {
        SR <- str_remove(SR, "cancer")
        SR <- str_remove(SR, "_")
        SR <- str_remove(SR, " ")
    }
    SR_dates <- sr_date(SR, SR, dataframe, cancer)
  } else {
    SR_dates = data.frame(eid = NA)
  }

  dates_df <- full_join(icd_dates, COD_dates) %>% full_join(SR_dates) %>% filter(!is.na(eid))
  dates_no_eid <- dates_df %>% ungroup %>% select(-eid)
  dates_no_eid$First_Date_Dx_with_All_Codes <- apply(dates_no_eid, 1, FUN = min, na.rm = TRUE)
  eid <- dates_df %>% select(eid)
  dates_df <- bind_cols(eid, dates_no_eid) 
  dates_df  
}
