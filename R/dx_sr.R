#' Make a dx_sr table
#' 
#' @param diagnosis list of icds
#' @param disease_name disease_name
#' @param ukb_data ukb_data
#' @param cancer cancer
#' @keywords dx sr
#' @examples
#' @export
#' dx_sr()

dx_sr <- function(diagnosis, disease_name, ukb_data, cancer) {
  coding <- parse_get_SR_table_input(diagnosis, cancer) 
  
  if (cancer == TRUE){
    self_report <- select(ukb_data, eid, contains("cancer_code_selfreported"))
  } else {
    self_report <- select(ukb_data, eid, contains("noncancer_illness_code_selfreported"))
  }
  diagnosis_long <- pivot_longer(self_report, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis") %>% filter(!is.na(diagnosis))
  indiv_with_disease <- filter(diagnosis_long, diagnosis == coding) %>% pull("eid") %>% unique()
  indiv_without_disease <- filter(ukb_data, !(eid %in% indiv_with_disease)) %>% pull(eid)
  
  
  hx_df <- select(ukb_data, eid) %>% mutate(hx = case_when(eid %in% indiv_with_disease ~ 1, eid %in% indiv_without_disease ~ 0)) 
  
  hx_diagnosis <- str_c("Hx_of_", disease_name)
  colnames(hx_df) <- c("eid", hx_diagnosis) 
  hx_df  
} 
