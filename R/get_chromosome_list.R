#' A tidyUkBioBank function
#' Function output: list with all of the chromosomes contianing full pgen/psam/pvar sets in the directory
#' 
#' @param pattern the pattern by which the chromosome of the file is indicated (ex: if the files have the pattern "c1.pgen", "c2.psam", etc. then the pattern is "c")
#' @param directory the directory containing the pgens, psams, and pvars 
#' @keywords get chromosome list
#' @export
#' @examples
#' get_chromosome_list()

get_chromosome_list <- function(pattern, directory){
  sequnce <- seq(1:22) %>% append(c("X", "Y"))
  chr_list<- str_c(pattern, sequnce)
  chromosome_expr <- str_c("_", chr_list, "_")
  pgen_list <- intersect(list.files(directory, pattern = paste0(chromosome_expr, collapse="|")), list.files(directory, pattern = ".pgen")) %>%
    str_replace_all(".pgen", "")
  pvar_list <- intersect(list.files(directory, pattern = paste0(chromosome_expr, collapse="|")), list.files(directory, pattern = ".pvar")) %>%
    str_replace_all(".pvar", "")
  chr_intersect <- intersect(pgen_list, pvar_list)
  
  chr_matches <- map(chromosome_expr, str_subset, string = chr_intersect) %>% map_int(length)
  
  list_of_chromosomes <- chromosome_expr[chr_matches > 0]
  chr_names <- sequnce[chr_matches > 0]
  
  print("I have detected the following chromosomes in your data:")
  print(chr_names)
  
  chr_list <- gsub("_", "", list_of_chromosomes)
}
