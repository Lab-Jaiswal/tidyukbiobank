#' A tidyUkBioBank function
#' Function output: list of eids of individuals who self reported the diagnosis/ code of interest
#' 
#' @param diagnosis diagnosis of interest (string or code)
#' @cancer
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords get self reported eids
#' @export
#' @examples
#' get_self_reported_eids()

get_self_reported_eids <- function(diagnosis, ukb_data, cancer, ...){
  arguments <- list(...)
  if(length(arguments$called) > 0) {
    coding <- diagnosis
  } else {
      coding <- parse_get_SR_table_input(diagnosis, cancer) 
  }
  if (cancer == FALSE) { 
    self_report <- select(ukb_data, eid, contains("noncancer_illness_code_selfreported"))
    diagnosis_long <- pivot_longer(self_report, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis") %>% filter(!is.na(diagnosis))
    eid_self_reported_list <- filter(diagnosis_long, diagnosis == coding) %>% pull("eid") %>% unique()    
  } else {
    self_report <- select(ukb_data, eid, contains("cancer_code_selfreported"))
    diagnosis_long <- pivot_longer(self_report, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis") %>% filter(!is.na(diagnosis))
    eid_self_reported_list <- filter(diagnosis_long, diagnosis == coding) %>% pull("eid") %>% unique()
  }
  eid_self_reported_list
}
