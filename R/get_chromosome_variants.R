#' A tidyUkBioBank function
#' Function output: dataframe containing all of the variants on the specified chromosome
#' 
#' @param chromosome chromosome on which you are requesting variants
#' @param directory directory containing the psams, pgens, and pvars
#' @keywords get chromosome variants
#' @export
#' @examples
#' get_chromosome_variants()

get_chromosome_variants <- function(chromosome, directory) {
  print(paste("now reading in reads from chromosome:", chromosome))
  pvar_handle <- make_pvar(chromosome, directory)
  variant_number <- GetVariantCt(pvar_handle)
  variant_df <- map(1:variant_number, GetVariantId, pvar = pvar_handle) %>%
    unlist() %>% as_tibble_col(column_name = "variant_id")
  variant_df$chromosome <- chromosome
  variant_df$index <- 1:variant_number
  variant_df
}