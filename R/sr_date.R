#' Make a sr_date table
#' 
#' @param diagnosis list of icds
#' @param disease_name disease_name
#' @param dataframe ukb_data
#' @param cancer cancer
#' @keywords sr date
#' @examples
#' @export
#' sr_date()

sr_date <- function(diagnosis, disease_name, dataframe, cancer){
  coding <- parse_get_SR_table_input(diagnosis, cancer) 
  column_name <- str_c("Hx_of_", disease_name)
  dx_SR_list <- dx_sr(diagnosis, disease_name, dataframe, cancer) %>% filter(!!sym(column_name) == 1) %>% pull(eid)
  column_name <- str_c("Date_of_first_", disease_name, "_dx")
  dataframe_positive <- dataframe %>% filter(eid %in% dx_SR_list) 
  
  if (cancer !=  TRUE) {
    self_diagnosed <- select(dataframe_positive, contains(c("eid", "noncancer_illness_code_selfreported_f20002")))
    diagnosis_long <- pivot_longer(self_diagnosed, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$Diagnosis_Column, "noncancer_illness_code_selfreported_f20002_")
    diagnosis_long_filter <- filter(diagnosis_long, diagnosis == coding) %>% select(-Diagnosis_Column) %>% na.omit()
    date_dataframe<-select(dataframe_positive, c(eid, contains("interpolated_year_when_noncancer_illness_first_diagnosed_f20008"))) %>% lapply(as.character ) %>% as_tibble()
    date_long <- pivot_longer(date_dataframe, -eid, names_to = "Date_Column", values_to = "date_of_diagnosis")  %>% na.omit
    date_long$visit_num <- str_remove_all(date_long$Date_Column, "interpolated_year_when_noncancer_illness_first_diagnosed_f20008")
    
  } else {
    self_diagnosed <- select(dataframe_positive, contains(c("eid", "cancer_code_selfreported_f20001")))
    diagnosis_long <- pivot_longer(self_diagnosed, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$Diagnosis_Column, "cancer_code_selfreported_f20001_") 
    diagnosis_long_filter <- filter(diagnosis_long, diagnosis == coding) %>% select(-Diagnosis_Column) %>% na.omit()
    date_dataframe<-select(dataframe_positive, c(eid, contains("interpolated_year_when_cancer_first_diagnosed_f20006_"))) %>% lapply(as.character ) %>% as_tibble()
    date_long <- pivot_longer(date_dataframe, -eid, names_to = "Date_Column", values_to = "date_of_diagnosis") %>% na.omit() 
    date_long$visit_num <- str_remove_all(date_long$Date_Column, "interpolated_year_when_cancer_first_diagnosed_f20006_")
  }
  date_long[, 1]<- sapply(date_long[, 1], as.numeric)
  date_long <- select(date_long, -Date_Column) %>% na.omit() 
  if (cancer == FALSE){
    date_long$eid_visit <- str_c(date_long$eid, date_long$visit_num, sep = "")
  } else {
    date_long$eid_visit <- str_c(date_long$eid, date_long$visit_num, sep = "_")
  }
  diagnosis_long_filter$eid_visit <- str_c(diagnosis_long_filter$eid, diagnosis_long_filter$visit_num, sep ="_")
  visits <- diagnosis_long_filter$eid_visit
  date_long_filtered <- date_long %>% filter(eid_visit %in% visits)
  diagnosis_date_SR <- left_join(date_long_filtered, diagnosis_long_filter) %>% select(-visit_num, -diagnosis, -eid_visit) %>% set_colnames(c("eid", "Date_of_first_X_diagnosis"))
  diagnosis_date_SR$periods <- str_detect(diagnosis_date_SR$Date_of_first_X_diagnosis, "\\.")
  diagnosis_date_SR <- diagnosis_date_SR %>% filter(!(Date_of_first_X_diagnosis %in% c(-1, -3)))
  periods <- diagnosis_date_SR %>% filter(periods == TRUE)
  no_periods <- diagnosis_date_SR %>% filter(periods != TRUE)
  no_periods$Month <- "1"
  no_periods$Day <- "01"
  no_periods$Year <- no_periods$Date_of_first_X_diagnosis
  
  
  periods_split <- str_split_fixed(periods$Date_of_first_X_diagnosis, "\\.", 2) %>%
    as.data.frame() %>%
    setNames(c('Year', 'Second'))
  periods <- bind_cols(periods, periods_split)
  periods <- periods %>% mutate(Month = case_when(
    Second == "1" ~ "1",
    Second == "2" ~ "2",
    Second == "3" ~ "4",
    Second == "4" ~ "5",
    Second == "5" ~ "6",
    Second == "6" ~ "7",
    Second == "7" ~ "8",
    Second == "8" ~ "10",
    Second == "9" ~ "11",     
  ))
  periods$Day <- "01"
  periods <- periods %>% select(-Second)
  combined <- bind_rows(no_periods, periods)
  
  
  combined$Date_of_first_X_diagnosis <- ymd(str_c(combined$Year, combined$Month, combined$Day, sep = "-"))
  combined <- combined %>% select(eid, Date_of_first_X_diagnosis)
  colnames(combined) <- c("eid", "date_of_diagnosis")
  group_by(combined, eid) %>% group_modify(get_first_date) 
  colnames(combined) <- c("eid", column_name)
  combined 
} 