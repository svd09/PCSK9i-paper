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
# SCRIPT OTHER DETAILS:
# ali_data2.csv - this dataaset now contains covariates 
# 1,139,607 patients
# dataset now contains ldl values, with many missing ldl values...

# SET WORKING DIRECTORY ---

# IMPORT PACKAGE LIBRARIES NEEDED ---

cat("IMPORTING THESE PACKAGES... \n\n", sep = "")
packages <- c("tidyverse","survival","Hmisc","tidylog",
              "haven","lubridate","zipcodeR")


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

df = read_csv('datasets/ali_data1.csv')

# now to use the zipcode library...



# using the zipcodeR library to get the zipcode to state
# and US regions 


search_state("OH")$zipcode


# create a small function to do that...


library(readxl)

reg = read_excel('P:\\ORD_Deo_202010005D\\SVD\\vasc_trends\\vhr_pci\\r_datasets\\us_census_state_region.xlsx')

glimpse(reg)

reg = reg %>% rename(state_code = `State Code`)

# get the list of states for each region

reg %>% count(Region)


# Region        n
# <chr>     <int>
#   1 Midwest      12
# 2 Northeast     9
# 3 South        17
# 4 West         13

midwest_st_code = (reg %>% filter(Region == "Midwest"))$state_code 

northeast_st_code = (reg %>% filter(Region == "Northeast"))$state_code

south_st_code = (reg %>% filter(Region == "South"))$state_code

west_st_code = (reg %>% filter(Region == "West"))$state_code


midwest = tibble(region = "midwest", zipcode = search_state(midwest_st_code)$zipcode,
                 median_hh_inc = search_state(midwest_st_code)$median_household_income)

northeast = tibble(region = "northeast", zipcode = search_state(northeast_st_code)$zipcode,
                   median_hh_inc = search_state(northeast_st_code)$median_household_income)

south = tibble(region = "south", zipcode = search_state(south_st_code)$zipcode,
               median_hh_inc = search_state(south_st_code)$median_household_income)

west = tibble(region = "west", zipcode = search_state(west_st_code)$zipcode,
              median_hh_inc = search_state(west_st_code)$median_household_income)

bigtibble = rbind(midwest, northeast, south, west)

# SAVE THIS FOR FURTHER USE...

write_csv(bigtibble, "datasets/region_zipcode_income.csv")

# big tibble contains zipcode, medianincome and region.
# combine with df to get the information into the df

df2 = df %>% rename(zipcode = patientzip)

df3 = left_join(df2, bigtibble, by = "zipcode") 

glimpse(df3)

df3 %>% count(region)

summary(df3$median_hh_inc)

# df3 contains region, median household income ...

glimpse(df3)

length(unique(df3$scrssn))

length(df3$scrssn)

# this data set contains the baseline data.
# patients may have more than 1 of CAD/PAD/CVD
# get this information into the data set.


diag = read_sas('SAS_DATA/ali_add_diag.sas7bdat')

glimpse(diag)

# split the data to three tibbles

names(diag) = tolower(names(diag))

cad = diag %>% filter(add_diag == "CAD")

pad = diag %>% filter(add_diag == "PAD")

cvd = diag %>% filter(add_diag == "CVD")

# now to add these into df3.

glimpse(df3)

df3$cad = with(df3, ifelse(scrssn %in% cad$scrssn, 1, 0))

df3$pad = with(df3, ifelse(scrssn %in% pad$scrssn, 1, 0))

df3$cvd = with(df3, ifelse(scrssn %in% cvd$scrssn, 1, 0))

summary(df3)


glimpse(df3)

df3 = df3 %>% select(-patientsid.y) %>%
  rename(patientsid = patientsid.x)


# get the height and weight, calculate BMI 

h = read_sas('SAS_DATA/ali_height_table.sas7bdat')

glimpse(h)

names(h) = tolower(names(h))

h$height = cut_skew(h$height)

# merge now 

h = distinct(h, scrssn, .keep_all = T)

df4 = left_join(df3, h, by = "scrssn")

# get weight 

w = read_sas('SAS_DATA/ali_weight_table.sas7bdat')

names(w) = tolower(names(w))

w = w %>% rename(weight = height)

w = distinct(w, scrssn, .keep_all = T)

df5 = left_join(df4, w, by = "scrssn")

summary(df5)

# a lot of missing height and weight information
# am not going to obtain BMI and obesity for now...

# get the ldl values...

ldl = read_sas('SAS_DATA/ali_ldl_table.sas7bdat')

names(ldl) = tolower(names(ldl))

glimpse(ldl)

summary(ldl$ldl_days)

# now to only limit to when ldl_days between 0 and 180

ldl$keep = with(ldl, ifelse(ldl_days >= 0 & ldl_days <= 365, 1, 0))

ldl %>% count(keep)

ldl2 = ldl %>% filter(keep == 1)

# now need to only obtain ldl values prior to visit

ldl3 = ldl2 %>% select(scrssn, labchemresultnumericvalue,
                      ldl_days) %>% 
  rename(baseline_ldl = labchemresultnumericvalue) %>%
  arrange(scrssn, ldl_days)

# need to get the ldl most recent to the visitdate.

head(ldl3, 20)

ldl4 = distinct(ldl3, scrssn, .keep_all = T)

head(ldl4, 20)

# now to merge this with the main dataset.

glimpse(ldl4)

ldl5 = ldl4 %>% select(scrssn, baseline_ldl)

df6 = left_join(df5, ldl5, by = "scrssn")

summary(df6)

df6$baseline_ldl = cut_skew(df6$baseline_ldl)

summary(df6$baseline_ldl)

# now see that data till now...

glimpse(df6)

write_csv(df6,
        "datasets/ali_data2.csv")

# now done till here ...
## am going to get more data later
### now focus on medications + LLT
# AHA high risk criteria 

#########
#CHECKED#   
#########