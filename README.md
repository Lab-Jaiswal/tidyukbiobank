# tidyUkBioBank

tidyUkBioBank is an R-based package that you to easily extract, subset, and parse diagnositic and genetic data from the UK Biobank dataset.

To avoid repetitive calls for standard diagnostic and genetic variables, we created functions to output meaningful columns, such as:

- History of a diagnosis
- Age and date at which diagoses were made
- Current patient age based on todays date
- Genotype data

This package also provides functions you can use to gain a broad understanding of the prevalence of disorders of interest, such as:

- The total number of participants with a diagnosis
- The proportion of males and females afflicated with a certain diagnosis
- The median and mean age patients were first diagnosed

Finally, this package allows you to define a diagnosis based on multiple sources of your choosing, such as:

- icd10 code(s)
- icd9 code(s)
- cause of death reports
- self reports

## Installation
Install latest development version: `devtools::install_github("Lab-Jasiwal/tidyUkBioBank", dependencies = TRUE)`

## Prerequisites 
### Obtaining Phenotypic Data form the UKBioBank

 1. Make a UKB fileset                                                                                                                                   
        a. Download and decrypt your data from the Uk BioBank                                                                                           
        b. Run the following commands to create a fileset:
        
         ukb_unpack ukbxxxx.enc key
         ukb_conv ukbxxxx.enc_ukb r
         ukb_conv ukbxxxx.enc_ukb docs
 2. Make a UKB dataset                                                                                                                                  
        a.  Install the ukbtools package:
        
        devtools::install_github("kenhanscombe/ukbtools", dependencies = TRUE)                                                                        
        
b.  Run [ukbtools](https://kenhanscombe.github.io/ukbtools/articles/explore-ukb-data.html) ukb_df command, which requires the stem of your fileset and its path:   
        
        ukb_data <- ukb_df("ukbxxxx", path = "/full/path/to/my/data")

The ukb_df() function returns a dataframe with usable column names. This command may take several minutes and, depending on the amount of memory available, you may need to split the ukbxxxx.tab dataframe into several peices. I used the following commands: 


In bash:

        cat ukbxxxxx.tab | parallel -j 16 --header : --pipe -N10000 'cat >subset_{#}.tab' 
        for x in ./*.tab; do
          mkdir "${x%.*}" && mv "$x" "${x%.*}"
        done
        for i in ./* # iterate over all files in current dir
          do
           if [ -d "$i" ] # if it's a directory
            then
              cp ukbxxxx.r "$i" # copy ukbxxxx.r into it
              cp ukbxxxx.log "$i" # copy ukbxxxx.log into it
              cp ukbxxxx.html "$i" # copy ukbxxxx.html into it
           fi
         done
         dirname $(ls */*.tab) | xargs -I % bash -c "mv %/%.tab %/ukbxxxx.tab"

In R:

        library(ukbtools)
        library(magrittr)
        library(tidyverse) 
        subset_dir <- "file/path/with/subsetted/data"
        subset_list <- list.files(subset_dir, pattern="subset_*") %>% sort
        subset_list_path <- str_c(subset_dir, subset_list, sep="/")

        read_df <- function(subsets_dir) {
               ukb_object <- ukb_df("ukbxxxx", path=subsets_dir)
               tibble(ukb_object) 
        }

        ukb_full <- map(subset_list_path, read_df) %>% bind_rows()
        write_rds(ukb_full, "ukb_phen_data_final_todays_date.rds")
        
§ Full details on creating a UKB fileset: https://biobank.ctsu.ox.ac.uk/~bbdatan/Accessing_UKB_data_v2.3.pdf   
§ Full details on making a UKB dataset: https://github.com/kenhanscombe/ukbtools      
§ Full details on downloading UKB genetic data: https://biobank.ndph.ox.ac.uk/ukb/ukb/docs/ukbgene_instruct.html   
§ Full details on parallel_fetch.sh script: https://github.com/neurodatascience/ukbm                                                                     
§ Additional thread on splitting the tab data: https://github.com/kenhanscombe/ukbtools/issues/1

## Functions

### Common Arguments

Several of the functions below contain common arguments. They are:

1. `icd_list`: A list of the icd10 codes you are interested in examining. 
* Ex: if you are interested in examining individuals diagnosed with Depression, you may create the following list of ICD10 codes:                     
`icd_Depression <- c(F33.4, F32.8, F33, F33.1, F33.8, F32, F33.0, F33.9)`  
2. `dataframe`: The phenotype dataframe created using the ukb_df() function
3. `disease_name`: The disease name you wish to call the cluster of icd codes by
* Ex: "Depression"

### dx_age(), dx_date(), dx_hx()

Arguments:
1. `icd_list`, `dataframe`, `disease_name`

Output:
All three functions contain similar outputs: tibbles with two columns, one of which is 'eid'. The second column is dependent on the function used: 
* dx_age() outputs a column named `"Age_at_first_[disease_name]_dx"`, which contains the age at which the indivudal was first diagnosed with the disease(s) of interest. If an individual has not been diagnosed with the disease(s) of interest, the value in this column is NA.
* dx_date() outputs a column named `"Date_of_first_[disease_name]_dx"`, which contains with the date at which the indivudal was first diagnosed with the disease(s) of interest. If an individual has not been diagnosed with the disease(s) of interest, the value in this column is NA.
* dx_hx outputs a column named `"Hx_of_[disease_name]"` containing 1's and 0's. 1's indicate that the individual was diagnosed with the disease(s) of interest, while 0's indicate that the indivudal was not. 

The resulting tibble can then be added to the original dataframe (or a subsetted dataframe of your choice) using dplyr's left_join (on = eid).

### ukb_info()

Arguments:                                                                                                                                           
1-3. `icd_list`, `dataframe`, `disease_name`  
4. `requested`: A string containing the columns requested.                                                                                              
* Strings containing "date" will call the dx_date() function; "age", the dx_age() function; and, "hx", the  dx_hx() function.    
5. `combined`: If `TRUE`, this indicated that you would like to recieve the requested column(s) joined to the entire phenotype dataframe (here ukb_data). If `FALSE`, this indicates that you would like to only recieve the tibbles outputted by the function indicated in `requested`


### date_of_birth()

Arguments: 
1. `dataframe`

Output:
A tibble containing two columns: eid, and DOB, which contains the subject's date of birth in yyyy-mm-dd format. If desired, you can then append the DOB column to the original dataframe (or a subsetted dataframe of your choice) using dplyr's left_join (on = eid).

### individuals_with_disease(), individuals_without_disease()

Arguments:
1. `icd_list`: A list of the icd10 codes you are interested in examining. 
2. `dataframe`: The phenotype dataframe created using the ukb_df function

Output: 
individuals_with_disease(): A list of all individuals (identified by eid) that have been diagnosed with the icd_code(s) of interest. 
individuals_without_disease(): A list of all individuals (identified by eid) that have not been diagnosed with the icd_code(s) of interest. 

## Citations
Hanscombe KB, Coleman J, Traylor M, Lewis CM (e-print 158113). “ukbtools: An R package to manage and query UK Biobank data.” _bioRxiv_. <URL: https://doi.org/10.1101/158113>.
