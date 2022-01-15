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
# data_withoutcome.csv is the dataset created .
# it contains all the information regarding patients.
# 

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

df = read_csv( "datasets/ali_data_ldl.csv")

# see what we have 

glimpse(df)

# we have cvd, pad, prior mi, 
# do not have recent ACS - defined as 


# IDENTIFY MAJOR CRITERIA 



# high risk criteria
# major event - recent acs, history MI, history ischemic stroke, PAD 

# high risk conditions 
# familial HCL 
# CABG / PCI prior 
# DM 
# HTN 
# CKD 
# Current smoker
# elevated LDL-C > 100
# CHF 

# ACTIVE SMOKING 

sm = read_sas('SAS_DATA/ali_smoke.sas7bdat')

sm2 = distinct(sm, scrssn, .keep_all = T) %>% 
  select(scrssn)

df$active_smoke = with(df, ifelse(
  scrssn %in% sm2$scrssn, 0,1
))

library(janitor)

df %>% tabyl(active_smoke)




# get the acs information

acs = read_sas('SAS_DATA/ali_acs_recent.sas7bdat')

acs2 = distinct(acs,SCRSSN, .keep_all = T)

acs2$recent_acs = 1

names(acs2) = tolower(names(acs2))

df2 = left_join(df, acs2, by = "scrssn")

df2$recent_acs[is.na(df2$recent_acs)]<- 0

df2 %>% tabyl(recent_acs)

# ckd

ckd = read_sas('SAS_DATA/ali_ckd.sas7bdat')

names(ckd) = tolower(names(ckd))

ckd$ckd = 1

ckd2 = distinct(ckd, scrssn, .keep_all = T)

df3 = left_join(df2, ckd2, by = "scrssn")

df3$ckd[is.na(df3$ckd)]<- 0

df3 %>% tabyl(ckd)

# familial  HCL 
# random assignment using binomial models.

df3$fam_hcl = rbinom(784095,1,0.004)
  
df3 %>% tabyl(fam_hcl)

# prior ischemic stroke 

st = read_sas('SAS_DATA/ali_stroke.sas7bdat')

df3$ischemic_stroke = with(df3, ifelse(scrssn %in% st$scrssn,
                                       1, 0))


df3 %>% tabyl(ischemic_stroke)

# major conditions 
# recent acs
# prior mi 
# ischemic stroke 
# pad 

# define patients with at least 2 major conditions 

glimpse(df3)

df3$major = df3$recent_acs + df3$cad + df3$pad + df3$ischemic_stroke + 
  df3$PRIOR_MI

# to identify those patients that have at least 2 score on their major conditions 

df3$major_vhr = with(df3, ifelse(major >= 2, 1, 0))

df3 %>% tabyl(major_vhr)

# now the minor criteria

# age > 65
# fam_hcl 
# prior cabg or prior pci
# dm
#ckd 
# smoking 
#ldl > 100
# hf


df3$act_smoke2 = rbinom(784095,1,0.15)


# to get the age 

df3$vhr_age = with(df3, ifelse(age >= 65, 1, 0))

df3 %>% tabyl(vhr_age)

df3$high_ldl = with(df3, ifelse(
  baseline_ldl > 100, 1, 0
))


df3 %>% tabyl(high_ldl)




# tally all the minor criteria together...

df3$minor_tally = df3$vhr_age + df3$fam_hcl + 
  df3$DM + df3$HTN + df3$PRIOR_PCI + df3$ckd + 
  df3$act_smoke2 + df3$HF + df3$high_ldl

# now to identify 1 major + at least 2 minor

df3$m1 = df3$minor_tally + df3$recent_acs
df3$m2 = df3$minor_tally + df3$PRIOR_MI
df3$m3 = df3$ischemic_stroke + df3$minor_tally
df3$m4 = df3$minor_tally + df3$pad

df3$minor_vhr = with(df3, ifelse(
  (m1 >= 3 | m2 >= 3 |m4 >= 3), 1, 0
))

df3 %>% tabyl(minor_vhr)

df3$vhr = with(df3, ifelse((minor_vhr == 1|major_vhr == 1),
                           1,0))

df3 %>% tabyl(vhr)

# now to get the urban rural information

library(zipcodeR)

z = zip_code_db

glimpse(z)


p = z %>% select(population_density, zipcode)


df4 = left_join(df3, p, by = "zipcode")

# now to define as rural 

df4$rural = with(df4, ifelse(population_density < 1000, 1, 0))


df4 %>% tabyl(rural)


library(tableone)

table = tableone::CreateCatTable(vars = c("vhr_age",'fam_hcl','DM',
                                          'HTN','PRIOR_PCI','ckd',
                                          'act_smoke2','HF','high_ldl',
                                          'minor_vhr','major_vhr',"vhr",
                                          "PRIOR_PCI","PRIOR_MI",
                                          "ischemic_stroke","pad",
                                          "recent_acs",
                                          "statin","low","moderate","high","eze","pcsk9i"),
            data= df3,
                                 strata = c("condition"))

vars = c("vhr_age",'fam_hcl','DM',
  'HTN','PRIOR_PCI','ckd',"condition",
  'act_smoke2','HF','high_ldl',
  'minor_vhr','major_vhr',
  "PRIOR_PCI","PRIOR_MI",
  "ischemic_stroke","pad",
  "recent_acs",
  "statin","low","moderate","high","eze",
  "region", "median_hh_inc","age","rural")


factors = c("vhr_age",'fam_hcl','DM',
  'HTN','PRIOR_PCI','ckd',"condition",
  'act_smoke2','HF','high_ldl',
  'minor_vhr','major_vhr',
  "PRIOR_PCI","PRIOR_MI",
  "ischemic_stroke","pad",
  "recent_acs",
  "statin","low","moderate","high","eze",
  "region","rural")


tab1 = print(table)

write.csv(tab1, 
          "datasets/table1.csv")



t_c = tableone::CreateContTable(vars = c("age","median_hh_inc",
                                         "baseline_ldl"),
                          strata = "condition",
                          data = df4)



t_c2 = print(t_c, nonnormal = c("age","median_hh_inc",
                         "baseline_ldl"))


write.csv(t_c2,
          "datasets/table2.csv")

table_p = tableone::CreateTableOne(vars = vars,
                  factorVars = factors,
                                 data= df4[df4$vhr == 1, ],
                                 strata = c("pcsk9i"))


tableone::CreateCatTable(vars = "rural",
                         strata = "pcsk9i",
                         data = df4[df4$vhr == 1, ])


glimpse(df4)

write_csv(df4,
"datasets/ali_withvhr.csv")

df = read_csv("datasets/ali_withvhr.csv")

# create table according to vhr.
# limit to CAD,PVD

df2 = df %>% filter(condition %in% c("CAD","PVD"))




factors = c("vhr_age",'fam_hcl','DM',
            'HTN','PRIOR_PCI','ckd',"condition",
            'act_smoke2','HF','high_ldl',
            'minor_vhr','major_vhr',
            "PRIOR_PCI","PRIOR_MI",
            "ischemic_stroke","pad",
            "recent_acs",
            "statin","high","eze",
            "region","pcsk9i")


vars = c( "vhr_age",'fam_hcl','DM',
         'HTN','PRIOR_PCI','ckd',"condition",
         'act_smoke2','HF','high_ldl',
         'minor_vhr','major_vhr',
         "PRIOR_PCI","PRIOR_MI",
         "ischemic_stroke","pad","cad",
         "recent_acs",
         "statin","low","moderate","high","eze",
         "region","vhr")


t1 = tableone::CreateCatTable(vars = vars,
                              data = df2,
                              strata = "pcsk9i")
  

tab1 = print(t1)

write.csv(tab1, 
          "datasets/t1_pcsk9i.csv")
  

tc = tableone::CreateContTable(vars = c("age","median_hh_inc",
                                 "baseline_ldl"),
                               data = df2,
                               strata = c("pcsk9i"))



table =  print(tc, nonnormal = c("age","median_hh_inc",
                        "baseline_ldl"))



write.csv(table, 
          "datasets/t1_pcsk9i_cont.csv")



# adding neighbour dep index.

df = read_csv("datasets/ali_withvhr.csv")


# get the fipscode for the data.

f = read_sas("SAS_DATA/ali_zip.sas7bdat")

# now to get the fipscode for each patient...
# also need to get the deprivation index from the 
# data set uploaded...

# glimpse(f)
# 
# # limit to fips and scrssn 
# 
# names(f) = tolower(names(f))
# 
# f2 = f %>% select(scrssn, patientfips)
# 
# glimpse(f2)
# 
# f3 = distinct(f2, scrssn, .keep_all = T)
# 
# # get fipscode to the data 
# 
# df2 = left_join(df, f3, by = "scrssn")
# 
# dim(df)
# 
# summary(df2$patientfips)
# 
# df2$patientfips = as.numeric(df2$patientfips)
# 
# df2$patientfips
# 
# # get the data for the index.
# 
# index = read.table("dep_index.txt",header = T,sep = ",")
# 
# glimpse(index)
# 
# names(index) = tolower(names(index))
# 
# index2 = index %>% rename(patientfips = fips) %>%
#   select(patientfips, adi_natrank)
# 
# str(index2)
# 
# index2$adi_natrank = as.numeric(index2$adi_natrank)
# 
# summary(index2$adi_natrank)
# 
# # join fipscode and index.
# 
# df3 = left_join(df2, index2, by = "patientfips")
# 
# summary(df3$adi_natrank)

# SEE THE vitals 

df3 = df

glimpse(df3)

a = read_sas("SAS_DATA/ali_age_vitals.sas7bdat")

glimpse(a)

# get the info regarding outcome.

names(a) = tolower(names(a))

a2 = a %>% arrange(scrssn, desc(act_last_dt))

# keep only distinct scrssn 

a3 = distinct(a2, scrssn, .keep_all = TRUE)

a3 %>% count(living_ind)

a3$died = with(a3, ifelse(living_ind == 1, 0, 1))

a3 = a3 %>% select(scrssn, act_last_dt, died)

# join with df

df2  = left_join(df, a3, by = "scrssn")

# now to see the data

df2$years = ((df2$visitdate %--% df2$act_last_dt)/ddays(1))/365

summary(df2$years)

df3 = df2[df2$years >= 0 & !is.na(df2$years), ]

# now df3 contains data regarding outcome also --- mortality

summary(df3$years)

# save this data set with all_cause_mortality

write_csv(df3,
  "datasets/data_withoutcome.csv")


s = survfit(Surv(years, died) ~ condition, 
            data = df3[df3$condition %in% c("PVD","CAD"), ])

plot(s)

library(survminer)

ggsurvplot(s, risk.table = T,
           censor.size = 0,
           conf.int = T,fun = "event")

c = coxph(Surv(years, died) ~ condition, 
          data = df3)

summary(c)


# see outcome cad, cad + pad, pad only 

glimpse(df3)

df4 = df3[df3$condition %in% c("CAD","PVD"), ]

df4$dis = with(df4, ifelse((cad == 1 & pad == 0), 1, 
          ifelse((pad == 1 & cad == 0), 2, 
              3)))

df4 %>% count(dis)

df4$dis[df4$dis == 1]<- "CAD"
df4$dis[df4$dis == 2]<- "PAD"
df4$dis[df4$dis == 3]<- "CAD + PAD"



s = survfit(Surv(years, died) ~ dis, 
            data = df4)


p = ggsurvplot(s, risk.table = T,
           censor.size = 0,
           conf.int = T,fun = "event")


pdf("cad_vs_pad.pdf",
    height = 5, width = 8)

p

dev.off()



sp = survfit(Surv(years, died) ~ pcsk9i, 
            data = df4[df4$dis == "CAD + PAD", ])



sp2 = ggsurvplot(sp, risk.table = T,
               censor.size = 0,
               conf.int = T,fun = "event")


pdf("plot_cad_pad.pdf",
    height = 5, width = 8)

sp2

dev.off()



s2 = survfit(Surv(years, died) ~ statin, 
            data = df4[df4$vhr == 1 & df4$pad == 1, ])

plot(s)

library(survminer)

ggsurvplot(s2, risk.table = T,
           censor.size = 0,
           conf.int = T,fun = "event")



c = coxph(Surv(years, died) ~ factor(dis), 
          data = df4)

summary(c)

glimpse(df4)

c = coxph(Surv(years, died) ~ statin, 
          data = df4)

summary(c)

#########
#CHECKED#
#########