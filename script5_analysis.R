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
# ali_data_ldl.csv is the dataset created.
# it contains patients that all have LDL C levels now 
# 784095 patients 

# SET WORKING DIRECTORY ---

# IMPORT PACKAGE LIBRARIES NEEDED ---

cat("IMPORTING THESE PACKAGES... \n\n", sep = "")
packages <- c("tidyverse","survival","Hmisc","tidylog",
              "haven","lubridate","zipcodeR","janitor")


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

df = read_csv("datasets/ali_data6.csv"); dim(df)

# [1] 1139383      39

# we have patients that may not be on statins at all.
# so those that have NA for all statins are not on statin therapy.

df$statin = with(df, ifelse(
  (atorvastatin_high == 1|atorvastatin_mod == 1|
     rosuvastatin_high == 1|rosuvastatin_mod== 1|
     simvastatin_mod == 1|simvastatin_low == 1|
     pravastatin_mod == 1|pravastatin_low == 1|
     fluvastatin_mod == 1|fluvastatin_low|
     lovastatin_mod|lovastatin_low), 1, 0
))

df %>% count(statin)

df$statin[is.na(df$statin)]<- 0

# get the data cleaned and formatted to create table 1.

glimpse(df)

change_0 = c("atorvastatin_high", 
             "atorvastatin_mod", "rosuvastatin_high", "rosuvastatin_mod", 
             "simvastatin_mod", "simvastatin_low", "pravastatin_mod", "pravastatin_low", 
             "fluvastatin_mod", "fluvastatin_low", "lovastatin_mod", "lovastatin_low", 
             "eze", "pcsk9i")


df2 = df %>% mutate_at(change_0, ~replace(., is.na(.), 0))

summary(df2)

# use of high intensity statins 

df2$high = with(df2, ifelse(
  ((rosuvastatin_high == 1|atorvastatin_high == 1)& statin == 1), 1, 0
))

df2 %>% count(high)

# moderate intensity statins 

df2$moderate = with(df2, ifelse(
  ((atorvastatin_mod == 1|rosuvastatin_mod == 1|simvastatin_mod == 1|
     pravastatin_mod == 1|fluvastatin_mod == 1|lovastatin_mod == 1) & statin == 1), 1, 0
))

length(unique(df2$scrssn))

df3 = df2 %>% arrange(scrssn)

df4 = distinct(df3, scrssn, .keep_all = T)

df4$low = with(df4, ifelse(
  (high == 0 & moderate  == 0 & statin == 1), 1, 0
))

df4 %>% count(low)

# now to save this dataset as the correct one further...

write_csv(df4,
          'datasets/ali_data7.csv')

df4 %>% tabyl(condition, pcsk9i) %>% adorn_percentages()

# use of ezetimibe 

df4 %>% tabyl(condition, eze) %>% adorn_percentages()

# income groups 

df4$income_gp = with(df4, ifelse(
  median_hh_inc > 80000, 1, 
  ifelse(median_hh_inc <= 80000 & median_hh_inc > 40000, 2, 3)
))

# for the paper, LDL is very important, so need to limit the 
# cohort to those that have LDL values at the time of visit.

df5 = df4 %>% drop_na(baseline_ldl)

dim(df5)

# [1] 784095     44

# now df5 contains patients with LDL values prior to visit date.

write_csv(df5,
          "datasets/ali_data_ldl.csv")


# from this cohort df5, we need to identify those patients
# that are part of the very high risk group.
# we can use the SMART score as that is better than the
# 2018 AHA criteria to determine VHR.

# am going to use the criteria to identify the 2018 AHA criteria...


#########
#CHECKED#
#########
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# # create table 1 ... 
# 
# 
# 
# vars = c( "condition", 
#           "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", 
#          "PRIOR_PCI", "age",  "region", "median_hh_inc", "cad", 
#          "pad", "cvd", "baseline_ldl",  
#          "eze", "pcsk9i", "statin", "high", "moderate", "low",
#          "income_gp")
# 
# 
# 
# factors = c( "condition", 
#              "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", 
#              "PRIOR_PCI",   "region",  "cad", 
#              "pad", "cvd",  
#              "eze", "pcsk9i", "statin", "high", "moderate", "low",
#              "income_gp")
# 
# 
# library(tableone)
# 
# 
# 
# t = tableone::CreateTableOne(vars = vars,
#                              factorVars = factors,
#                              strata = c("condition"),
#                              data = df4)
# 
# 
# t


