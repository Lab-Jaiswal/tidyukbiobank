#' A tidyUkBioBank function
#' Function output: dataframe containing eid column and columns with the genotype information for the variants of interest
#' 
#' @variants list of the variants of interest
#' @variants_df df containing all of the variants (created via get_directory_variants)
#' @param directory directory containing the psams, pgens, and pvars
#' @keywords get genotypes
#' @export
#' @examples
#' get_genotypes()

get_genotypes <- function(variants, variants_df, directory){
  variants_df_filter <- filter(variants_df, is_in(variant_id, variants))
  chrom_list <- pull(variants_df_filter, chromosome) %>% unique()
  pgen_list <- get_pgen_list(chrom_list, directory)
  
  genotypes <- group_by(variants_df_filter, chromosome) %>% 
    group_map(get_genotypes_from_pgen, pgen_list) %>% reduce(cbind)
  rownames(genotypes) <- psam$IID
  genotypes_df <- as_tibble(genotypes, rownames = "eid")
}
