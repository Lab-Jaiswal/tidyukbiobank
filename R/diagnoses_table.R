#' A tidyUkBioBank function
#' Function output: a table with an eid columns, columns pertaining to specific icd/ self reported/ cause of death codes, and a column for all previously mentioned disease indicators (combined) 
#' The columns with disease indicators contain 1's and 0's to represent whether the eid has the icd code, etc. of interest (1) or not (0)
#' 
#' @param icd_codes optional. list of icd codes
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @param self_reported optional. if the user requests self reported diagnoses, then type self_reported = sr_list, where sr_list contains the self_reported codes of interest
#' @param cause_of_death optional. if the user requests cause_of_death diagnoses, then type cause_of_death = cod_list, where cod_list contains the cause of death of interest
#' @keywords diagnoses table
#' @export
#' @examples
#' diagnoses_table()

diagnoses_table <- function(ukb_data, ...) {
  arguments <- list(...)
  SR <- arguments$self_reported
  COD <- arguments$cause_of_death
  icd_list <- arguments$icd_code_list

  if (length(icd_list) > 0) {
  
    icd10_list <- grep("([A-Za-z].*[0-9])|[0-9].*[A-Za-z].*[0-9]", icd_list, value = TRUE)
    icd9_list <- grep("([A-Za-z].*[0-9])|[0-9].*[A-Za-z].*[0-9]", icd_list, value = TRUE, invert=TRUE)
    
    if (length(icd10_list) > 0){
      dx_df_icd10 <- map2(icd10_list, icd10_list, dx_hx, ukb_data) %>%
      reduce(left_join) %>%
      mutate(Total_Sums_Icd10 = rowSums(select(., -eid))) %>%
      mutate(Presence_of_Icd10_dx = case_when(Total_Sums_Icd10 > 0 ~ 1, Total_Sums_Icd10 < 1 ~ 0))
      ICD10 <- TRUE
    } else {
        dx_df_icd10 = data.frame(eid = ukb_data$eid, Total_Sums_Icd10 = 0)
        ICD10 <- FALSE
  
    }
  
    if (length(icd9_list) > 0) {
      dx_df_icd9 <- map2(icd9_list, icd9_list, dx_hx, ukb_data) %>%
      reduce(left_join) %>%
      mutate(Total_Sums_Icd9 = rowSums(select(., -eid))) %>%
      mutate(Presence_of_Icd9_dx = case_when(Total_Sums_Icd9 > 0 ~ 1, Total_Sums_Icd9 < 1 ~ 0))
      ICD9 <- TRUE
    } else {
      dx_df_icd9 = data.frame(eid = ukb_data$eid, Total_Sums_Icd9 = 0)
      ICD9 <- FALSE
    }
  } else {
       print("ICD code information not requested")
       dx_df_icd9 = data.frame(eid = ukb_data$eid, Total_Sums_Icd9 = 0)
       ICD9 <- FALSE
       dx_df_icd10 = data.frame(eid = ukb_data$eid, Total_Sums_Icd10 = 0)
       ICD10 <- FALSE
  }
 
  if (length(SR) > 0) {
    self_reported_df <- arguments$self_reported
    cancer <- str_detect(self_reported_df, "cancer")
    if (cancer == TRUE) {
        self_reported_df <- str_remove(self_reported_df, "cancer")
        self_reported_df <- str_remove(self_reported_df, "_")
        self_reported_df <- str_remove(self_reported_df, " ")
    }
    dx_sr <- map2(self_reported_df, self_reported_df, dx_sr, ukb_data, cancer) %>%
      reduce(left_join) %>%
      mutate(Total_Sums_Self_Reported = rowSums(select(., -eid))) %>%
      mutate(Presence_of_Self_Reported_DX = case_when(Total_Sums_Self_Reported > 0 ~ 1, Total_Sums_Self_Reported < 1 ~ 0))
    SR <- TRUE
  } else {
    print("Self Reported stats not requested")
    dx_sr = data.frame(eid = ukb_data$eid, Presence_of_Self_Reported_DX = 0, Total_Sums_Self_Reported = 0)
    SR <- FALSE
  }
  
  if (length(COD) > 0) {
    dx_df_cod <- map2(COD, COD, dx_cod, ukb_data) %>%
      reduce(left_join)
    cod_colnames <- colnames(dx_df_cod)
    cod_colnames <- cod_colnames[-1] 
    cod_colnames <- paste("COD", cod_colnames, sep="_")
    cod_colnames <- c("eid", cod_colnames)
    colnames(dx_df_cod) <- cod_colnames
    dx_df_cod <- dx_df_cod %>%  mutate(Total_Sums_Cause_of_Death = rowSums(select(., -eid))) %>%
      mutate(Presence_of_Cause_of_Death_DX = case_when(Total_Sums_Cause_of_Death > 0 ~ 1, Total_Sums_Cause_of_Death < 1 ~ 0))
    COD <- TRUE
  } else {
    dx_df_cod = data.frame(eid = ukb_data$eid, Presence_of_Cause_of_Death_DX = 0, Total_Sums_Cause_of_Death = 0)
    COD <- FALSE
    
  }
  
  df_list <- list(dx_df_icd10, dx_df_icd9, dx_sr, dx_df_cod)
  history_df <- df_list %>% reduce(left_join) %>% 
    mutate(Sum_of_All_Diagnoses = rowSums(select(., Total_Sums_Icd10, Total_Sums_Icd9, Total_Sums_Self_Reported, Total_Sums_Cause_of_Death))) %>%
    mutate(Presence_of_Any_Requested_DX = case_when(Sum_of_All_Diagnoses > 0 ~ 1, Sum_of_All_Diagnoses < 1 ~ 0)) %>%
    select(-Sum_of_All_Diagnoses, -Total_Sums_Cause_of_Death, -Total_Sums_Self_Reported, Total_Sums_Icd10, Total_Sums_Icd9)
    if (ICD9 == FALSE) {
       history_df <- history_df %>% select(-Presence_of_Icd9_dx)
   }
   if (ICD10 == FALSE) {
       history_df <- history_df %>% select(-Presence_of_Icd9_dx)
   }
  if (SR == FALSE) {
      history_df <- history_df %>% select(-Presence_of_Self_Reported_DX)  
  }
  if (COD == FALSE) {
      history_df <- history_df %>% select(-Presence_of_Cause_of_Death_DX)
  }
  
  history_df
}
