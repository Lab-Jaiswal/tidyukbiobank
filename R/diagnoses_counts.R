#' A tidyUkBioBank function
#' Function output: dataframe containing counts data for icds of interest, self reported diseases (via codes or strings), and cause of death information (strings)
#' 
#' @param icd_list list of icds of interest
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords dx demographics
#' @export
#' @examples
#' diagnoses_counts()

diagnoses_counts <- function(dataframe, ...){
  arguments <- list(...)
  icd_list <- arguments$icd_code_list
  COD <- arguments$cause_of_death
  if (length(icd_list) >= 1){
     icd_list_additional <- c(icd_list, list(icd_list))
     icd_labels <- c(icd_list, "Combined_ICD_Codes")
     icd_stats <- map(icd_list_additional, icd_counts, dataframe) %>% do.call(rbind, .) %>% mutate(dx_codes = icd_labels) 
  } else {
    icd_stats = data.frame()
  }
   
  if(length(arguments$self_reported) > 0){
    self_reported_df <- arguments$self_reported
    cancer <- str_detect(self_reported_df, "cancer")
    if (cancer == TRUE) {
        self_reported_df <- str_remove(self_reported_df, "cancer")
        self_reported_df <- str_remove(self_reported_df, "_")
        self_reported_df <- str_remove(self_reported_df, " ")
    }
    sr_stats <- self_reported_counts(self_reported_df, dataframe, cancer) %>% mutate(dx_codes = paste("Self_Reported_", self_reported_df )) 
    } else { 
    sr_stats = data.frame() 
    }
  
  if (length(COD) > 0) {
    cod_list_additional <- c(COD, list(COD))
    COD <- paste("COD", COD, sep="_")
    cod_labels <- c(COD, "Combined_COD_Codes")
    cod_stats <- map(cod_list_additional, cause_of_death_counts, dataframe) %>% do.call(rbind, .) %>% mutate(dx_codes = cod_labels)
  } else {
    cod_stats = data.frame() 
  }
  
  final_stats_df <- bind_rows(icd_stats, sr_stats, cod_stats)
  final_stats_df
}
