#' A tidyUkBioBank function
#' Function output: list of pgens 
#' 
#' @param chr_list list of all of the chromosomes you are interested in recieving the variants of
#' @param directory the directory containing the pgens, psams, and pvars 
#' @keywords get pgen list
#' @export
#' @examples
#' get_pgen_list()

get_pgen_list <- function(chr_list, directory){
  pgen_list <- map(chr_list, make_pgen, directory)
  names(pgen_list) <- chr_list
  pgen_list
}