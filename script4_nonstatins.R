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
# ali_data6.csv contains all the information regarding 
# pcsk9i initiations, eze use prior to the index date.

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

df = read_csv("datasets/ali_data5.csv"); dim(df)

# [1] 1139607      36

eze = read_sas("SAS_DATA/ali_eze_fills.sas7bdat")

glimpse(eze)

# keep to only within 0 and 180 days from visit date.

eze$before = with(eze, ifelse(FILLDATE <= visitdate, 1, 0))

eze %>% count(before)

# keep before fill date 

eze2 = eze %>% filter(before == 1)

eze2$days = (eze2$FILLDATE %--% eze2$visitdate)/ddays(1)

summary(eze2$days)

# now to keep only within 0 and 180 days .

eze2$recent = with(eze2, ifelse((days >= 0 & days < 180),
                                1, 0))

eze2 %>% count(recent)

recent = eze2 %>% filter(recent == 1)

recent$eze = 1

rec = recent %>% select(scrssn, eze)

rec2 = distinct(rec, scrssn, .keep_all = T)

glimpse(rec2);dim(rec2)

# [1] 8597    2

length(unique(rec2$scrssn))

df2 = left_join(df, rec2, by = "scrssn")

glimpse(df2); dim(df2)

# [1] 1139607      37

glimpse(df2)

df2$eze[is.na(df2$eze)]<- 0

# now to count those patients that have had fills for 
# ezetimibe prior to their index date.

df2 %>% freq(eze)

# Frequencies  
# df2$eze  
# Type: Numeric  
# 
# Freq   % Valid   % Valid Cum.   % Total   % Total Cum.
# ----------- --------- --------- -------------- --------- --------------
#   0   1131010     99.25          99.25     99.25          99.25
#   1      8597      0.75         100.00      0.75         100.00
# <NA>         0                               0.00         100.00
# Total   1139607    100.00         100.00    100.00         100.00

########################################################################
# CHANGES TO THE CODE HERE                                             #
# PLAN TO KEEP OBSERVATION WINDOW BETWEEN 2016-01-01 AND 2020-04-01    #
# THAT IS GOING TO DETERMINE PATIENTS THAT WERE INITIATED WITH PCSK9I  #
########################################################################


pc = read_sas("SAS_DATA/ali_pcsk9i_fills.sas7bdat")

glimpse(pc)

length(unique(pc$scrssn)) # 6181 patients were initiated with PCSK9i
# we have to only identify those patients that were initiated in 
# the observation window 2016-01-01 to 2020-04-01

# AM NOT GOING TO BRING CODE FROM EARLIER SCRIPT, AM GOING TO CODE AGAIN
# -----------------------------------------------------------------------


names(pc) = tolower(names(pc))

# only keep those with fill dates between the observation window

pc2 = pc %>% 
  filter(filldate > '2016-01-01' & filldate < '2020-04-01') %>%
  select(scrssn, filldate, visitdate) %>%
  arrange(scrssn, filldate)
  
# now we need to only keep needed variables 

pc3 = pc2 %>% distinct(scrssn, .keep_all = T)

glimpse(pc3)

# now to ensure that we only have patients that were
# initiated after the index date
# also need to remove those patients that are initiated 
# prior to the index date

prior = pc3 %>% filter(filldate <= visitdate)

remove = prior$scrssn # 224 patients to be removed as they 
# had PCSK9i fills before the index date...

glimpse(df2)

`%notin%` = Negate(`%in%`)

df3 = df2 %>% filter(scrssn %notin% remove)

# filter: removed 224 rows (<1%), 1,139,383 rows remaining
# now the dataset contains patients that did not have PCSK9i 
# fills prior to the index date

length(unique(pc3$scrssn))

# remove those patients from pc3 that are in remove

pc4 = pc3 %>% filter(scrssn %notin% remove);dim(pc4)

# [1] 3274    3

# to now confirm that the dates and everything is correct.

summary(pc4$filldate)

# Min.      1st Qu.       Median         Mean 
# "2016-01-18" "2018-07-06" "2019-04-08" "2019-01-23" 
# 3rd Qu.         Max. 
# "2019-10-24" "2020-03-31"

# now to join this with the main dataset df3...

pc4$pcsk9i = 1

glimpse(pc4)

pc5 = pc4 %>% select(scrssn, pcsk9i,filldate)

df4 = left_join(df3, pc5, by = "scrssn")

# left_join: added 2 columns (pcsk9i, filldate)
# > rows only in x   1,136,109
# > rows only in y  (        0)
# > matched rows         3,274
# >                 ===========
#   > rows total       1,139,383

# contains all data regarding LLT ...

write_csv(df4,
          'datasets/ali_data6.csv')

#########
#CHECKED#
#########