#########################################################
# 2021-12-30 THIS SCRIPT HAS BEEN CHECKED FOR ACCURACY  #
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
# SCRIPT PURPOSE: TO IDENTIFY PATIENTS IN THIS COHORT ACCORDING TO 2018 AHA 
# CRITERIA AS VERY HIGH RISK FOR RECURRENT ASCVD.
# 
#   
# SCRIPT OTHER DETAILS:
# now has all the data verified. pcsk9i fills good , filldate 
# good, observation window for pcsk9i fills good.
# dataset - the_final.csv now contains all the variables 
# it also contains pcsk9i quarter fills for patients
# can use that for the interrupted time series methods.

# SET WORKING DIRECTORY ---

# IMPORT PACKAGE LIBRARIES NEEDED ---

cat("IMPORTING THESE PACKAGES... \n\n", sep = "")
packages <- c("tidyverse","survival","Hmisc","tidylog",
              "haven","lubridate","zipcodeR","pipeR","summarytools")


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


# get the data set again here...

df =  read_csv("datasets/data_withoutcome.csv")

# first need to limit to those that have baseline_LDL > 70 mg/dl

df %>>% descr(baseline_ldl)

# baseline LDL for the whole cohort

# N: 784206  
# 
# baseline_ldl
# ----------------- --------------
#   Mean          87.73
# Std.Dev          34.65
# Min          26.00
# Q1          63.00
# Median          82.00
# Q3         107.00
# Max         195.00
# MAD          31.13
# IQR          44.00
# CV           0.40
# Skewness           0.81
# SE.Skewness           0.00
# Kurtosis           0.49
# N.Valid      784206.00
# Pct.Valid         100.00

# now to limit to LDL > 70 mg/dl

df2 = df %>% filter(baseline_ldl >= 70); dim(df2)
# filter: removed 264,460 rows (34%), 519,566 rows remaining

# now to see the dist of condition in df2.

df2 %>>% freq(condition)

# now to see which patients had PCSK9i initiated and who were on it prior 

p = read_sas("SAS_DATA/ali_pcsk9i_fills.sas7bdat")

# ###########################################
# THIS IS THE CHANGED CODE TO GET INIT ONLY #
# FOR PATIENTS THAT HAVE FILLS BEFORE       #
# 2020-04-01 AS THAT IS THE END OF THE      #
# OBSERVATION WINDOW.                       #
# ###########################################

# FILL DATES FOR 3 MONTHS FROM THE LAST INDEX DATE - 
# defined as the observation window

names(p) = tolower(names(p))

glimpse(p)

summary(p$filldate)

# now to keep only those that have filldate between 2016-01-01
# and 2020-04-01

p = p %>% select(scrssn, filldate) %>% arrange(scrssn, filldate)

head(p,20)

# keep for only first filldate

p2 = distinct(p, scrssn, .keep_all = T)

# this will now have the first filldate ie. the initiation
# date.

p3 = p2 %>% filter(filldate > '2016-01-01' & 
                    filldate < '2020-04-01')


# filter: removed 2,694 rows (44%), 3,487 rows remaining

summary(p3$filldate)


df2 = df2 %>% 
  mutate(pcsk9i = ifelse(scrssn %in% p3$scrssn, 1, 0))

df2 %>% freq(pcsk9i)

# get the filldate for the patients that are initiated 
# with pcsk9i

df3 = left_join(df2, p3, by = "scrssn"); dim(df3)

df3 = df3 %>% select(-filldate.x) %>% rename(pcsk9i_filldate = filldate.y)

# now to get the quarter fills for the pcsk9i cohort.

summary(df3$pcsk9i_filldate)


df3 %>% freq(pcsk9i)

df3$pcsk9i_filldate = as_date(df3$pcsk9i_filldate)

df3$pcsk9i_fillq = quarter(df3$pcsk9i_filldate,type = "quarter", with_year = T)


t = df3 %>% freq(pcsk9i_fillq)

t = t %>% tbl_df()

t = t[1:17, ]

t

# so this is the final dataset...

# CONTAINS PAD, CAD, CVD WITH INDEX DATE BETWEEN 2016-01-01 AND 2019-12-31.

# ALL PATIENTS HAD PCSK9I INITIATION AFTER THE INDEX DATE.

# SO DF3 NOW CONTAINS THE WHOLE FINAL COHORT.




# need the following variables - 
# were on statins before, but not now
# CKD 
# stratify median income < 40,000 , 40,000 - 80,000, > 80,000
# sex
# race, ethnicity 
# divide LDL to categories also 70 - 100, 100 - 130 , > 130

df3 = df3 %>% mutate(
  ldl_cat = ifelse(baseline_ldl <= 100, 1, 
                   ifelse(baseline_ldl > 100 & baseline_ldl <= 130, 2, 3)),
  inc_group = ifelse(median_hh_inc < 40000, 1, 
                     ifelse(median_hh_inc >= 40000 & median_hh_inc < 80000, 2, 3)),
  statin_group = ifelse(statin == 1 & high == 1, 1,
                        ifelse((statin == 1 & high == 0),2,3)
))

# mutate: new variable 'ldl_cat' (double) with 3 unique values and 0% NA
# new variable 'inc_group' (double) with 4 unique values and 3% NA
# new variable 'statin_group' (character) with 2 unique values and 0% NA

# GET GENDER 

sex = read_sas("SAS_DATA/ali_gender.sas7bdat")

glimpse(sex)

names(sex) = tolower(names(sex))

sex = distinct(sex, scrssn, .keep_all = T) %>>% 
  rename(gender = mvi_sex)

# now to join with df3...

df4 = left_join(df3, sex, by = "scrssn")

# now to also add this to the table 

df4 %>>% freq(gender)

# reformat 

df4 = df4 %>% mutate(
  gender2 = ifelse(gender == "M", "M", "F")
)

df4 = df4 %>>% select(-gender)

# now to add that to the table 
# now to add ethnicity / race to the table ...

r = read_sas("SAS_DATA/ali_race.sas7bdat")

glimpse(r)

r %>% freq(Race)

r2 = r %>% filter(ScrSSN %in% df4$scrssn)

glimpse(r2)

r2 = r2 %>% mutate(
  race2 = ifelse((Race == "WHITE"|Race == "WHITE NOT OF HISP ORIG"), 1, 
                ifelse(Race == "BLACK OR AFRICAN AMERICAN", 2, 3)
))

names(r2) = tolower(names(r2))

r2 = r2 %>% arrange(scrssn)

r2 = distinct(r2, scrssn, .keep_all= T)

r2 = r2 %>% select(scrssn, race2)

df5 = left_join(df4, r2, by = "scrssn")

# now to also add that into the table 

df5$race2 = factor(df5$race2, levels = c(1,2,3),
                   labels = c("wh","aa","oth"))


df5$ldl_cat = factor(df5$ldl_cat, levels = c(1,2,3),
  labels = c("70-100","100-130",">130"),  ordered = T)

df5$inc_group = factor(df5$inc_group, levels = c(1,2,3),
                       labels = c("<40000","40000-80000",">80000"),
                       ordered = T)

df5$statin_group = factor(df5$statin_group,
                        levels = c(1,2,3),
                          labels = c("high","mod_low","none"),
                          ordered = T)


# define polyvascular disease 

df5 = df5 %>% mutate(polyvasc = ifelse(
  cad + pad + cvd > 1, 1, 0),
  visit_year = year(visitdate))

df5$polyvasc = factor(df5$polyvasc)

df5$visit_year = factor(df5$visit_year)


###########################################################
# SAVE THIS DATASET DF5 AS THE DATASET THAT CONTAINS      #
# ALL THE VARIABLES NEEDED. MAY NEED TO MAKE SOME NEW VAR #
# FOR THE REGRESSION ANALYSIS.                            #
###########################################################


write_csv(df5,
          "datasets/the_final.csv")

#########
#CHECKED#
#########

#############################################
# GOING TO MAKE A NEW SCRIPT FOR THE TABLES #
#############################################

vars = c("condition", 
         "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", "ckd",
         "PRIOR_PCI", "age",  "region", "median_hh_inc",  "baseline_ldl",
         "statin", "high", "moderate", "low",  "vhr",  "rural", "eze",
         "pcsk9i", "race2","gender2","ldl_cat","inc_group","statin_group",
          "polyvasc","visit_year")

catvars = c("condition", 
            "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", 
            "PRIOR_PCI", "region", "ckd",
            "statin", "high", "moderate", "low",  "vhr",  "rural",
            "eze","pcsk9i", "race2","gender2","ldl_cat","inc_group","statin_group",
             "ployvasc","visit_year")


t1 = tableone::CreateTableOne(vars = vars,addOverall = T,
                              factorVars = catvars,
                              data = df5,
                              strata = c("condition"))


t1



# table according to 

vars = c("condition", 
         "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", "ckd",
         "PRIOR_PCI", "age",  "region", "median_hh_inc",  "baseline_ldl",
         "statin", "high", "moderate", "low",  "vhr",  "rural", "on_eze",
         "new_eze","new_nst","pcsk9i", "race2","gender2","ldl_cat","inc_group",
         "statin_group", "polyvasc","visit_year")

catvars = c("condition", 
            "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", 
            "PRIOR_PCI", "region", "ckd",
            "statin", "high", "moderate", "low",  "vhr",  "rural",
            "on_eze","new_eze","new_nst","pcsk9i",
            "race2","gender2","ldl_cat","inc_group","statin_group","polyvasc","visit_year")


t2 = tableone::CreateTableOne(vars = vars,addOverall = T,
                              factorVars = catvars,
                              data = df5,
                              strata = c("pcsk9i"))


t2




# df3 now contains the cohort from 2016 - 2019.
# create table according to type of primary disease and overall 

vars = c("condition", 
         "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", "ckd",
         "PRIOR_PCI", "age",  "region", "median_hh_inc",  "baseline_ldl",
         "statin", "high", "moderate", "low",  "vhr",  "rural", "on_eze",
         "new_eze","new_nst","pcsk9i")

catvars = c("condition", 
            "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", 
            "PRIOR_PCI", "region", "ckd",
            "statin", "high", "moderate", "low",  "vhr",  "rural",
            "on_eze","new_eze","new_nst","pcsk9i")


t1 = tableone::CreateTableOne(vars = vars,addOverall = T,
                              factorVars = catvars,
                              data = df2,
                              strata = c("condition"))

