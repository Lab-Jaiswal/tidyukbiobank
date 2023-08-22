#' Make a cod_date table
#' 
#' @param icd_list list of icds
#' @param disease_name
#' @param dataframe dataframe
#' @keywords cod date
#' @examples
#' @export
#' cod_date()

cod_date <- function(icd_list, disease_name, dataframe){
  column_name <- str_c("Hx_of_", disease_name)
  dx_cod_list <- dx_cod(icd_list, disease_name, dataframe) %>% filter(!!sym(column_name) == 1) %>% pull(eid)
  dataframe_positive <- dataframe %>% filter(eid %in% dx_cod_list)
  
  get_first_date <- function(diagnosis_date_rows, diagnosis_date_group) {
    first_diag <- arrange(diagnosis_date_rows, date_of_diagnosis) %>% slice(1)
    select(first_diag, date_of_diagnosis)
  }
  
  first_DOD <- dataframe_positive %>% select(eid, date_of_death_f40000_0_0) %>% set_colnames(c("eid", "date_of_diagnosis"))
  second_DOD <- dataframe_positive %>% select(eid, date_of_death_f40000_1_0) %>% set_colnames(c("eid", "date_of_diagnosis"))
  
  DOD <- bind_rows(first_DOD, second_DOD) %>% drop_na()
  death_first_date <- group_by(DOD, eid) %>% group_modify(get_first_date)
  death_first_date <- death_first_date %>% set_colnames(c("eid", str_c("Date_of_first_", disease_name, "_dx")))
  death_first_date
} 