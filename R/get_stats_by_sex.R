#' A tidyUkBioBank function
#' Function output: counts, mean, and median values for the genetic sex of your choice (Male or Female)
#' 
#' @param sex sex of interest, can be Male or Female
#' @param dataframe the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords stats by sex
#' @export
#' @examples
#' get_stats_by_sex()

get_stats_by_sex <- function(sex, dataframe){
  if (str_detect(sex, "^M") | str_detect(sex, "^m")) {
    sex <- "Male"
  } else if (str_detect(sex, "^F") | str_detect(sex, "^f")) {
    sex <- "Female"
  } 
  
  if (sex == "Male" | sex == "Female") {
    filtered_df <- filter(dataframe, genetic_sex_f22001_0_0 == sex)
  } else {
    filtered_df <- dataframe
  }
  
  age_df <- filtered_df %>% 
    select(Age_at_first_DX_dx) %>%
    filter(!is.na(Age_at_first_DX_dx)) 
  
  mean_age_combined <- mean(age_df$Age_at_first_DX_dx)
  median_age_combined <- median(age_df$Age_at_first_DX_dx)
  total <- filtered_df %>% select(eid) %>% unique() %>% nrow()
  age_values <- c(mean_age_combined, median_age_combined, total)
  age_values
  
}
