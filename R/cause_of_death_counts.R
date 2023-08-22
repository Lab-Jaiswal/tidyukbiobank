#' A tidyUkBioBank function
#' Function output: counts data of all individuals who contained a matching string in the cause of death columns (M/F breakdown, etc.)
#' 
#' @param description diagnosis of interest (string)
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords cause of death counts
#' @export
#' @examples
#' cause_of_death_counts()

cause_of_death_counts <- function(icd_list, dataframe) {
  COD_eids <- get_cause_of_death_eids(icd_list, dataframe)
  COD_sex <- filter(dataframe, is_in(eid, COD_eids)) %>% select(genetic_sex_f22001_0_0, eid)

  if (nrow(COD_sex) > 0){
    COD_Female_count <- filter(COD_sex, genetic_sex_f22001_0_0 == 0) %>% select(eid) %>% unique() %>% nrow()
    COD_Male_count <- filter(COD_sex, genetic_sex_f22001_0_0 == 1) %>% select(eid) %>% unique() %>% nrow()
    COD_Total <- COD_Female_count + COD_Male_count
    COD_Percent_female <- COD_Female_count/COD_Total
    COD_Percent_male <- COD_Male_count/COD_Total

    age <- cod_age(icd_list, "DX", dataframe)
    age_sex_combined <- left_join(COD_sex, age) %>% na.omit()
    sexes <- c("Male", "Female", "combined")
    age_stats <- map(sexes, get_stats_by_sex, age_sex_combined) %>% flatten %>% unlist()

    Percent_female <- age_stats[6]/age_stats[9]
    Percent_male <- age_stats[3]/age_stats[9]
    COD_df <- data.frame(age_stats[6], age_stats[3], age_stats[9], Percent_female, Percent_male, age_stats[7], age_stats[4], age_stats[1], age_stats[8], age_stats[5], age_stats[2])
    colnames(COD_df) <- c("Female_count", "Male_count", "Total", "Percent_female", "Percent_male", "mean_age_dxd", "Female_mean_age_dxd", "Male_mean_age_dxd", "median_age_dxd", 
                            "Female_median_age_dxd", "Male_median_age_dxd")
  
  } else {
    COD_df <- data.frame(Female_count = 0, Male_count = 0, Total = 0, Percent_female = NA, Percent_male = NA, mean_age_dxd = NA, Female_mean_age_dxd = NA, 
                           Male_mean_age_dxd = NA, median_age_dxd = NA, Female_median_age_dxd = NA, Male_median_age_dxd = NA)
  }
    COD_df
}
