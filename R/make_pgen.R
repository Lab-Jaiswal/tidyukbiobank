#' A tools4ukbb function
#' Function output: a pgen object from the chromosome of your choosing
#' 
#' @param chromosome which chromosome you are selecting and how it is labeled (eg: for chromosome 2 of sample3_chr2.pgen, chromsome = "chr2" OR for s1_c2.pgen, chromosome = "c2")
#' @param directory the directory with your pgen files 
#' @keywords pgen
#' @export
#' @examples
#' make_pgen()

make_pgen <- function(chromosome, directory){
  pvar <- make_pvar(chromosome, directory)
  chromosome_expr <- str_c("_", chromosome, "_")
  directory_list <- list.files(directory, pattern = ".pgen", full.names = TRUE) 
  pgen_file_name <- str_subset(directory_list, chromosome_expr)
  pgen <- NewPgen(pgen_file_name, pvar=pvar)
}
