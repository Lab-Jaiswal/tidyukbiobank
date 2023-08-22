#' Make a get_first_date table
#' 
#' @param diagnosis_date_rows
#' @param diagnosis_date_group
#' @keywords get_first_date
#' @examples
#' @export
#' get_first_date()

get_first_date <- function(diagnosis_date_rows, diagnosis_date_group) {
  first_diag <- arrange(diagnosis_date_rows, date_of_diagnosis) %>% slice(1)
  first_diag_date <- select(first_diag, date_of_diagnosis)
  first_diag_date
}