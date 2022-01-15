#########################################################
# 2022-01-05 THIS SCRIPT HAS BEEN CHECKED FOR ACCURACY  #
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


df = read_csv("datasets/the_final.csv")

df$polyvasc = factor(df$polyvasc)

# get deprivation index

# need to convert form zip to zcta 

ztca_zip <- read_csv("ztca_zip.csv")

zz = ztca_zip

names(zz) = tolower(names(zz))

zz = zz %>% rename(zipcode = zip_code) %>% 
  select(zipcode, zcta)

df2 = left_join(df, zz, by = "zipcode")

# now to get the indicators for my data...

dep = read_csv("dep_index.csv")

glimpse(dep)

names(dep) = tolower(names(dep)) 

dep = dep %>% rename(zcta = zcta5)

df3 = left_join(df2, dep, by = "zcta")

summary(df3$dep_index)

df = df3

# the dataset the_final2 now contains all the variables needed for the analysis.

write_csv(df, "datasets/the_final2.csv")


#- get the dataset again here 

df = read_csv("datasets/the_final2.csv")


# now need simple stats for the whole cohort 

summary(df$age)

df %>% freq(gender2)

# see freq for each condition

df %>% freq(condition)

# need to get the home va for the patients.

hva = read_sas("SAS_DATA/ali_homva_cleaned.sas7bdat")

glimpse(hva)

hva2 = hva %>% select(Sta3n, scrssn)

df2 = left_join(df, hva2, by = "scrssn")

glimpse(df2)


# now to save this dataset so that will be the final dataset...

write_csv(df2, "datasets/the_final3.csv")

# FINAL3 IS THE MOST RECENT AND COMPLETE DATASET NOW...

df2 = read_csv("datasets/the_final3.csv")

# no of PCSK9i therapy 

df2 %>% freq(pcsk9i)


df2 %>% freq(Sta3n) # no NA in station / home VA ...

# 124 VA medical centers ...


hva_count = df2 %>% group_by(Sta3n) %>% summarise(total = n()) 

# group_by: one grouping variable (Sta3n)
# summarise: now 124 rows and 2 columns, ungrouped

# age cohort 

df2 %>% descr(age)

# Descriptive Statistics  
# df2$age  
# N: 519566  
# 
# age
# ----------------- -----------
#   Mean       73.94
# Std.Dev        9.90
# Min       48.00
# Q1       68.00
# Median       74.00
# Q3       80.00
# Max       97.00
# MAD        8.90
# IQR       12.00
# CV        0.13
# Skewness       -0.08
# SE.Skewness        0.00
# Kurtosis        0.03
# N.Valid   519566.00
# Pct.Valid      100.00


# sex 

df2 %>% freq(gender2)

# Frequencies  
# df2$gender2  
# Type: Character  
# 
# Freq   % Valid   % Valid Cum.   % Total   % Total Cum.
# ----------- -------- --------- -------------- --------- --------------
#   F    21077      4.06           4.06      4.06           4.06
# M   498489     95.94         100.00     95.94         100.00
# <NA>        0                               0.00         100.00
# Total   519566    100.00         100.00    100.00         100.00


# condition 

df2 %>% freq(condition)

# Frequencies  
# df2$condition  
# Type: Character  
# 
# Freq   % Valid   % Valid Cum.   % Total   % Total Cum.
# ----------- -------- --------- -------------- --------- --------------
#   CAD   337766     65.01          65.01     65.01          65.01
# CVA   101874     19.61          84.62     19.61          84.62
# PVD    79926     15.38         100.00     15.38         100.00
# <NA>        0                               0.00         100.00
# Total   519566    100.00         100.00    100.00         100.00




# limit to those that had pcsk9i fill and then see the counts

pcsk9i_va_table = df2 %>% group_by(Sta3n, pcsk9i) %>% summarise(count = n())


pcsk9i_va_table2 = left_join(pcsk9i_va_table,hva_count, by = 'Sta3n' )



t = pcsk9i_va_table2 %>% filter(pcsk9i == 1) 

sum(t$count) # 2115 patients in the pcsk9i dataset..... that is correct.

# need to get the median fill rate overall for pcsk9i...



pcsk9i_va_table2$Sta3n = factor(pcsk9i_va_table2$Sta3n)

pcsk9i_va_table2$pcsk9i = factor(pcsk9i_va_table2$pcsk9i)

pcsk9_w = pivot_wider(data = pcsk9i_va_table2,
                      id_cols = Sta3n,
                      names_from = pcsk9i,
                      values_from = count)



pcsk9_w = pcsk9_w %>% rename(no = `0`, yes = `1`)

pcsk9_w$yes[is.na(pcsk9_w$yes)]<- 0

pcsk9_w$fill_1000pt = (pcsk9_w$yes/(pcsk9_w$no + pcsk9_w$yes))*1000

summary(pcsk9_w$fill_1000pt) # overall median initiation rate = 3.27 


# also do by condition 


pcsk9i_va_table_cond = df2 %>% group_by(Sta3n, condition, pcsk9i) %>% summarise(count = n())

pcsk9i_va_table2_cond = left_join(pcsk9i_va_table_cond,hva_count, by = 'Sta3n' )

pcsk9i_va_table2_cond$Sta3n = factor(pcsk9i_va_table2_cond$Sta3n)

pcsk9i_va_table2_cond$pcsk9i = factor(pcsk9i_va_table2_cond$pcsk9i)


pcsk9_w_cond = pivot_wider(data = pcsk9i_va_table2_cond,
                      id_cols = Sta3n,
                      names_from = c('pcsk9i', 'condition'),
                      values_from = count)

# to convert NA to 0 in all the columns...

pcsk9_w_cond = pcsk9_w_cond %>% rename(
  cad_no = `0_CAD`,
  cvd_no = `0_CVA`,
  pad_no = `0_PVD`,
  cad_yes = `1_CAD`,
  cvd_yes = `1_CVA`,
  pad_yes = `1_PVD`
)

pcsk9_w_cond[is.na(pcsk9_w_cond)]<- 0

pcsk9_w_cond = pcsk9_w_cond %>% mutate(
  total = cad_no + cad_yes + pad_no + pad_yes + cvd_no + cvd_yes,
  cad_total = cad_yes + cad_no,
  cad_treat = (cad_yes/cad_total)*1000,
  pad_total = pad_yes + pad_no,
  pad_treat = (pad_yes/pad_total)*1000,
  cvd_total = cvd_yes + cvd_no,
  cvd_treat = (cvd_yes/cvd_total)*1000
)


summary(pcsk9_w_cond$cad_treat)

summary(pcsk9_w_cond$pad_treat)

summary(pcsk9_w_cond$cvd_treat)

a = pcsk9_w_cond %>% ggplot(aes( y = cad_treat,x = reorder(Sta3n, cad_treat))) + 
  geom_point(col = "blue",size = 2) + 
  geom_segment(aes(x = Sta3n,
                   xend = Sta3n,
                   y = 0,
                   yend = cad_treat)) + 
  ylim(0,25) + xlab("") + ylab("") + theme_minimal() + 
  theme(axis.text.x = element_blank()) + 
  geom_hline(yintercept = 3.27, linetype = 2)


b = ggplot(data = pcsk9_w_cond, aes(x = reorder(Sta3n, pad_treat), y = pad_treat)) + 
  geom_point(col = "red", size = 2) + 
  geom_segment(aes(x = Sta3n,
                   xend = Sta3n,
                   y = 0,
                   yend = pad_treat)) + 
  ylim(0,25) + xlab("") + ylab("") + theme_minimal() + 
  theme(axis.text.x = element_blank()) + 
  geom_hline(yintercept = 3.27, linetype = 2)



c = ggplot(data = pcsk9_w_cond, aes(x = reorder(Sta3n, cvd_treat), y = cvd_treat)) + 
  geom_point(col = "green", size = 2) + 
  geom_segment(aes(x = Sta3n,
                   xend = Sta3n,
                   y = 0,
                   yend = cvd_treat)) + 
  ylim(0,25) + xlab("") + ylab("") + theme_minimal() + 
  theme(axis.text.x = element_blank()) + 
  geom_hline(yintercept = 3.27, linetype = 2)



library(patchwork)

p = (a/b/c) 

p ############ till here ######################

ggsave(plot = p,
       filename = "figures//init_plot.tiff",
       height = 7,
       width = 10,
       device = tiff,
       res = 600)

# think this looks like a good chart.
# now to count the number of va that have more than median initiation rate 
# for each condition


dim(pcsk9_w_cond %>% select(cad_treat) %>% filter(cad_treat >= 3.27))

# [1] 78  2

dim(pcsk9_w_cond %>% select(pad_treat) %>% filter(pad_treat >= 3.27))
# [1] 22  2


dim(pcsk9_w_cond %>% select(cvd_treat) %>% filter(cvd_treat >= 3.27))
# [1] 18  2



# 
# # save this pcsk9i table now...
# 
# write_csv(pcsk9i_va_table2, "datasets\\pcsk9i_tablec.csv")
# 
# # count the number of VA centers that saw patients...
# 
# length(unique(df2$Sta3n))
# 
# # draw rough graph for the fill % for each va using PCSK9i
# 
# 
# glimpse(pcsk9i_va_table2)
# 
# pcsk9i_va_table2$Sta3n = factor(pcsk9i_va_table2$Sta3n)
# 
# pcsk9i_va_table2$pcsk9i = factor(pcsk9i_va_table2$pcsk9i)
# 
# pcsk9_w = pivot_wider(data = pcsk9i_va_table2,
#                       id_cols = Sta3n,
#                       names_from = pcsk9i,
#                       values_from = count)
# 
# pcsk9_w = pcsk9_w %>% rename(no = `0`, yes = `1`)
# 
# pcsk9_w$yes[is.na(pcsk9_w$yes)]<- 0
# 
# pcsk9_w$fill_1000pt = (pcsk9_w$yes/(pcsk9_w$no + pcsk9_w$yes))*1000
# 
# pcsk9_w = pcsk9_w %>% arrange(fill_1000pt)
# 
# pcsk9_w$Sta3n = factor(pcsk9_w$Sta3n, ordered = T)
# 
# pcsk9_w %>% ggplot(aes(x = reorder(Sta3n, fill_1000pt), y = fill_1000pt)) + geom_bar(stat = "identity")
# 
# pcsk9_w %>% descr(fill_1000pt)
# 
# 
# summary(pcsk9_w$fill_1000pt)






# need to finalise tables now that all the data is collected.


vars = c("condition", 
         "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", "ckd",
         "PRIOR_PCI", "age",  "region", "median_hh_inc",  "baseline_ldl",
         "statin", "high", "moderate", "low",  "vhr",  "rural", "eze",
        "pcsk9i", "race2","gender2","ldl_cat","inc_group","statin_group",
          "polyvasc","visit_year","dep_index")

catvars = c("condition", 
            "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", 
            "PRIOR_PCI", "region", "ckd",
            "statin", "high", "moderate", "low",  "vhr",  "rural","eze",
            "pcsk9i", "race2","gender2","ldl_cat","inc_group","statin_group",
             "polyvasc","visit_year")


t1 = tableone::CreateTableOne(vars = vars,addOverall = T,
                              factorVars = catvars,
                              data = df2,
                              strata = c("condition"))


t1


table1 = print(t1, nonnormal = c("age","median_hh_inc","dep_index", "baseline_ldl"))

# now save this table in the results folder as table 1.

write.csv(table1, 
          "results/table1_final.csv")


# CAD vs PVD p-values


t_cad_pad = tableone::CreateTableOne(vars = vars,addOverall = F,
                              factorVars = catvars,
                              data = df2[df2$condition %in% c("CAD","PVD"), ],
                              strata = c("condition"))


t_cad_pad_table = print(t_cad_pad, smd = T,
                nonnormal = c("age","median_hh_inc","baseline_ldl"),
smd = T)


write.csv(t_cad_pad_table, "results/t_cad_pad_table_final_smd.csv")


# CAD vs CVD 


t_cad_cvd = tableone::CreateTableOne(vars = vars,addOverall = F,
                                     factorVars = catvars,
                                     data = df2[df2$condition %in% c("CAD","CVA"), ],
                                     strata = c("condition"))


t_cad_cvd_table = print(t_cad_cvd, smd = T,
                        nonnormal = c("age","median_hh_inc","baseline_ldl"))


write.csv(t_cad_cvd_table, "results/t_cad_cvd_table_final_smd.csv")


# these tables will complete the table 1 that is needed for the paper.

# table to compare PCSK9i initiators vs non-initiators

df2 %>% freq(pcsk9i)


# table 2 

vars = c("condition", 
         "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", "ckd",
         "PRIOR_PCI", "age",  "region", "median_hh_inc",  "baseline_ldl",
         "statin", "high", "moderate", "low",  "vhr",  "rural", "eze",
         "pcsk9i", "race2","gender2","ldl_cat","inc_group",
         "statin_group", "polyvasc","visit_year","dep_index")

catvars = c("condition", 
            "AF", "DM", "HTN", "COPD", "HF", "PRIOR_MI", 
            "PRIOR_PCI", "region", "ckd",
            "statin", "high", "moderate", "low",  "vhr",  "rural",
            "eze","eze","new_nst","pcsk9i",
            "race2","gender2","ldl_cat","inc_group","statin_group","polyvasc","visit_year")


t2 = tableone::CreateTableOne(vars = vars,
                              factorVars = catvars,
                              data = df2,
                              strata = c("pcsk9i"))


t2


table2_pcsk9i = print(t2, nonnormal = c("age","median_hh_inc", 
                                      "baseline_ldl","dep_index"))


write.csv(table2_pcsk9i, "results/table2_pcsk9i_final.csv")


# look at the proportion of initiators according to LDL groups 

stby(data = list(x = df$condition, y = df$pcsk9i),
     INDICES = df$ldl_cat,
     FUN = ctable)

glimpse(df)

# # among initiators, see what is the percentage of each condition 
# # for increasing time period 
# 
# # limit data to initiators
# 
# df_i = df %>% filter(pcsk9i == 1)
# 
# # now to group by time period and then further by condition 
# 
# df_t = df_i %>% group_by(fill_quarter_pcsk9i) %>%
#   summarise(count = n())
# 
# df_cabg = df_i %>% group_by(fill_quarter_pcsk9i) %>% 
#   filter(condition == "CAD") %>%
# summarise(count_cad = n())
# 
# 
# df_pad = df_i %>% group_by(fill_quarter_pcsk9i) %>% 
#   filter(condition == "PVD") %>%
#   summarise(count_pvd = n())
# 
# df_cvd = df_i %>% group_by(fill_quarter_pcsk9i) %>% 
#   filter(condition == "CVA") %>%
#   summarise(count_cvd = n())
# 
# 
# total_df = left_join(df_t, df_cabg, by = "fill_quarter_pcsk9i")
# 
# total_df2 = left_join(total_df, df_pad, by = "fill_quarter_pcsk9i")
# 
# total_df3 = left_join(total_df2, df_cvd, by = "fill_quarter_pcsk9i")
# 
# 
# total_df3
# 
# write.csv(total_df3, "results/prop_group.csv")

# what is the mean LDL at which pcsk9i is intiated ? 

df_pcsk9i = df2 %>% filter(pcsk9i == 1)


with(df_pcsk9i,  
stby(data = baseline_ldl,
     INDICES = condition,
     FUN = descr,
     stats = c("mean","sd","min","max","med")))

# Descriptive Statistics  
# baseline_ldl by condition  
# Data Frame: df_pcsk9i  
# N: 1782  
# 
#   CAD      CVA      PVD
# ------------- -------- -------- --------
#   Mean   140.46   146.63   137.26
#   Std.Dev    37.06    35.23    38.81
#  Min    70.00    70.00    72.60
#  Max   195.00   195.00   195.00
#  Median   139.00   148.10   133.50


# 
# 
# # get quantiles for each group
# 
# q25 = df_pcsk9i %>% group_by(condition) %>%
#   summarise(q25 = quantile(baseline_ldl, probs = 0.25))
# 
# 
# q75 = df_pcsk9i %>% group_by(condition) %>%
#   summarise(q25 = quantile(baseline_ldl, probs = 0.57))
# 
# quantiles = left_join(q25,q75, by = "condition")
# 
# quantiles
# 
# # A tibble: 3 x 3
# #  condition q25.x q25.y
# #  <chr>     <dbl> <dbl>
# #1 CAD        108.  144 
# #2 CVA        112   148 
# #3 PVD        105.  141.
# 
# 
# 
# # baseline LDL is not normally distributed, so am going to present 
# # as non parametric Wilcoxon test with bonferroni adjustment.
# # present this as box-plots 
# 
# df_pcsk9i %>% ggplot(aes(x = condition, y = baseline_ldl, fill = condition)) + 
#   geom_boxplot(notch = T)
# 
# 
# library(rstatix)
# 
# wilcox_test(data = df_pcsk9i,
#             formula = baseline_ldl ~ condition,
#             ref.group = "CAD",
#             p.adjust.method = "bonferroni")
# 

# A tibble: 2 x 9
#  .y.          group1 group2    n1    n2 statistic     p p.adj
#* <chr>        <chr>  <chr>  <int> <int>     <dbl> <dbl> <dbl>
#1 baseline_ldl CAD    CVA     3260   371   580622  0.207 0.414
#2 baseline_ldl CAD    PVD     3260   286   465494. 0.967 1    
## ... with 1 more variable: p.adj.signif <chr>






# REGRESSION MODELS FROM THIS PART ONWARDS...

df = df2

df %>% freq(pcsk9i)


# smoking is coded again and that should be used to identify smoking.

smoke = read_sas("SAS_DATA/ali_smoking.sas7bdat")

glimpse(smoke)

df = df %>% mutate(smoking = ifelse(scrssn %in% smoke$SCRSSN, 1, 0))

df %>% freq(smoking)



# now to see the regression models 

df$pcsk9i = factor(df$pcsk9i)
  
m = glm(pcsk9i ~ condition + age + AF + DM + HTN + COPD + HF + PRIOR_MI + 
          PRIOR_PCI + age + region + ldl_cat + inc_group + gender2 + 
          race2 + polyvasc + smoking, data = df, family = "binomial")


m

summary(m)

confint_tidy(m)

# using rms 

library(rms)

df$age_c = df$age/10

# making some variables numerical again 

df = df %>% mutate(
  ldl_cat_n = ifelse(ldl_cat == "70-100", 1,
    ifelse(ldl_cat == "100-130", 2, 3)),
  inc_group_n = ifelse(inc_group == "<40000",1, 
    ifelse(inc_group == "40000-80000", 2, 3)),
  gender_n = ifelse(gender2 == "M", 0, 1),
  race_n = ifelse(race2 == "wh", 1, 
    ifelse(race2 == "aa", 2, 3)),
  dep_index_n = ifelse(dep_index < 0.33, 1, 
                       ifelse(dep_index >= 0.33 & dep_index < 0.66, 2, 3)),
  condition_n = ifelse(condition == "CAD", 0, 
                       ifelse(condition == "PVD", 1, 2)))


df$ldl_cat_n = factor(df$ldl_cat_n)

df$inc_group_n = factor(df$inc_group_n)

df$gender_n = factor(df$gender_n)

df$race_n = factor(df$race_n)

df$dep_index_n = factor(df$dep_index_n)

df$condition_n = factor(df$condition_n)

df %>% count(condition_n)



# we do not have dep_index tables 


dep_index_t = tableone::CreateCatTable(vars = "dep_index_n",
                         strata = "condition",
                         data = df)
# Stratified by condition
# CAD            CVA           PVD           p      test
# n               337766         101874        79926                    
# dep_index_n (%)                                            <0.001     
# 1             97741 (29.3)  26878 (26.9)  21315 (27.4)             
# 2            234374 (70.3)  72506 (72.5)  56057 (71.9)             
# 3              1496 ( 0.4)    570 ( 0.6)    562 ( 0.7)   

# get smd for each group

df_pad = df %>% filter(condition %in% c("CAD","PVD")) 



print(tableone::CreateCatTable(vars = "dep_index_n",
                         strata = "condition",
                         data = df_pad), smd = T)



df_cvd = df %>% filter(condition %in% c("CAD","CVA")) 



print(tableone::CreateCatTable(vars = "dep_index_n",
                         strata = "condition",
                         data = df_cvd), smd = T)






# depindex tertile for PCSK9i

tableone::CreateCatTable(vars = "dep_index_n",
                         strata = "pcsk9i",
                         data = df)



# Stratified by pcsk9i
# 0              1            p      test
# n               517451         2115                    
# dep_index_n (%)                             <0.001     
# 1            145244 (28.5)   690 (32.9)             
# 2            361531 (71.0)  1406 (67.0)             
# 3              2625 ( 0.5)     3 ( 0.1)             



# keep only those for model 


modeldf = df[, c('pcsk9i', 'age' , 'condition' , 'DM' , 
 'AF' , 'HTN' , 'COPD' , 'HF' , 'PRIOR_MI',"ckd",
  'PRIOR_PCI' , 'age'  , 'ldl_cat_n' , 'inc_group_n' , 
  'gender_n' , 'race_n' , 'polyvasc' , 'smoking','dep_index_n',
 "vhr","Sta3n")]


library(naniar)

naniar::miss_var_summary(modeldf)

# only income missing, move that to the mode i.e. the middle group
# mean for dep index

modeldf %>% freq(dep_index_n)

modeldf$inc_group_n[is.na(modeldf$inc_group_n)]<- 2

modeldf$dep_index_n[is.na(modeldf$dep_index_n)]<- 2

naniar::miss_var_summary(modeldf)

modeldf = as.data.frame(modeldf)

# while exploring models with R, can also use STATA as has good margins
# and contrast features for analysis.

write_dta(modeldf, "datasets/model_stata.dta")


dd <- datadist(modeldf)
options(datadist = 'dd')


# what interaction would we want to see in the model
# age & condition, age & ldl_cat, age & sex
# condition & ldl_cat



ma = lrm(pcsk9i ~ rcs(age,3) + condition +  DM + 
   AF + HTN + COPD + HF + PRIOR_MI+ gender_n + ckd + vhr + 
      PRIOR_PCI +  ldl_cat_n + inc_group_n + race_n + polyvasc + smoking + dep_index_n +
     rcs(age,3)%ia%condition +  
     condition%ia%ldl_cat_n 
     
          , data = modeldf, x = T, y = T)



anova(ma)

# Wald Statistics          Response: pcsk9i 
# 
# Factor                                               Chi-Square d.f. P     
# age  (Factor+Higher Order Factors)                    252.91     6   <.0001
# All Interactions                                       4.29     4   0.3677
# Nonlinear (Factor+Higher Order Factors)              191.51     3   <.0001
# condition  (Factor+Higher Order Factors)              342.05    10   <.0001
# All Interactions                                      15.14     8   0.0564
# DM                                                      1.19     1   0.2750
# AF                                                      0.48     1   0.4871
# HTN                                                     0.39     1   0.5325
# COPD                                                   30.72     1   <.0001
# HF                                                      6.54     1   0.0105
# PRIOR_MI                                                5.77     1   0.0163
# gender_n                                                0.42     1   0.5150
# ckd                                                     5.55     1   0.0185
# vhr                                                     3.79     1   0.0517
# PRIOR_PCI                                              37.32     1   <.0001
# ldl_cat_n  (Factor+Higher Order Factors)             1474.18     6   <.0001
# All Interactions                                      10.36     4   0.0348
# inc_group_n                                             5.48     2   0.0647
# race_n                                                 48.09     2   <.0001
# polyvasc                                               29.63     1   <.0001
# smoking                                                 5.56     1   0.0184
# dep_index_n                                            16.25     2   0.0003
# age * condition  (Factor+Higher Order Factors)          4.29     4   0.3677
# Nonlinear                                              3.67     2   0.1594
# Nonlinear Interaction : f(A,B) vs. AB                  3.67     2   0.1594
# condition * ldl_cat_n  (Factor+Higher Order Factors)   10.36     4   0.0348
# TOTAL NONLINEAR                                       191.51     3   <.0001
# TOTAL INTERACTION                                      15.14     8   0.0564
# TOTAL NONLINEAR + INTERACTION                         202.26     9   <.0001
# TOTAL                                                2405.61    32   <.0001


# from the anova for age%ia%condition, there is no use of this interaction term
# removed in the next model 


ma2 = lrm(pcsk9i ~ rcs(age,3) + condition +  DM + 
           AF + HTN + COPD + HF + PRIOR_MI+ gender_n + ckd + vhr + 
           PRIOR_PCI +  ldl_cat_n + inc_group_n + race_n + polyvasc + 
            smoking + dep_index_n +
           
           condition%ia%ldl_cat_n 
         
         , data = modeldf, x = T, y = T)



anova(ma2)

# Wald Statistics          Response: pcsk9i 
# 
# Factor                                               Chi-Square d.f. P     
# age                                                   250.83     2   <.0001
# Nonlinear                                            190.05     1   <.0001
# condition  (Factor+Higher Order Factors)              342.03     6   <.0001
# All Interactions                                      10.92     4   0.0275
# DM                                                      1.20     1   0.2739
# AF                                                      0.47     1   0.4918
# HTN                                                     0.41     1   0.5242
# COPD                                                   30.73     1   <.0001
# HF                                                      6.54     1   0.0105
# PRIOR_MI                                                5.72     1   0.0167
# gender_n                                                0.38     1   0.5369
# ckd                                                     5.62     1   0.0178
# vhr                                                     3.59     1   0.0582
# PRIOR_PCI                                              37.32     1   <.0001
# ldl_cat_n  (Factor+Higher Order Factors)             1475.21     6   <.0001
# All Interactions                                      10.92     4   0.0275
# inc_group_n                                             5.51     2   0.0635
# race_n                                                 48.03     2   <.0001
# polyvasc                                               29.97     1   <.0001
# smoking                                                 5.43     1   0.0198
# dep_index_n                                            16.30     2   0.0003
# condition * ldl_cat_n  (Factor+Higher Order Factors)   10.92     4   0.0275
# TOTAL NONLINEAR + INTERACTION                         200.58     5   <.0001
# TOTAL                                                2422.45    28   <.0001


# plotting the model 

ma_summary <- summary(ma2)

plot(ma_summary) # this is a very general plot.

summary(ma2,antilog = T) 

# Logistic Regression Model

# lrm(formula = pcsk9i ~ rcs(age, 3) + condition + DM + AF + HTN + 
#       COPD + HF + PRIOR_MI + gender_n + ckd + vhr + PRIOR_PCI + 
#       ldl_cat_n + inc_group_n + race_n + polyvasc + smoking + dep_index_n + 
#       condition %ia% ldl_cat_n, data = modeldf, x = T, y = T)
# 
# Model Likelihood    Discrimination    Rank Discrim.    
# Ratio Test           Indexes          Indexes    
# Obs         519566    LR chi2    2891.65    R2       0.108    C       0.807    
# 0          517451    d.f.            28    g        1.427    Dxy     0.615    
# 1            2115    Pr(> chi2) <0.0001    gr       4.168    gamma   0.622    
# max |deriv|  1e-08                          gp       0.005    tau-a   0.005    
# Brier    0.004                     
# 
# Coef    S.E.   Wald Z Pr(>|Z|)
# Intercept                   -7.8158 0.3403 -22.97 <0.0001 
# age                          0.0288 0.0049   5.93 <0.0001 
# age'                        -0.1131 0.0082 -13.79 <0.0001 
#  condition=CVA               -1.4433 0.2260  -6.39 <0.0001 
#  condition=PVD               -0.6965 0.1720  -4.05 <0.0001 
#  DM                           0.0554 0.0506   1.09 0.2739  
#  AF                           0.0501 0.0729   0.69 0.4918  
#  HTN                          0.0355 0.0557   0.64 0.5242  
#  COPD                        -0.3761 0.0678  -5.54 <0.0001 
#  HF                          -0.2309 0.0903  -2.56 0.0105  
#  PRIOR_MI                    -0.3278 0.1370  -2.39 0.0167  
#  gender_n=1                   0.0628 0.1016   0.62 0.5369  
#  ckd                          0.1756 0.0741   2.37 0.0178  
#  vhr                          0.1319 0.0696   1.89 0.0582  
#  PRIOR_PCI                    0.6404 0.1048   6.11 <0.0001 
#  ldl_cat_n=2                  1.0629 0.0769  13.82 <0.0001 
#  ldl_cat_n=3                  2.2622 0.0686  32.97 <0.0001 
#  inc_group_n=2                0.0195 0.0556   0.35 0.7257  
#  inc_group_n=3                0.2167 0.1011   2.14 0.0321  
#  race_n=2                    -0.6111 0.0980  -6.24 <0.0001 
#  race_n=3                    -0.1988 0.0466  -4.27 <0.0001 
#  polyvasc                     0.3429 0.0626   5.47 <0.0001 
#  smoking                     -0.1068 0.0458  -2.33 0.0198  
#  dep_index_n=2               -0.1964 0.0556  -3.53 0.0004  
#  dep_index_n=3               -1.3258 0.5826  -2.28 0.0229  
#  condition=CVA * ldl_cat_n=2  0.1624 0.2774   0.59 0.5583  
#  condition=CVA * ldl_cat_n=3  0.3609 0.2457   1.47 0.1419  
#  condition=PVD * ldl_cat_n=2 -0.6880 0.2542  -2.71 0.0068  
#  condition=PVD * ldl_cat_n=3 -0.4205 0.2051  -2.05 0.0404 


# important factors here is the plot of age and then 
# interaction of condition with ldl category

t = tibble(
  group = c("CAD", "CeVD+LDL2","CeVD+ldl3",
            "PAD+ldl2","PAD+ldl3"),
  coef = c(0, 0.1624, 0.3609, -0.6880, -0.4205),
  se = c(0, 0.2774, 0.2457, 0.2542, 0.2051),
  p_value = c(0, 0.55, 0.14, 0.006, 0.04))

t$group =  factor(t$group, ordered = T)

t$OR = exp(t$coef)
t$l_95 = exp(t$coef - 1.96*t$se)
t$u_95 = exp(t$coef + 1.96*t$se)


t

t2 = tibble(
  group = c(5,4,3,2,1),
  coef = c(0, 0.1624, 0.3609, -0.6880, -0.4205),
  se = c(0, 0.2774, 0.2457, 0.2542, 0.2051),
  p_value = c(0, 0.55, 0.14, 0.006, 0.04),
  col = c(0,1,1,2,2))

t2$group =  factor(t2$group, ordered = T)

t2$OR = exp(t2$coef)
t2$l_95 = exp(t2$coef - 1.96*t2$se)
t2$u_95 = exp(t2$coef + 1.96*t2$se)


t2



t_p = ggplot(t2, aes(y = group, x = OR,color = factor(col))) + geom_point(size = 5) + 
  geom_errorbarh(aes(xmin = l_95, xmax = u_95, height = 0))

# now to add more info and make the plot better...

t_p2 = t_p + theme_minimal() +
  geom_vline(xintercept = 1 , linetype = 2, color = "red") +
  scale_x_continuous(lim = c(0,3), breaks = c(0.5, 1, 1.5, 2, 2.5, 3)) + 
  theme(legend.position = "none") + labs(x = "", y = "")


tiff("figures/interaction_plot.tiff", height = 5, width = 8,
     units = "in",res = 300)

t_p2

dev.off()



ggsave(plot = t_p2,
       filename = "figures/interaction_plot.tiff",
       device = "tiff",
       height = 5,
       width = 8,
       units = "in",
       dpi = 300)


age_m = Predict(ma2, age = seq(50, 80, by = 1), conf.int = 0.95, ref.zero = T,
                  fun = exp)


age_m_df = age_m %>% tbl_df()

plot(age_m)


p = ggplot(age_m) + theme_minimal() + 
  scale_x_continuous(breaks = seq(50,80,by = 1)) + ylim(0.6,1.2) 
  

p2 = p + geom_hline(yintercept = 1, linetype = 2, color = "red") +
  labs(x = "")
  
p2  

tiff("figures/age_predict.tiff", height = 5, width = 8, units = "in",res = 300)

p2

dev.off()





  
ggsave(plot = p2,
       filename = "figures/age_predict.tiff",
       dpi = 300,
       height = 5,
       width = 8,
       units = "in")

# 



