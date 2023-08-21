#' Make a dx_cod table
#' 
#' @param icd_list list of icds
#' @param disease_name
#' @param ukb_data dataframe
#' @keywords dx cod
#' @examples
#' @export
#' dx_cod()

dx_cod <- function(icd_list, disease_name, ukb_data){
  
  indiv_with_disease <- get_cause_of_death_eids(icd_list, ukb_data)
  indiv_without_disease <- filter(ukb_data, !(eid %in% indiv_with_disease)) %>% pull(eid)
  
  hx_df <- select(ukb_data, eid) %>% mutate(hx = case_when(eid %in% indiv_with_disease ~ 1, eid %in% indiv_without_disease ~ 0)) 
  
  hx_diagnosis <- str_c("Hx_of_", disease_name)
  colnames(hx_df) <- c("eid", hx_diagnosis) 
  hx_df  
}