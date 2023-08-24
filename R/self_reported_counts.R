#' A tidyUkBioBank function
#' Function output: counts data of all individuals who reported the disease of interest (M/F breakdown, etc.)
#' 
#' @param disease diagnosis of interest (string or code)
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @param cancer
#' @keywords self reported counts
#' @export
#' @examples
#' self_reported_counts()

self_reported_counts <- function(disease, dataframe, cancer) {
   coding <- parse_get_SR_table_input(disease, cancer) 

   SR_eids <- get_self_reported_eids(disease, dataframe, cancer)
   SR_sex <- filter(dataframe, is_in(eid, SR_eids)) %>% select(genetic_sex_f22001_0_0, eid)

  if (nrow(SR_sex) > 0){
    SR_Female_count <- filter(SR_sex, genetic_sex_f22001_0_0 == 0) %>% select(eid) %>% unique() %>% nrow()
    SR_Male_count <- filter(SR_sex, genetic_sex_f22001_0_0 == 1) %>% select(eid) %>% unique() %>% nrow()
    SR_Total <- SR_Female_count + SR_Male_count
    SR_Percent_female <- SR_Female_count/SR_Total
    SR_Percent_male <- SR_Male_count/SR_Total

    age <- sr_age(disease, "DX", dataframe, cancer)
    age_sex_combined <- left_join(SR_sex, age) %>% na.omit()

    sexes <- c("Male", "Female", "combined")
    age_stats <- map(sexes, get_stats_by_sex, age_sex_combined) %>% flatten %>% unlist()

    #stopped here
    Percent_female <- as.numeric(age_stats[6])/as.numeric(age_stats[9])
    Percent_male <- as.numeric(age_stats[3])/as.numeric(age_stats[9])
    sr_df <- data.frame(age_stats[6], age_stats[3], age_stats[9], Percent_female, Percent_male, age_stats[7], age_stats[4], age_stats[1], age_stats[8], age_stats[5], age_stats[2])
    colnames(sr_df) <- c("Female_count", "Male_count", "Total", "Percent_female", "Percent_male", "mean_age_dxd", "Female_mean_age_dxd", "Male_mean_age_dxd", "median_age_dxd", 
                            "Female_median_age_dxd", "Male_median_age_dxd")
  
  } else {
    sr_df <- data.frame(Female_count = 0, Male_count = 0, Total = 0, Percent_female = NA, Percent_male = NA, mean_age_dxd = NA, Female_mean_age_dxd = NA, 
                           Male_mean_age_dxd = NA, median_age_dxd = NA, Female_median_age_dxd = NA, Male_median_age_dxd = NA)
  }
    sr_df
}
