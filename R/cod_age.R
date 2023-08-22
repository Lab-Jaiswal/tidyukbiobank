#' Make a cod_date table
#' 
#' @param icd_list list of icds
#' @param disease_name
#' @param dataframe dataframe
#' @keywords cod age
#' @examples
#' @export
#' cod_age()

cod_age <- function(icd_list, disease_name, dataframe){
  column_name <- str_c("Hx_of_", disease_name)
  dx_cod_list <- dx_cod(icd_list, disease_name, dataframe) %>% filter(!!sym(column_name) == 1) %>% pull(eid)
  dx_positive <- dataframe %>% filter(eid %in% dx_cod_list)
  
  first_dx_date <- cod_date(icd_list, "X", dataframe)
  first_dx_date$diagnosis_date <- ymd(first_dx_date$Date_of_first_X_dx) 
  
  DOB_col<- date_of_birth(dx_positive)
  first_dx_date_with_DOB<- left_join(DOB_col, first_dx_date, by="eid") 
  first_dx_date_with_DOB[, str_c("Age_at_first_", disease_name, "_dx")] <- interval(start= first_dx_date_with_DOB$DOB, end=first_dx_date_with_DOB$diagnosis_date)/                  
    duration(n=1, unit="years")
  
  first_dx_date_with_age <- select(first_dx_date_with_DOB, -DOB, -Date_of_first_X_dx, -diagnosis_date)
  first_dx_date_with_age
}
