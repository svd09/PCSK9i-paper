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
# ali_data5.csv contains statin therapy information 
# ali_prior_recent contains statin fill information
# for LLT prior to index date. That coding has been done 
# in SAS.
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

# # now to get the data
# 

df  = read_csv("datasets/ali_data2.csv")

# 
# # now get the meds information
# 
# meds = read_sas("SAS_DATA/ali_llt_table.sas7bdat")
# 
# # now to see the medications list and obtain fills for 6 months before visit date...
# 
# glimpse(meds)
# 
# # this has filldate and visitdate
# # to keep only before visit.
# 
# meds$visitdate = as_date(meds$visitdate)
# 
# meds$FILLDATE = as_date(meds$FILLDATE)
# 
# 
# meds$days = (meds$visitdate %--% meds$FILLDATE)/ddays(1)
# 
# names(meds) = tolower(names(meds))
# 
# summary(meds$days)
# 
# meds$keep = with(meds, ifelse(filldate <= visitdate, 1, 0))
# 
# meds %>% count(keep)
# 
# # now to get the fills before the visitdate.
# 
# meds_p = meds %>% filter(keep == 1)
# 
# # save this dataset as prior 
# 
# write_csv(meds_p,
#           "datasets/meds_prior.csv")
# 
# 
# # to conserve the RAM, need to clear env and then again get this dataset
# 
# med_p = read_csv("datasets/meds_prior.csv")
# 
# 
# med_p = med_p %>% select(-days)
# 
# med_p$days = (med_p$filldate %--% med_p$visitdate)/ddays(1)
# 
# summary(med_p$days)
# 
# med_p$recent = with(med_p, ifelse(days >= 0 & days <= 180, 0, 1))
# 
# med_p %>% count(recent)
# 
# recent = med_p %>% filter(recent == 1)
# 
# # save 
# 
# write_csv(recent,
#           "datasets/recent_prior_llt.csv")
# 
# # now to get this dataset and then move forward
# 
# rec = recent %>% arrange(scrssn, days)
# 
# 
# 
# 
# # now to keep only those fills within 180 days and then to keep 
# # the most recent fill from that 
# 
# med_p2 = med_p %>% arrange(scrssn, days)
# 
# meds_p3 = distinct(med_p2, scrssn, .keep_all = TRUE)

# ALL THE ABOVE HAS BEEN DONE WITH SAS, AS THE DATA IS VERY LARGE
# NOW ALI_PRIOR_RECENT CONTAINS DATA WITHIN 180 DAYS FROM THE VISIT DATE.

# PROCEED FROM HERE 

m = read_sas("SAS_DATA/ali_prior_recent.sas7bdat")

glimpse(m)

# now need to get separate data using drug name and then classify as high / low / moderate intenstiy
# also identify those with ezetimibe and PCSK9i 
# atorvastatin, rosuvastatin,

library(stringr)

m %>% count(LocalDrugNameWithDose)

m 

# get atorvastatin 

m$atorva = 
  stringr::str_detect(m$LocalDrugNameWithDose, pattern = "ATORVASTATIN") %>%
  as.numeric()


m %>% count(atorva)

# keep only atorvastatin 

a = m %>% filter(atorva == 1)

atorvastatin = a %>% count(LocalDrugNameWithDose) # looks fine 

# now to get the dose 

a$dose = with(a, ifelse(
  str_detect(LocalDrugNameWithDose, pattern = "80"), 80,
  
  ifelse(str_detect(LocalDrugNameWithDose, pattern = "40"), 40, 
  
  ifelse(str_detect(LocalDrugNameWithDose, pattern = "20"), 20, 10))))
  
a$dose

# daily quantity...

glimpse(a)

summary(a$QtyNumeric)

summary(a$DaysSupply)

a$daily_tab = a$QtyNumeric/a$DaysSupply

summary(a$daily_tab)

# atorvastatin dosage 

a$daily_dosage = a$dose * a$daily_tab

summary(a$daily_dosage)

# classify as moderate & high intensity 

a$atorvastatin_high = with(a, ifelse(daily_dosage >= 40, 1, 0))

a$atorvastatin_mod = with(a, ifelse(daily_dosage < 40, 1, 0))

# now to only keep scrssn and then merge with the main dataset later.

a2 = a %>% select(scrssn, atorvastatin_high, atorvastatin_mod)

df2 = left_join(df, a2, by = "scrssn")

summary(df2)

# rosuvatatin now 


m$rosu = 
  stringr::str_detect(m$LocalDrugNameWithDose, pattern = "ROSUVASTATIN") %>%
  as.numeric()


m %>% count(rosu)

# keep only atorvastatin 

r = m %>% filter(rosu == 1)

rosu = r %>% count(LocalDrugNameWithDose) # looks fine 

# now to get the dose 

r$dose = with(r, ifelse(
  str_detect(LocalDrugNameWithDose, pattern = "40"), 40,
  
  ifelse(str_detect(LocalDrugNameWithDose, pattern = "20"), 20, 
         
         ifelse(str_detect(LocalDrugNameWithDose, pattern = "10"), 10, 5))))

r$dose

# daily quantity...

glimpse(r)

summary(r$QtyNumeric)

summary(r$DaysSupply)

r$daily_tab = r$QtyNumeric/r$DaysSupply

summary(r$daily_tab)

# rosuvastatin dosage 

r$daily_dosage = r$dose * r$daily_tab

summary(r$daily_dosage)

# classify as moderate & high intensity 

r$rosuvastatin_high = with(r, ifelse(daily_dosage >= 20, 1, 0))

r$rosuvastatin_mod = with(r, ifelse(daily_dosage < 20, 1, 0))


# now to only keep scrssn and then merge with the main dataset later.

r2 = r %>% select(scrssn, rosuvastatin_high, rosuvastatin_mod)

df3 = left_join(df2, r2, by = "scrssn")

df3 %>% count(rosuvastatin_mod)
        
        
df3 %>% count(rosuvastatin_high)


# SIMVASTATIN ...



m$sim = 
  stringr::str_detect(m$LocalDrugNameWithDose, pattern = "SIMVASTATIN") %>%
  as.numeric()


m %>% count(sim)

# keep only simvastatin

s = m %>% filter(sim == 1)

sim = s %>% count(LocalDrugNameWithDose) # looks fine 

# now to get the dose 

s$dose = with(s, ifelse(
  str_detect(LocalDrugNameWithDose, pattern = "80"), 80,
  
  ifelse(str_detect(LocalDrugNameWithDose, pattern = "40"), 40, 
         
         ifelse(str_detect(LocalDrugNameWithDose, pattern = "20"), 20, 10))))

s$dose

# daily quantity...

glimpse(s)

summary(s$QtyNumeric)

summary(s$DaysSupply)

s$daily_tab = s$QtyNumeric/s$DaysSupply

summary(s$daily_tab)

# simvastatin dosage 

s$daily_dosage = s$dose * s$daily_tab

summary(s$daily_dosage)

# classify as moderate & low intensity 

s$simvastatin_mod = with(s, ifelse(daily_dosage >= 10, 1, 0))

s$simvastatin_low = with(s, ifelse(daily_dosage < 10, 1, 0))


# now to only keep scrssn and then merge with the main dataset later.

s2 = s %>% select(scrssn, simvastatin_mod, simvastatin_low)

df4 = left_join(df3, s2, by = "scrssn")

# save this dataset ...

write_csv(df4,
          'datasets/ali_data4.csv')

# ATORVA, ROSUVA, SIMVASTATIN DONE
# NOW NEED TO DO EZETIMIBE, LOVASTATIN, PRAVASTATIN, PITAVASTATIN
# ALSO PCSK9I

# PRAVASTATIN 

# get the dataaset again 

df = read_csv('datasets/ali_data4.csv')




m$pra = 
  stringr::str_detect(m$LocalDrugNameWithDose, pattern = "PRAVASTATIN") %>%
  as.numeric()


m %>% count(pra)

# keep only simvastatin

p = m %>% filter(pra == 1)

prav = p %>% count(LocalDrugNameWithDose) # looks fine 

# now to get the dose 

p$dose = with(p, ifelse(
  str_detect(LocalDrugNameWithDose, pattern = "80"), 80,
  
  ifelse(str_detect(LocalDrugNameWithDose, pattern = "40"), 40, 
         
         ifelse(str_detect(LocalDrugNameWithDose, pattern = "20"), 20, 10))))

p$dose

# daily quantity...

glimpse(p)

summary(p$QtyNumeric)

summary(p$DaysSupply)

p$daily_tab = p$QtyNumeric/p$DaysSupply

summary(p$daily_tab)

# pravastatin dosage 

p$daily_dosage = p$dose * p$daily_tab

summary(p$daily_dosage)

# classify as moderate & low intensity 

p$pravastatin_mod = with(p, ifelse(daily_dosage > 20, 1, 0))

p$pravastatin_low = with(p, ifelse(pravastatin_mod == 0, 1, 0))


# now to only keep scrssn and then merge with the main dataset later.

p2 = p %>% select(scrssn, pravastatin_mod, pravastatin_low)

df2 = left_join(df, p2, by = "scrssn")

summary(df2)


# FLUVASTATIN 




m$flu = 
  stringr::str_detect(m$LocalDrugNameWithDose, pattern = "FLUVASTATIN") %>%
  as.numeric()


m %>% count(flu)

# keep only fluvastatin

f = m %>% filter(flu == 1)

fluv = f %>% count(LocalDrugNameWithDose) # looks fine 

# now to get the dose 

f$dose = with(f, ifelse(
  str_detect(LocalDrugNameWithDose, pattern = "80"), 80,
  
  ifelse(str_detect(LocalDrugNameWithDose, pattern = "40"), 40, 20)))
         
f$dose

# daily quantity...

glimpse(f)

summary(f$QtyNumeric)

summary(f$DaysSupply)

f$daily_tab = f$QtyNumeric/f$DaysSupply

summary(f$daily_tab)

# fluvastatin dosage 

f$daily_dosage = f$dose * f$daily_tab

summary(f$daily_dosage)

# classify as moderate & low intensity 

f$fluvastatin_mod = with(f, ifelse(daily_dosage >= 40, 1, 0))

f$fluvastatin_low = with(f, ifelse(fluvastatin_mod == 0, 1, 0))


# now to only keep scrssn and then merge with the main dataset later.

f2 = f %>% select(scrssn, fluvastatin_mod, fluvastatin_low)

df3 = left_join(df2, f2, by = "scrssn")

summary(df3)

# LOVASTATIN 


m$lov = 
  stringr::str_detect(m$LocalDrugNameWithDose, pattern = "LOVASTATIN") %>%
  as.numeric()


m %>% count(lov)

# keep only lovastatin

l = m %>% filter(lov == 1)

lova = l %>% count(LocalDrugNameWithDose) # looks fine 

# now to get the dose 

l$dose = with(l, ifelse(
  str_detect(LocalDrugNameWithDose, pattern = "40"), 40,
  
  ifelse(str_detect(LocalDrugNameWithDose, pattern = "20"), 20, 10))) 

l$dose

# daily quantity...

glimpse(l)

summary(l$QtyNumeric)

summary(l$DaysSupply)

l$daily_tab = l$QtyNumeric/l$DaysSupply

summary(l$daily_tab)

# lovastatin dosage 

l$daily_dosage = l$dose * l$daily_tab

summary(l$daily_dosage)

# classify as moderate & low intensity 

l$lovastatin_mod = with(l, ifelse(daily_dosage >= 40, 1, 0))

l$lovastatin_low = with(l, ifelse(lovastatin_mod == 0, 1, 0))


# now to only keep scrssn and then merge with the main dataset later.

l2 = l%>% select(scrssn, lovastatin_mod, lovastatin_low)

df4 = left_join(df3, l2, by = "scrssn")

summary(df4)


# NON STATIN LLT PRIOR TO VISIT DATE
# now ezetimibe 

write_csv(df4,
          'datasets/ali_data5.csv')

#########
#CHECKED#
#########