#' A tidyUkBioBank function
#' Function output: counts data of all individuals who contained a matching string in the cause of death columns (M/F breakdown, etc.)
#' 
#' @param description diagnosis of interest (string)
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords cause of death counts
#' @export
#' @examples
#' cause_of_death_counts()

cause_of_death_counts <- function(description, dataframe) {
  COD_eids <- get_cause_of_death_eids(description, dataframe)
  COD_sex <- filter(dataframe, is_in(eid, COD_eids)) %>% select(genetic_sex_f22001_0_0, eid)
  COD_Female_count <- filter(COD_sex, genetic_sex_f22001_0_0 == "Female") %>% select(eid) %>% unique() %>% nrow()
  COD_Male_count <- filter(COD_sex, genetic_sex_f22001_0_0 == "Male") %>% select(eid) %>% unique() %>% nrow()
  COD_Total <- COD_Female_count + COD_Male_count
  COD_Percent_female <- COD_Female_count/COD_Total
  COD_Percent_male <- COD_Male_count/COD_Total
  
  COD_df <- data.frame(COD_Female_count, COD_Male_count, COD_Total, COD_Percent_female, COD_Percent_male) 
  colnames(COD_df) <- c("Female_count", "Male_count", "Total", "Percent_female", "Percent_male")
  COD_df
}