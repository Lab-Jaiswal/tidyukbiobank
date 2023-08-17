#' A tidyUkBioBank function
#' Function output: dataframe containing eids, date of first diagnosis, and age at first recorded daignosis
#' 
#' @param icd_list list of icds of interest
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @param disease_name name of the disease of interest (under which all of the icd codes in icd_list fall)
#' @keywords ukb_info
#' @export
#' @examples
#' icd_table()

icd_table <- function(icd_list, dataframe, disease_name) {
  indiv_with_disease <- individuals_with_disease(icd_list, dataframe)
  dx_positive<- filter(dataframe, is_in(eid, indiv_with_disease[[1]]))   
  
  eid_df <- select(dx_positive, eid)
  date_dx <- dx_date(icd_list, disease_name, dataframe) %>% left_join(eid_df, by ="eid")
  age_dx  <- dx_age(icd_list, disease_name, dataframe) %>% left_join(eid_df, by ="eid")
  
  hx_dx <- dx_hx(icd_list, disease_name, dataframe) %>% left_join(eid_df, by ="eid")
  
  date_age <- left_join(date_dx, age_dx) 
  hx_date_age <- left_join(date_age, hx_dx)
  hx_date_age_final  <- hx_date_age[,colSums(is.na(hx_date_age))<nrow(hx_date_age)]

  dx_negative <- filter(dataframe, !is_in(eid, indiv_with_disease[[1]])) %>% pull(eid)
  age_negative <- str_c("Age_at_first_", disease_name, "_dx")
  date_negative <- str_c("Date_of_first_", disease_name, "_dx")
  hx_negative <- str_c("Hx_of_", disease_name)
  dx_negative <- data.frame(eid = dx_negative, age_negative = NA, date_negative = NA, hx_negative = NA)
  colnames(dx_negative) <- c("eid", age_negative, date_negative, hx_negative)
  
  final <- bind_rows(hx_date_age_final, dx_negative)
  final
  
}
