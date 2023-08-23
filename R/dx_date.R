#' A tools4ukbb function
#'
#' Function output: a column of name "Date_of_first_{disease_name}_diagnosis", column of eid values
#' "Date_of_first_{disease_name}_diagnosis" contains the date an individual received the diagnosis (as indicated by the icd_code(s) of interest)
#' 
#' @param icd_list a list of the icd10 codes you wish to investigate
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (502462 x 18158 as of 09/07/2021)
#' @param disease_name a string containing the name of the disease(s) of interest
#' @keywords date
#' @export
#' @examples
#' dx_date()


dx_date <- function(icd_list, disease_name, dataframe){
  indiv_with_disease <- individuals_with_disease(icd_list, dataframe)    
  
  if (length(indiv_with_disease[[2]]) > 0){
    diagnoses_1<-select(dataframe, c(eid, contains("diagnoses_icd9")))
    diagnoses_2<-select(dataframe,c(contains("diagnoses_secondary_icd9")))
    diagnoses_df<-cbind(diagnoses_1, diagnoses_2)
    
    icd9_with_disease <- indiv_with_disease[[2]]
    dx_positive <- filter(dataframe, is_in(eid, icd9_with_disease))
    icd_table <- filter(diagnoses_df, is_in(eid, icd9_with_disease))
    
    diagnosis_long <- pivot_longer(icd_table, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$Diagnosis_Column, "diagnoses_icd9_f41271_")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$visit_num, "diagnoses_secondary_icd9_f41205_")
    diagnosis_long_filter <- filter(diagnosis_long, is_in(diagnosis, icd_list)) %>% select(-Diagnosis_Column)
    
    #chang lapply and sapply to map
    date_dataframe<-select(dx_positive, c(eid, contains("date_of_first_inpatient_diagnosis_icd9"))) %>% lapply(as.character ) %>% as_tibble()
    date_long <- pivot_longer(date_dataframe, -eid, names_to = "Date_Column", values_to = "date_of_diagnosis")  
    date_long$visit_num <- str_remove_all(date_long$Date_Column, "date_of_first_inpatient_diagnosis_icd9_f41281_")
    
    date_long[, 1]<- sapply(date_long[, 1], as.numeric)
    date_long <- select(date_long, -Date_Column)
    diagnosis_date_icd9 <- left_join(diagnosis_long_filter, date_long) %>% select(-visit_num) 
    } else {
      
      diagnosis_date_icd9  <- data.frame("eid" = NA, "diagnosis" = NA, "date_of_diagnosis" = NA)
    }
  
  if (length(indiv_with_disease[[3]]) > 0){
    diagnoses_1<-select(dataframe, c(eid, contains("diagnoses_icd10")))
    diagnoses_2<-select(dataframe,c(contains("diagnoses_secondary_icd10")))
    diagnoses_df<-cbind(diagnoses_1, diagnoses_2)
    
    icd10_with_disease <- indiv_with_disease[[3]]
    dx_positive <- filter(dataframe, is_in(eid, icd10_with_disease))
    icd_table <- filter(diagnoses_df, is_in(eid, icd10_with_disease))
    
    diagnosis_long <- pivot_longer(icd_table, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$Diagnosis_Column, "diagnoses_icd10_f41270_")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$visit_num, "diagnoses_secondary_icd10_f41204_")
    diagnosis_long_filter <- filter(diagnosis_long, is_in(diagnosis, icd_list)) %>% select(-Diagnosis_Column)
    
    date_dataframe<-select(dx_positive, c(eid, contains("date_of_first_inpatient_diagnosis_icd10"))) %>% lapply(as.character ) %>% as_tibble()
    date_long <- pivot_longer(date_dataframe, -eid, names_to = "Date_Column", values_to = "date_of_diagnosis")  
    date_long$visit_num <- str_remove_all(date_long$Date_Column, "date_of_first_inpatient_diagnosis_icd10_f41280_")
    
    date_long[, 1]<- sapply(date_long[, 1], as.numeric)
    date_long <- select(date_long, -Date_Column)
    diagnosis_date_icd10 <- left_join(diagnosis_long_filter, date_long) %>% select(-visit_num) } else {
      
      diagnosis_date_icd10  <- data.frame("eid" = NA, "diagnosis" = NA, "date_of_diagnosis" = NA)
    }
  
  
  diagnosis_date <- bind_rows(diagnosis_date_icd10, diagnosis_date_icd9) %>% drop_na()
  diagnosis_first_date <- group_by(diagnosis_date, eid) %>% group_modify(get_first_date)
  names(diagnosis_first_date)[names(diagnosis_first_date) == "date_of_diagnosis"] <- str_c("Date_of_first_", disease_name, "_dx")
  column_name <- str_c("Date_of_first_", disease_name, "_dx")
  diagnosis_first_date_noncancer <- diagnosis_first_date

  indiv_with_disease_df <- as.data.frame(indiv_with_disease[[1]])
  colnames(indiv_with_disease_df) <- "eid"
  diagnosis_first_date_cancer <- filter(indiv_with_disease_df, !is_in(eid, diagnosis_first_date_noncancer$eid)) 

  if (nrow(diagnosis_first_date_cancer) > 0){
    diagnoses_1<-select(dataframe, c(eid, contains("cancer_icd10")))
    diagnoses_2<-select(dataframe,c(contains("cancer_icd9")))
    diagnoses_df<-cbind(diagnoses_1, diagnoses_2)
    
    icd_with_disease <- diagnosis_first_date_cancer$eid
    dx_positive <- filter(dataframe, is_in(eid, icd_with_disease))
    icd_table <- filter(diagnoses_df, is_in(eid, icd_with_disease))
    
    diagnosis_long <- pivot_longer(icd_table, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis") %>% filter(!is.na(diagnosis)) %>% filter(is_in(diagnosis, icd_list))
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$Diagnosis_Column, "type_of_cancer_icd10_f40006_")
    diagnosis_long$visit_num <- str_remove_all(diagnosis_long$visit_num, "type_of_cancer_icd9_f40013_")
    diagnosis_long_filter <- filter(diagnosis_long, is_in(diagnosis, icd_list)) %>% select(-Diagnosis_Column)
    
    date_dataframe<-select(dx_positive, c(eid, contains("date_of_cancer_diagnosis"))) %>% lapply(as.character ) %>% as_tibble()
    date_long <- pivot_longer(date_dataframe, -eid, names_to = "Date_Column", values_to = "date_of_diagnosis") %>% filter(!is.na(date_of_diagnosis)) 
    date_long$visit_num <- str_remove_all(date_long$Date_Column, "date_of_cancer_diagnosis_f40005_")
    
    date_long[, 1]<- sapply(date_long[, 1], as.numeric)
    date_long <- select(date_long, -Date_Column)
    diagnosis_date_cancer <- left_join(diagnosis_long_filter, date_long) %>% select(-visit_num, -diagnosis) %>% set_colnames(c("eid", column_name)) 
    
    diagnosis_date <- bind_rows(diagnosis_date_cancer, diagnosis_first_date_noncancer)
  
  } else {
      diagnosis_date <- diagnosis_first_date_noncancer
  }

  diagnosis_date
  
}
