#' A tidyUkBioBank function
#' Function output: counts data of all individuals who reported the disease of interest (M/F breakdown, etc.)
#' 
#' @param disease diagnosis of interest (string or code)
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords self reported counts
#' @export
#' @examples
#' self_reported_counts()

self_reported_counts <- function(disease, dataframe) {
  
  coding <- parse_get_SR_table_input(disease) 
  
  SR_eids <- get_self_reported_eids(coding, ukb_data) 
  SR_sex <- filter(dataframe, is_in(eid, SR_eids)) %>% select(genetic_sex_f22001_0_0, eid)
  SR_Female_count <- filter(SR_sex, genetic_sex_f22001_0_0 == "Female") %>% select(eid) %>% unique() %>% nrow()
  SR_Male_count <- filter(SR_sex, genetic_sex_f22001_0_0 == "Male") %>% select(eid) %>% unique() %>% nrow()
  SR_Total <- SR_Female_count + SR_Male_count
  SR_Percent_female <- SR_Female_count/SR_Total
  SR_Percent_male <- SR_Male_count/SR_Total
  
  SR_df <- data.frame(SR_Female_count, SR_Male_count, SR_Total, SR_Percent_female, SR_Percent_male) 
  colnames(SR_df) <- c("Female_count", "Male_count", "Total", "Percent_female", "Percent_male")
  SR_df
}
