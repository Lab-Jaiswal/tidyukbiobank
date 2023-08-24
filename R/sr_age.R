#' Make a sr_age table
#' 
#' @param diagnosis list of icds
#' @param disease_name disease_name
#' @param ukb_data ukb_data
#' @param cancer cancer
#' @keywords sr age
#' @examples
#' @export
#' sr_age()

sr_age <- function(diagnosis, disease_name, ukb_data, cancer) {
  coding  <- parse_get_SR_table_input(diagnosis, cancer) 
  column_name <- str_c("Hx_of_", disease_name)
  dx_SR_list <- dx_sr(diagnosis, disease_name, ukb_data, cancer) %>% filter(!!sym(column_name) == 1) %>% pull(eid)
  column_name <- str_c("Age_at_first_", disease_name, "_dx")
  dataframe_positive <- ukb_data %>% filter(eid %in% dx_SR_list) 
  
  if (cancer !=  TRUE) {
    self_diagnosed <- select(dataframe_positive, contains(c("eid", "noncancer_illness_code_selfreported_f20002")))
    diagnosis_long <- pivot_longer(self_diagnosed, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$Diagnosis_Column, "noncancer_illness_code_selfreported_f20002_")
    diagnosis_long_filter <- filter(diagnosis_long, diagnosis == coding) %>% select(-Diagnosis_Column) %>% na.omit()
    age_dataframe<-select(dataframe_positive, c(eid, contains("interpolated_age_of_participant_when_noncancer_illness_first_diagnosed_f20009"))) %>% lapply(as.character ) %>% as_tibble()
    age_long <- pivot_longer(age_dataframe, -eid, names_to = "Date_Column", values_to = "age_of_diagnosis")  %>% na.omit
    age_long$visit_num <- str_remove_all(age_long$Date_Column, "interpolated_age_of_participant_when_noncancer_illness_first_diagnosed_f20009_")
    
  } else {
    self_diagnosed <- select(dataframe_positive, contains(c("eid", "cancer_code_selfreported_f20001")))
    diagnosis_long <- pivot_longer(self_diagnosed, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$Diagnosis_Column, "cancer_code_selfreported_f20001_")
    diagnosis_long_filter <- filter(diagnosis_long, diagnosis == coding) %>% select(-Diagnosis_Column) %>% na.omit()
    age_dataframe <- select(dataframe_positive, c(eid, contains("interpolated_age_of_participant_when_cancer_first_diagnosed_f20007"))) %>% lapply(as.character ) %>% as_tibble()
    age_long <- pivot_longer(age_dataframe, -eid, names_to = "Date_Column", values_to = "age_of_diagnosis")  %>% na.omit
    age_long$visit_num <- str_remove_all(age_long$Date_Column, "interpolated_age_of_participant_when_cancer_first_diagnosed_f20007_")
    
  }
  age_long[, 1]<- sapply(age_long[, 1], as.numeric)
  age_long <- select(age_long, -Date_Column) %>% na.omit() 
  age_long$eid_visit <- str_c(age_long$eid, age_long$visit_num, sep = "_")
  
  diagnosis_long_filter$eid_visit <- str_c(diagnosis_long_filter$eid, diagnosis_long_filter$visit_num, sep ="_")
  visits <- diagnosis_long_filter$eid_visit
  age_long_filtered <- age_long %>% filter(eid_visit %in% visits)
  diagnosis_age_SR <- left_join(age_long_filtered, diagnosis_long_filter) %>% select(-visit_num, -diagnosis, -eid_visit)
  colnames(diagnosis_age_SR) <- c("eid", "date_of_diagnosis")
  diagnosis_age_SR <- group_by(diagnosis_age_SR, eid) %>% group_modify(get_first_date) 
  colnames(diagnosis_age_SR) <- c("eid", column_name)
  diagnosis_age_SR  
  
}