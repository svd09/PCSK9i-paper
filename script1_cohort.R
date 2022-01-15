#########################################################
# 2021-12-28 THIS SCRIPT HAS BEEN CHECKED FOR ACCURACY  #
#########################################################



########################################
##  COHORT - PCSK9I STUDY             ##
########################################
# 
# AUTHOR: SALIL V DEO MD 
# 
# EMAIL: svd14@case.edu
# 
# DATE: 2021-11-16
# 
# SCRIPT PURPOSE: TO CREATE COHORT OF PAD,CAD,CVD PATIENTS
# TO STUDY USE AND ADHERENCE TO PCSK9I
#   
# DATASETS THAT THE SCRIPT CREATES:
# ali_data1.csv - this dataaset now contains covariates 
# 1,139,607 patients
# 

# SET WORKING DIRECTORY ---

# IMPORT PACKAGE LIBRARIES NEEDED ---

cat("IMPORTING THESE PACKAGES... \n\n", sep = "")
packages <- c("tidyverse","survival","Hmisc","tidylog",
              "haven","lubridate")
n_packages <- length(packages)

# install missing packages 

# new.packages <- packages[!(packages %in% installed.packages())]

#if(length(new.packages)){
# print("You do  not have all the packages installed in the system") 
#  # install.packages(new.packages)
#}

# load all libraries needed

for(n in 1:n_packages){
  cat("Loading Library #", n, "of", n_packages, "...currently loading: ", packages[n], "\n", sep = "")
  lib_load <- paste("library(\"", packages[n], "\")", sep = "")
  eval(parse(text = lib_load))
}

# SETTING OPTIONS ---

cat("SETTING OPIONS... \n\n", sep = "")
options(scipen = 999)
options(encoding = "UTF-8")


# set wd

setwd('P:/ORD_Deo_202010005D/LIPID_STUDY/ALIROCUMAB/')

#--------------------
# START CODING HERE 
#--------------------

# GET THE base data 

df = read_sas('SAS_DATA/outpat_ali_basecohort.sas7bdat'); dim(df)

# see the data 

glimpse(df)

# convert some var and remove some 

names(df) = tolower(names(df))

df = df %>% select(-r) %>% rename(pri_diag = primarysecondary)

# now to get the secondary diagnoses and merge them as a wide format.

sec = read_sas("SAS_DATA/ali_sec_diag.sas7bdat")

names(sec) = tolower(names(sec))

# now to see if we have any duplicated scrssn 

sec = sec %>% arrange(scrssn)


sec2 = distinct(sec, scrssn, cond, .keep_all = T)

head(sec2)

sec2$flag = 1

sec3 = sec2 %>% select(-patientsid) %>% 
  pivot_wider(names_from = cond, values_from = flag)

glimpse(sec3)

summary(sec3)

sec3[is.na(sec3)]<- 0

# now to merge this with the main dataset.

df2 = left_join(df, sec3, by = "scrssn")

summary(df2)

df2[is.na(df2)]<- 0


# now to add bp readings.

bp = read_sas("SAS_DATA/ali_bp.sas7bdat")

names(bp) = tolower(names(bp))

summary(bp)

# get the most recent reading for each patient.

bp = bp %>% select(scrssn, systolic, diastolic, days) %>%
    arrange(scrssn, days)

head(bp,20)

# keep the first for each scrssn.

bp2 = distinct(bp, scrssn, .keep_all = T)

# now to merge them with the main dataset.

df3 = left_join(df2, bp2, by = "scrssn")

df3$systolic = cut_skew(df3$systolic)

df3$diastolic = cut_skew(df3$diastolic)

summary(df3)

# 79152/1715439 (4.6% missing bp)

# age

a = read_sas('SAS_DATA/ali_age.sas7bdat')

summary(a)

names(a) = tolower(names(a))

a$age = cut_skew(a$age)

a = a %>% select(scrssn, age)

df3 = left_join(df2, a, by = "scrssn")

summary(df3)

# now will need to add labs and then other co-morbidities to the table.
# labs - ldl, hba1c
# meds
# bmi, obesity, other vars needed to calculate high risk criteria.

# also need to get the regions, zip codes etc...

z = read_sas('SAS_DATA/ali_zip.sas7bdat')

glimpse(z)

names(z) = tolower(names(z))

z2 = z %>% select(scrssn, patientzip)

z3 = distinct(z2, scrssn, .keep_all = TRUE)

# now to merge with the main dataset.

df4 = left_join(df3, z3, by = "scrssn")

# now to save this dataset.

write_csv(df4,
  'datasets/ali_data1.csv')

# now from the zip code,can get the median income for that
# zip code.

####################
#CHECKED TILL HERE #
####################

