#' A tidyUkBioBank function
#' Function output: dataframe containing all of the variants on all of the chromosomes in the directory
#' 
#' @param pattern pattern by which the chromsoomes are labeled ("c19" -> "c", "chr19" -> "chr")
#' @param directory directory containing the psams, pgens, and pvars
#' @keywords get directory variants
#' @export
#' @examples
#' get_directory_variants()

get_directory_variants <- function(pattern, directory){
  chr_list <- get_chromosome_list(pattern, directory)
  variants_df <- get_variants(chr_list, directory)
  variants_df
}