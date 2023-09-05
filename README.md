# tidyUkBioBank

tidyUkBioBank is an R-based package that you to easily extract, subset, and parse diagnositic (icd, cancer related, self reported dxs, etc.) from the UK Biobank dataset.

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
  - fields : diagnoses_icd10_f41270 _0_0 - 0_222, diagnoses_main_icd10_f41202_0_0 - 0_74, diagnoses_secondary_icd10_f41204_0_0 - 0_183,  type_of_cancer_icd10_f40006_0_0 - 0_16, date_of_first_inpatient_diagnosis_icd10_f41280_0_0 - 0_222, date_of_cancer_diagnosis_f40005_0_0 - 0_16 
- icd9 code(s)
  - fields: diagnoses_icd9_f41271_0_0 - 0_46, diagnoses_secondary_icd9_f41205_0_0 - 0_29, diagnoses_main_icd9_f41203_0_0 - 0_27, type_of_cancer_icd9_f40013_0_0 - 0_14, date_of_first_inpatient_diagnosis_icd9_f41281_0_0 - 0_46, date_of_cancer_diagnosis_f40005_0_0 - 0_16 
- cause of death reports
  - description_cause_of_death_f40010_0_0, contributory_secondary_ca_f40002_0_0 - 1_14, underlying_primary_cause_of_death_f40001_0_0, date_of_death_f40000_0_0 - 1_0
- self reports
  - cancer_code_selfreported_f20001_0_0 - 3_5, noncancer_illness_code_selfreported_f20002_0_0 - 3_33, interpolated_age_of_participant_when_cancer_fist_diagnosed_f2007_0_0 - 3_33, interpolated_year_when_cancer_first_diagnosed_f20006_0_0 - 3_5, interpolated_age_of_participant_when_noncancer_illness_first_diagnosed_f20009_0_0 - 3_33, interpolated_year_when_noncancer_illness_first_diagnosed_f20008_0_0 - 3_5
- date of birth
  - fields: year_of_birth_f34_0_0, month_of_birth_f52_0_0

## Installation and Data Download
### Vim
 1. Start an srun session
 2. Srun -c 16 –mem 128G -t 8:00:00 -A default -p interactive –pty zsh
 3. Install and call package
    - `devtools::install_github("Lab-Jasiwal/tidyUkBioBank", dependencies = TRUE)`
    - library(tidyukbiobank)
 4. Call needed dependencies
    - library(tidyverse)
    - library(lubridate)
    - library(magrittr)
 5. Download data
    - ukb <- /path/to/data/ukb_phenotype_data_only_relevant_to_tidyukbiobank_Jul_20.rds

### ondemand R Studio
 1. Go to R Studio Server
    - https://ondemand.scg.stanford.edu/pun/sys/dashboard/batch_connect/sys/rstudio/session_contexts/new
 2. Select options:
    - R Version: 4.2.2
    - Number of cores: 16
    - Amount of memory: 258
 3. Click "Launch"
 4. Call needed dependencies
    - library(tidyukbiobank)
    - library(tidyverse)
    - library(lubridate)
    - library(magrittr)
 5. Download data
    - ukb <- /path/to/data/ukb_phenotype_data_only_relevant_to_tidyukbiobank_Jul_20.rds

## Prerequisites 
### Obtaining Phenotypic Data from the UKBioBank

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
There are 29 functions in tidyukbiobank. Luckily, you only need to worry about 5 of them:
* parse_get_SR_table_input
* diagnoses_table
* diagnoses_counts
* diagnoses_ages
* diagnoses_dates
  
### parse_get_SR_table
#### Arguments
*disease:* 
* string either from coding6/ coding3 OR 
* string with a description of the disease of interest
  
*cancer:* whether the diagnoses is a cancer diagnosis
* TRUE or FALSE
* For cancer diagnoses, put just the body part and then TRUE. For example: parse_get_SR_table_input("breast", TRUE)

#### Example

### diagnoses_table(), diagnoses_counts(), diagnoses_ages(), diagnoses_dates()
#### Arguments
*Mandatory:* 
* dataframe: name of the dataframe with the ukbb data
  
*Optional:*
* icd_code_list: a list of icds the patient was dxd with during an inpt hospital stay
* cause_of_death: a list of icds associated with the patient’s primary or secondary cause of death
* self_reported: a code or string corresponding to either coding6 or codign3

#### Example

#### diagnoses_table
Output: A table containing eids and columns filled with 1’s and 0’s for if the eid has a record of the icd, cod, or self diagnosed code.  

Example:

#### diagnoses_counts
Outputs: A counts table containing the count (female, male, and combined), % female, % male, mean and median age dxd (for females, males, and combined) for all codes provided

Example

#### diagnoses_dates
Output: A table containing the eids and date dxd for each icd/ cause of death/ self reported code given. If any are eids missing that show a 1 in using diagnoses_table, it is because no date of diagnoses was provided. 

Example:

#### diagnoses_ages
Output: A table containing the eids and age dxd for each icd/ cause of death/ self reported code given.  If any are eids missing that show a 1 in using diagnoses_table, it is because no date of diagnoses was provided. 

Example:
![Example](https://github.com/Lab-Jaiswal/tidyukbiobank/blob/main/images/call_diag_ages.png)


## Citations
Hanscombe KB, Coleman J, Traylor M, Lewis CM (e-print 158113). “ukbtools: An R package to manage and query UK Biobank data.” _bioRxiv_. <URL: https://doi.org/10.1101/158113>.
