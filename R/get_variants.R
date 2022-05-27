#' A tidyUkBioBank function
#' Function output: dataframe contianing all of the variants on the chromosomes requested
#' 
#' @param chr_list list of all of the chromosomes you are interested in recieving the variants of
#' @param directory the directory containing the pgens, psams, and pvars 
#' @keywords get variants
#' @export
#' @examples
#' get_variants()

get_variants <- function(chr_list, directory){
  variants_df <- map(chr_list, get_chromosome_variants, directory) %>% reduce(rbind)
  variants_df
}