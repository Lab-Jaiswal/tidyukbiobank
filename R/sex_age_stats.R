#' A tidyUkBioBank function
#' Function output: dataframe containing counts data and age of diagnosis inforamtion for icd codes of interest
#' 
#' @param list_icd list of icds of interest
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords sex_age_stats
#' @export
#' @examples
#' sex_age_stats()

sex_age_stats <- function(list_icd, dataframe){
  indiv_with_disease <- individuals_with_disease(list_icd, dataframe)
  sex_df <- filter(dataframe, is_in(eid, indiv_with_disease[[1]])) %>% select(genetic_sex_f22001_0_0)
  
  if (nrow(sex_df) > 0) {                
    age <- dx_age(list_icd, "DX", dataframe)
    age_sex_combined <- bind_cols(sex_df, age)
    sexes <- c("Male", "Female", "combined")
    age_stats <- map(sexes, get_stats_by_sex, age_sex_combined) %>% flatten %>% unlist() 
    
    Percent_female <- age_stats[6]/age_stats[9]
    Percent_male <- age_stats[3]/age_stats[9]
    stats_df <- data.frame(age_stats[6], age_stats[3], age_stats[9], Percent_female, Percent_male, age_stats[7], age_stats[4], age_stats[1], age_stats[8], age_stats[5], age_stats[2])
    colnames(stats_df) <- c("Female_count", "Male_count", "Total", "Percent_female", "Percent_male", "mean_age_dxd", "Female_mean_age_dxd", "Male_mean_age_dxd", "median_age_dxd", 
                            "Female_median_age_dxd", "Male_median_age_dxd")
    
  } else {
    stats_df <- data.frame(Female_count = 0, Male_count = 0, Total = 0, Percent_female = NA, Percent_male = NA, mean_age_dxd = NA, Female_mean_age_dxd = NA, 
                           Male_mean_age_dxd = NA, median_age_dxd = NA, Female_median_age_dxd = NA, Male_median_age_dxd = NA)
  }
  
  stats_df
}
