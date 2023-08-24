#' A tidyUkBioBank function
#' Function output: table with the code/ string provided and information about the self_reported code selected
#' Outputs a print statment with information about the self reported code selected
#' 
#' @param diagnosis a number code or string describing the self reported disease of interest
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @param cancer
#' @keywords get self reported table
#' @export
#' @examples
#' self_reported_table()

self_reported_table <- function(diagnosis, disease_name, ukb_data, cancer){
    coding <- parse_get_SR_table_input(diagnosis, cancer) 

  if (cancer == TRUE){
    self_report <- select(ukb_data, eid, contains("cancer_code_selfreported"))
    diagnosis_long <- pivot_longer(self_report, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis") %>% filter(!is.na(diagnosis))
    eid_positive_list <- filter(diagnosis_long, diagnosis == coding) %>% pull("eid") %>% unique()
  } else {
    self_report <- select(ukb_data, eid, contains("noncancer_illness_code_selfreported"))
    diagnosis_long <- pivot_longer(self_report, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis")
    eid_positive_list <- filter(diagnosis_long, diagnosis == coding) %>% pull("eid") %>% unique() 
  }

  with_SR <- filter(ukb_data, is_in(eid, eid_positive_list)) %>% select(eid)
  with_SR$self_reported_col <- 1
  without_SR <- filter(ukb_data, !is_in(eid, eid_positive_list)) %>% select(eid)
  without_SR$self_reported_col <- 0
  self_reporting_table <- bind_rows(without_SR, with_SR)
  colnames(self_reporting_table) <- c("eid", coding)

  SR_age <- sr_age(diagnosis, disease_name, ukb_data, cancer)  
  SR_date <- sr_date(diagnosis, disease_name, ukb_data, cancer)

  SR_df_combined <- left_join(self_reporting_table, SR_date) %>% left_join(SR_age)

  if (cancer == TRUE){
    SR_diagnosis <- str_c("Self_Reported_Included_", diagnosis, "_cancer")
  } else {
    SR_diagnosis <- str_c("Self_Reported_Included_", diagnosis)
  }
    names(SR_df_combined)[names(SR_df_combined) == coding] <- SR_diagnosis

  SR_df_combined     
}
