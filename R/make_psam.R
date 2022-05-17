#' A tools4ukbb function
#' Function output: a tsv with psam details from the chromosome of your choosing
#' 
#' @param chromosome which chromosome you are selecting and how it is labeled (eg: for chromosome 2 of sample3_chr2.psam, chromsome = "chr2" OR for s1_c2.psam, chromosome = "c2")
#' @param directory the directory with your psam files 
#' @keywords psam
#' @export
#' @examples
#' make_psam()

make_psam <- function(chromosome, directory){
  directory_list <- list.files(directory, pattern = ".psam", full.names = TRUE) 
  psam_selected <- directory_list[1]
  psam <- read_tsv(psam_selected)
}

