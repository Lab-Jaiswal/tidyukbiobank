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
    chromosome_pattern <- str_c(".*_", chromosome, "_.*.psam")
    psam_selected <- list.files(directory, pattern = chromosome_pattern, full.names = TRUE) 
    if (length(psam_selected) > 1) {
        print(str_c("ambiguous chromosome pattern detected:", chromosome_pattern))
        return(NA)
    } else {
        psam <- read_tsv(psam_selected)
        return(psam)
    }
}

