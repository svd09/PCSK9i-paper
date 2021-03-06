/* do file for logistic regression model for PCSK9i use 
use rcs for age, interaction terms for condition*ldl_level */

use "P:/ORD_Deo_202010005D/LIPID_STUDY/ALIROCUMAB/datasets/model_stata.dta", replace // get the data 

// see the data 

summarize

/*
. summarize

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
      pcsk9i |    519,566    .0040707    .0636721          0          1
         age |    519,566    73.94256    9.898398         48         97
   condition |          0
          DM |    519,566    .3609397    .4802735          0          1
          AF |    519,566    .1292579    .3354855          0          1
-------------+---------------------------------------------------------
         HTN |    519,566    .6771017    .4675847          0          1
        COPD |    519,566    .1752848    .3802108          0          1
          HF |    519,566    .0869245    .2817246          0          1
    PRIOR_MI |    519,566    .0281793    .1654849          0          1
         ckd |    519,566     .117577    .3221069          0          1
-------------+---------------------------------------------------------
   PRIOR_PCI |    519,566    .0238757     .152662          0          1
         age |    519,566    73.94256    9.898398         48         97
   ldl_cat_n |    519,566    1.636304    .7731088          1          3
 inc_group_n |    519,566    1.807614    .5463314          1          3
    gender_n |    519,566    1.040567     .197284          1          2
-------------+---------------------------------------------------------
      race_n |    519,566    1.864724    .9451004          1          3
    polyvasc |    519,566    .1587306     .365425          0          1
     smoking |    519,566    .4304304    .4951369          0          1
 dep_index_n |    519,566    1.724181     .458104          1          3
         vhr |    519,566    .6455388    .4783502          0          1
*/

tab condition

/*
  condition |      Freq.     Percent        Cum.
------------+-----------------------------------
        CAD |    337,766       65.01       65.01
        CVA |    101,874       19.61       84.62
        PVD |     79,926       15.38      100.00
------------+-----------------------------------
      Total |    519,566      100.00
*/

gen condition_n = .

replace condition_n = 0 if condition == "CAD"
replace condition_n = 1 if condition == "PVD"
replace condition_n = 2 if condition == "CVA"

tab condition_n

/* simple model with all main effects, no interaction and no spline for age */

logit pcsk9i age i.condition_n DM AF COPD HF PRIOR_MI ckd HTN ///
	PRIOR_PCI i.ldl_cat_n i.dep_index_n i.inc_group_n gender_n ///
	i.race_n polyvasc smoking vhr
	
		
est store m1 // store coeff for model to do lrtest 

// fit same model with interaction of condition & ldl_category
// hypothesis: LDL level does not modify the effect of the primary condition (CAD,PAD,CeVD) to receive PCSK9i initiation

logit pcsk9i age i.condition_n##i.ldl_cat_n DM AF COPD HF PRIOR_MI ckd HTN ///
	PRIOR_PCI i.dep_index_n i.inc_group_n gender_n ///
	i.race_n polyvasc smoking vhr

/*
Logistic regression                                    Number of obs = 519,566
                                                       LR chi2(27)   = 2652.75
                                                       Prob > chi2   =  0.0000
Log likelihood = -12425.143                            Pseudo R2     =  0.0965

---------------------------------------------------------------------------------------
               pcsk9i | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
                  age |  -.0278968   .0024136   -11.56   0.000    -.0326274   -.0231663
                      |
          condition_n |
                   1  |    -.74763   .1717564    -4.35   0.000    -1.084266   -.4109937
                   2  |  -1.453222   .2260225    -6.43   0.000    -1.896218   -1.010226
                      |
            ldl_cat_n |
                   2  |   1.003277   .0765536    13.11   0.000      .853235     1.15332
                   3  |   2.192672   .0683001    32.10   0.000     2.058807    2.326538
                      |
condition_n#ldl_cat_n |
                 1#2  |  -.6624855   .2541151    -2.61   0.009    -1.160542    -.164429
                 1#3  |  -.3910728   .2050363    -1.91   0.056    -.7929366    .0107909
                 2#2  |   .1708833   .2774062     0.62   0.538     -.372823    .7145895
                 2#3  |   .3779724   .2457334     1.54   0.124    -.1036563     .859601
                      |
                   DM |   .0538581   .0504844     1.07   0.286    -.0450895    .1528057
                   AF |   .0262121   .0730036     0.36   0.720    -.1168724    .1692965
                 COPD |  -.3478408   .0677749    -5.13   0.000    -.4806771   -.2150045
                   HF |  -.2706148   .0900226    -3.01   0.003    -.4470559   -.0941738
             PRIOR_MI |  -.3964737   .1368421    -2.90   0.004    -.6646792   -.1282681
                  ckd |   .1025284   .0739195     1.39   0.165    -.0423511     .247408
                  HTN |  -.0150883   .0547313    -0.28   0.783    -.1223597     .092183
            PRIOR_PCI |   .6093822   .1045624     5.83   0.000     .4044436    .8143207
                      |
          dep_index_n |
                   2  |  -.1838526   .0555653    -3.31   0.001    -.2927586   -.0749467
                   3  |  -1.308987   .5825691    -2.25   0.025    -2.450802   -.1671727
                      |
          inc_group_n |
                   2  |    .010831   .0556221     0.19   0.846    -.0981863    .1198483
                   3  |   .1942039    .101078     1.92   0.055    -.0039053     .392313
                      |
             gender_n |  -.0163705   .1014749    -0.16   0.872    -.2152576    .1825165
                      |
               race_n |
                   2  |  -.6450983   .0980138    -6.58   0.000    -.8372019   -.4529948
                   3  |  -.2225031   .0466718    -4.77   0.000    -.3139781    -.131028
                      |
             polyvasc |   .3292671   .0626178     5.26   0.000     .2065385    .4519958
              smoking |  -.0492771   .0458266    -1.08   0.282    -.1390955    .0405413
                  vhr |   .3298081   .0679671     4.85   0.000     .1965951    .4630211
                _cons |  -4.251953   .2359242   -18.02   0.000    -4.714356    -3.78955
---------------------------------------------------------------------------------------
*/	
	
	
est store m2

lrtest m1 m2 	

/*	
Likelihood-ratio test
Assumption: m1 nested within m2

 LR chi2(4) =  10.43
Prob > chi2 = 0.0337
*/


// so clearly it is important to use the interaction term 
// now to see if we should use a spline for age 
// look at the distribution for age
	

univar age 	

/* 	
. univar age      
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
     age  519566    73.94     9.90    48.00    68.00    74.00    80.00    97.00
-------------------------------------------------------------------------------
	
*/

// given this we should create groups for 50,60,70,80 as cut-points 
//

drop agesp*

mkspline agesp_1 60 agesp_2 70 agesp_3 80 agesp_4 = age

univar agesp*

// now to fit this model and do the lrtest to evaluate with m2

logit pcsk9i agesp* i.condition_n##i.ldl_cat_n DM AF COPD HF PRIOR_MI ckd HTN ///
	PRIOR_PCI i.dep_index_n i.inc_group_n gender_n ///
	i.race_n polyvasc smoking vhr, or


est store m3

lrtest m2 m3

/*
Likelihood-ratio test
Assumption: m2 nested within m3

 LR chi2(3) = 321.91
Prob > chi2 = 0.0000

*/

// adding segmented spline term for age benefits.
// also demonstrates that younger patients < 60 years have lower 	

// final model for use 

/*
. logit pcsk9i agesp* i.condition_n##i.ldl_cat_n DM AF COPD HF PRIOR_MI ckd HTN ///
>         PRIOR_PCI i.dep_index_n i.inc_group_n gender_n ///
>         i.race_n polyvasc smoking vhr, or

Iteration 0:   log likelihood =  -13751.52  
Iteration 1:   log likelihood = -12651.716  
Iteration 2:   log likelihood = -12296.472  
Iteration 3:   log likelihood = -12265.014  
Iteration 4:   log likelihood = -12264.192  
Iteration 5:   log likelihood =  -12264.19  
Iteration 6:   log likelihood =  -12264.19  

Logistic regression                                    Number of obs = 519,566
                                                       LR chi2(30)   = 2974.66
                                                       Prob > chi2   =  0.0000
Log likelihood = -12264.19                             Pseudo R2     =  0.1082

---------------------------------------------------------------------------------------
               pcsk9i | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
              agesp_1 |   .9675385    .011534    -2.77   0.006     .9451944    .9904108
              agesp_2 |   1.031337   .0100298     3.17   0.002     1.011865    1.051184
              agesp_3 |   .9967971   .0085344    -0.37   0.708     .9802095    1.013665
              agesp_4 |   .7724973   .0155096   -12.86   0.000     .7426894    .8035015
                      |
          condition_n |
                   1  |   .5008523   .0861459    -4.02   0.000     .3575232    .7016412
                   2  |   .2368256    .053529    -6.37   0.000     .1520667    .3688273
                      |
            ldl_cat_n |
                   2  |   2.917714   .2245824    13.91   0.000     2.509135    3.392825
                   3  |   9.698762   .6667073    33.05   0.000     8.476244     11.0976
                      |
condition_n#ldl_cat_n |
                 1#2  |   .5044103   .1282111    -2.69   0.007     .3064964    .8301232
                 1#3  |   .6619324   .1357695    -2.01   0.044     .4428157    .9894738
                 2#2  |   1.176174   .3262995     0.58   0.559     .6828533     2.02589
                 2#3  |   1.435779   .3528473     1.47   0.141     .8869563    2.324198
                      |
                   DM |   1.060796   .0537601     1.16   0.244     .9604922    1.171575
                   AF |   1.042478    .075969     0.57   0.568     .9037267    1.202533
                 COPD |   .6875527   .0466669    -5.52   0.000       .60191     .785381
                   HF |   .8025784   .0724771    -2.44   0.015     .6723872     .957978
             PRIOR_MI |   .7218639   .0989422    -2.38   0.017     .5518047     .944333
                  ckd |   1.188156   .0879615     2.33   0.020     1.027679    1.373693
                  HTN |   1.043771   .0583839     0.77   0.444     .9353903     1.16471
            PRIOR_PCI |   1.916584   .2010008     6.20   0.000     1.560481     2.35395
                      |
          dep_index_n |
                   2  |   .8253887   .0458855    -3.45   0.001     .7401811    .9204052
                   3  |   .2710124   .1578901    -2.24   0.025     .0865136    .8489729
                      |
          inc_group_n |
                   2  |   1.014498   .0564541     0.26   0.796     .9096706    1.131406
                   3  |   1.224613   .1238589     2.00   0.045     1.004402    1.493106
                      |
             gender_n |   1.090328   .1109848     0.85   0.396     .8931272    1.331071
                      |
               race_n |
                   2  |     .55364   .0542791    -6.03   0.000     .4568518    .6709336
                   3  |   .8226046   .0383624    -4.19   0.000     .7507496    .9013369
                      |
             polyvasc |   1.412813   .0885463     5.51   0.000     1.249501     1.59747
              smoking |    .922117   .0422965    -1.77   0.077     .8428346    1.008857
                  vhr |   1.142104   .0806079     1.88   0.060     .9945563    1.311542
                _cons |   .0118919   .0081196    -6.49   0.000     .0031194    .0453354
---------------------------------------------------------------------------------------
Note: _cons estimates baseline odds.

*/

// make a simple code by splitting age into groups and then fit model again...

gen age_gp = .

replace age_gp = 0 if age <= 60 
replace age_gp = 1 if age > 60 & age <= 70
replace age_gp = 2 if age > 70 & age <= 80 
replace age_gp = 3 if age > 80 & age < .

tab age_gp 

/*

     age_gp |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     45,383        8.73        8.73
          1 |    124,329       23.93       32.66
          2 |    226,694       43.63       76.30
          3 |    123,160       23.70      100.00
------------+-----------------------------------
      Total |    519,566      100.00
*/

// fit model using age_gp instead of age only or spline model to make it easier to report 


logit pcsk9i i.age_gp i.condition_n##i.ldl_cat_n DM AF COPD HF PRIOR_MI ckd HTN ///
	PRIOR_PCI i.dep_index_n i.inc_group_n gender_n ///
	i.race_n polyvasc smoking vhr, or

/*
---------------------------------------------------------------------------------------
               pcsk9i | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
               age_gp |
                   1  |   .8609726   .0667552    -1.93   0.054     .7395911    1.002275
                   2  |   1.106876    .081782     1.37   0.169     .9576517    1.279353
                   3  |   .2825339    .030383   -11.75   0.000     .2288414    .3488242
                      |
          condition_n |
                   1  |    .501239    .086188    -4.02   0.000     .3578333    .7021161
                   2  |   .2380129   .0537974    -6.35   0.000      .152829    .3706767
                      |
            ldl_cat_n |
                   2  |   2.921111   .2243934    13.95   0.000     2.512816    3.395748
                   3  |   9.771086   .6694818    33.27   0.000     8.543216    11.17543
                      |
condition_n#ldl_cat_n |
                 1#2  |    .502796   .1277955    -2.71   0.007     .3055217    .8274494
                 1#3  |   .6579858   .1349485    -2.04   0.041     .4401907    .9835405
                 2#2  |     1.1705   .3247193     0.57   0.570     .6795661    2.016096
                 2#3  |   1.427365   .3507661     1.45   0.148     .8817748    2.310535
                      |
                   DM |   1.069313   .0540822     1.33   0.185     .9683981    1.180744
                   AF |     1.0246   .0746019     0.33   0.739     .8883367    1.181764
                 COPD |   .6910232   .0468835    -5.45   0.000     .6049808    .7893029
                   HF |   .8002624   .0722069    -2.47   0.014     .6705471    .9550706
             PRIOR_MI |   .7198421    .098595    -2.40   0.016     .5503644    .9415084
                  ckd |   1.157738   .0856689     1.98   0.048     1.001438    1.338433
                  HTN |   1.032916   .0574604     0.58   0.560     .9262178    1.151905
            PRIOR_PCI |   1.907226    .199881     6.16   0.000     1.553082    2.342123
                      |
          dep_index_n |
                   2  |   .8326839    .046297    -3.29   0.001     .7467128    .9285531
                   3  |   .2762872   .1609609    -2.21   0.027     .0881989    .8654827
                      |
          inc_group_n |
                   2  |   1.012651   .0563514     0.23   0.821     .9080139    1.129346
                   3  |    1.21419   .1227812     1.92   0.055     .9958903    1.480341
                      |
             gender_n |   1.101876   .1121713     0.95   0.341     .9025682    1.345195
                      |
               race_n |
                   2  |    .559156   .0548076    -5.93   0.000     .4614234    .6775891
                   3  |   .8292554   .0386505    -4.02   0.000     .7568589     .908577
                      |
             polyvasc |   1.403084   .0878964     5.41   0.000     1.240966     1.58638
              smoking |   .9417302   .0431463    -1.31   0.190     .8608507    1.030209
                  vhr |   1.162524   .0806239     2.17   0.030     1.014773    1.331787
                _cons |       .002    .000325   -38.24   0.000     .0014545    .0027502
---------------------------------------------------------------------------------------
Note: _cons estimates baseline odds.
*/	

// hosmer lemeshow test

estat gof, group(10)

/*
. estat gof, group(10)
note: obs collapsed on 10 quantiles of estimated probabilities.

Goodness-of-fit test after logistic model
Variable: pcsk9i

 Number of observations = 519,566
       Number of groups =      10
Hosmer???Lemeshow chi2(8) =    2.69
            Prob > chi2 =  0.9521
*/

/************************************************************
//FITTING A GLMM MODEL TO ACCOUNT FOR CENTER LEVEL VARIATION//
*************************************************************/

tab pcsk9i

meologit pcsk9i i.age_gp i.condition_n##i.ldl_cat_n DM AF COPD HF PRIOR_MI ckd HTN ///
	PRIOR_PCI i.dep_index_n i.inc_group_n gender_n ///
	i.race_n polyvasc smoking vhr || Sta3n:, or


	
/* results of the GLMM model. only the fixed effects are important here 
we do not want to discuss the random effects. */

/*
Mixed-effects ologit regression                 Number of obs     =    519,566
Group variable: Sta3n                           Number of groups  =        124

                                                Obs per group:
                                                              min =         77
                                                              avg =    4,190.0
                                                              max =     15,113

Integration method: mvaghermite                 Integration pts.  =          7

                                                Wald chi2(29)     =    2445.25
Log likelihood = -11810.057                     Prob > chi2       =     0.0000
---------------------------------------------------------------------------------------
               pcsk9i | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
               age_gp |
                   1  |   .8575023   .0668446    -1.97   0.049     .7360068    .9990535
                   2  |   1.128496   .0840378     1.62   0.105     .9752409    1.305834
                   3  |   .2899729   .0314328   -11.42   0.000     .2344703    .3586136
                      |
          condition_n |
                   1  |   .5058011   .0870845    -3.96   0.000     .3609335    .7088142
                   2  |   .2435484   .0550774    -6.25   0.000     .1563471    .3793855
                      |
            ldl_cat_n |
                   2  |   2.928073   .2254415    13.95   0.000     2.517939    3.405011
                   3  |   10.01715   .6893539    33.48   0.000     8.753193    11.46361
                      |
condition_n#ldl_cat_n |
                 1#2  |   .4937613   .1255849    -2.77   0.006     .2999297    .8128577
                 1#3  |   .6305665   .1295102    -2.25   0.025     .4216043    .9430977
                 2#2  |   1.161991   .3225175     0.54   0.589     .6744452    2.001975
                 2#3  |    1.40188   .3447789     1.37   0.170     .8656975    2.270156
                      |
                   DM |   1.049207   .0534647     0.94   0.346     .9494812    1.159407
                   AF |   1.019988   .0746181     0.27   0.787     .8837406    1.177241
                 COPD |   .6861065    .046787    -5.52   0.000     .6002695    .7842178
                   HF |   .7845263   .0711544    -2.68   0.007     .6567588      .93715
             PRIOR_MI |   .7556364   .1041829    -2.03   0.042     .5767054    .9900834
                  ckd |   1.159803   .0863984     1.99   0.047     1.002247    1.342127
                  HTN |   1.013038   .0567188     0.23   0.817     .9077532    1.130533
            PRIOR_PCI |   2.123306   .2264099     7.06   0.000     1.722853    2.616838
                      |
          dep_index_n |
                   2  |   .8729645   .0508495    -2.33   0.020     .7787799    .9785397
                   3  |   .3804815    .224446    -1.64   0.101     .1197319    1.209086
                      |
          inc_group_n |
                   2  |    1.13989   .0664274     2.25   0.025     1.016855    1.277812
                   3  |   1.418682   .1534196     3.23   0.001     1.147715    1.753622
                      |
             gender_n |   1.132902   .1161992     1.22   0.224     .9265872    1.385154
                      |
               race_n |
                   2  |   .4932822   .0499768    -6.98   0.000     .4044419    .6016373
                   3  |     .84418   .0408605    -3.50   0.000     .7677764    .9281868
                      |
             polyvasc |   1.381783   .0870433     5.13   0.000     1.221293    1.563364
              smoking |   .9332726   .0433002    -1.49   0.137     .8521501    1.022118
                  vhr |   1.157068   .0804604     2.10   0.036     1.009643    1.326019
----------------------+----------------------------------------------------------------
                /cut1 |   6.692547   .1844723                      6.330988    7.054106
----------------------+----------------------------------------------------------------
Sta3n                 |
            var(_cons)|   .7273797   .1193889                      .5272891    1.003399
---------------------------------------------------------------------------------------
Note: Estimates are transformed only in the first equation to odds ratios.
LR test vs. ologit model: chibar2(01) = 1026.44       Prob >= chibar2 = 0.0000
*/
	
	
contrast rb1.age_gp, nowald effects	or

/*
------------------------------------------------------------------------------
             | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
pcsk9i       |
      age_gp |
   (0 vs 1)  |   1.166178   .0909067     1.97   0.049     1.000947    1.358683
   (2 vs 1)  |   1.316026   .0716355     5.05   0.000     1.182854    1.464193
   (3 vs 1)  |   .3381599   .0322667   -11.36   0.000     .2804799    .4077016
------------------------------------------------------------------------------
*/

contrast rb2.age_gp, nowald effects or

/*
Contrasts of marginal linear predictions

Margins: asbalanced

------------------------------------------------------------------------------
             | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
pcsk9i       |
      age_gp |
   (0 vs 2)  |   .8861354   .0659895    -1.62   0.105     .7657942    1.025388
   (1 vs 2)  |   .7598631   .0413618    -5.05   0.000     .6829702    .8454131
   (3 vs 2)  |   .2569552   .0225573   -15.48   0.000     .2163382     .305198
------------------------------------------------------------------------------
*/

	
contrast r.condition_n@1.ldl_cat_n, nowald effects or	
/*
Margins: asbalanced

---------------------------------------------------------------------------------------
                      | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
pcsk9i                |
condition_n@ldl_cat_n |
          (1 vs 0) 1  |   .5058011   .0870845    -3.96   0.000     .3609335    .7088142
          (2 vs 0) 1  |   .2435484   .0550774    -6.25   0.000     .1563471    .3793855
---------------------------------------------------------------------------------------
 */
 
 

/* present both as that would present the picture of how 
younger patients are not getting the medications while most 
of drug initiation is by older patients */

/*
. contrast rb1.age_gp, nowald effects     or

Contrasts of marginal linear predictions

Margins: asbalanced

------------------------------------------------------------------------------
             | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
      age_gp |
   (0 vs 1)  |   1.161477   .0900548     1.93   0.054       .99773    1.352098
   (2 vs 1)  |   1.285611   .0694646     4.65   0.000     1.156424     1.42923
   (3 vs 1)  |   .3281567   .0310751   -11.77   0.000     .2725687    .3950814
------------------------------------------------------------------------------

. 
end of do-file

. do "D:\Temp\STATA\VHACLEDeoS\STDa984_000000.tmp"

. contrast rb2.age_gp, nowald effects or 

Contrasts of marginal linear predictions

Margins: asbalanced

------------------------------------------------------------------------------
             | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
      age_gp |
   (0 vs 2)  |   .9034436   .0667513    -1.37   0.169     .7816452    1.044221
   (1 vs 2)  |   .7778402   .0420286    -4.65   0.000     .6996775    .8647346
   (3 vs 2)  |   .2552535   .0222888   -15.64   0.000      .215102    .3028997
------------------------------------------------------------------------------

. 
end of do-file
*/

contrast r.condition_n@2.ldl_cat_n, nowald effects or 	

/*
Margins: asbalanced

---------------------------------------------------------------------------------------
                      | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
pcsk9i                |
condition_n@ldl_cat_n |
          (1 vs 0) 2  |    .249745   .0474478    -7.30   0.000     .1721002    .3624202
          (2 vs 0) 2  |    .283001   .0459485    -7.77   0.000     .2058663    .3890367
---------------------------------------------------------------------------------------
*/

contrast r.condition_n@3.ldl_cat_n, nowald effects or 	

/*
Margins: asbalanced

---------------------------------------------------------------------------------------
                      | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
pcsk9i                |
condition_n@ldl_cat_n |
          (1 vs 0) 3  |   .3189412   .0372463    -9.79   0.000     .2536918    .4009728
          (2 vs 0) 3  |   .3414257   .0337819   -10.86   0.000     .2812388     .414493
---------------------------------------------------------------------------------------
*/












// see if we should further split age into 5 point periods.

gen age_gp5 = .

replace age_gp5 = 0 if age <= 50
replace age_gp5 = 1 if age > 50 & age <= 55
replace age_gp5 = 2 if age > 55 & age <= 60
replace age_gp5 = 3 if age > 60 & age <= 65
replace age_gp5 = 4 if age > 65 & age <= 70
replace age_gp5 = 5 if age > 70 & age <= 75
replace age_gp5 = 6 if age > 75 & age <= 80
replace age_gp5 = 7 if age > 80 & age <= 85
replace age_gp5 = 8 if age > 85 & age < .

tab age_gp5


logit pcsk9i i.age_gp5 i.condition_n##i.ldl_cat_n DM AF COPD HF PRIOR_MI ckd HTN ///
	PRIOR_PCI i.dep_index_n i.inc_group_n gender_n ///
	i.race_n polyvasc smoking vhr, or
	
	
	
/*
Logistic regression                                    Number of obs = 519,566
                                                       LR chi2(34)   = 2962.07
                                                       Prob > chi2   =  0.0000
Log likelihood = -12270.484                            Pseudo R2     =  0.1077

---------------------------------------------------------------------------------------
               pcsk9i | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
              age_gp5 |
                   1  |   .6375305   .1129958    -2.54   0.011     .4504372     .902335
                   2  |   .8327451   .1215241    -1.25   0.210     .6255969    1.108484
                   3  |   .6601017   .0920733    -2.98   0.003     .5022063    .8676398
                   4  |   .7320155   .0978136    -2.33   0.020     .5633532    .9511736
                   5  |   .9741167   .1243654    -0.21   0.837     .7584695    1.251076
                   6  |   .7669641   .1033411    -1.97   0.049     .5889572    .9987718
                   7  |    .436536   .0675685    -5.36   0.000     .3223058    .5912511
                   8  |   .0884382   .0185857   -11.54   0.000     .0585809     .133513
                      |
          condition_n |
                   1  |   .5018692   .0863213    -4.01   0.000     .3582484    .7030672
                   2  |   .2382452   .0538514    -6.35   0.000     .1529763    .3710429
                      |
            ldl_cat_n |
                   2  |    2.92357   .2250169    13.94   0.000     2.514199    3.399598
                   3  |    9.74913   .6698561    33.14   0.000       8.5208    11.15453
                      |
condition_n#ldl_cat_n |
                 1#2  |   .5037042   .1280334    -2.70   0.007     .3060653    .8289668
                 1#3  |   .6599827   .1353708    -2.03   0.043     .4415098     .986563
                 2#2  |   1.172047   .3251563     0.57   0.567     .6804557    2.018787
                 2#3  |   1.430427   .3515332     1.46   0.145     .8836486    2.315538
                      |
                   DM |   1.062215   .0538444     1.19   0.234     .9617548    1.173168
                   AF |   1.038816   .0756885     0.52   0.601     .9005747    1.198277
                 COPD |   .6899199   .0468272    -5.47   0.000     .6039831    .7880841
                   HF |   .8040779   .0726096    -2.41   0.016     .6736482    .9597609
             PRIOR_MI |   .7195343   .0986136    -2.40   0.016     .5500379    .9412617
                  ckd |    1.18233   .0875295     2.26   0.024     1.022641    1.366955
                  HTN |   1.039433   .0581319     0.69   0.489     .9315187    1.159848
            PRIOR_PCI |   1.915759   .2008875     6.20   0.000     1.559852    2.352872
                      |
          dep_index_n |
                   2  |   .8302839   .0461668    -3.34   0.001     .7445549    .9258839
                   3  |   .2728599   .1589731    -2.23   0.026     .0870992     .854801
                      |
          inc_group_n |
                   2  |   1.011864   .0563142     0.21   0.832     .9072969    1.128482
                   3  |   1.222299   .1236262     1.98   0.047     1.002501    1.490287
                      |
             gender_n |   1.106405   .1127407     0.99   0.321     .9061046    1.350984
                      |
               race_n |
                   2  |   .5581876   .0547309    -5.95   0.000     .4605947     .676459
                   3  |    .826329   .0385397    -4.09   0.000     .7541423    .9054255
                      |
             polyvasc |   1.411251   .0884682     5.50   0.000     1.248086    1.595748
              smoking |   .9266894   .0424818    -1.66   0.097     .8470576    1.013807
                  vhr |   1.148428   .0811257     1.96   0.050     .9999411    1.318965
                _cons |   .0024717   .0004744   -31.27   0.000     .0016967    .0036006
---------------------------------------------------------------------------------------
*/	

est store m_5	

lrtest m4 m_5
	
contrast rb3.age_gp5, nowald or effects

/*
------------------------------------------------------------------------------
             | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
     age_gp5 |
     < 50    |   1.514918   .2113062     2.98   0.003     1.152552    1.991213
   (1 vs 3)  |   .9658066   .1458096    -0.23   0.818     .7184271    1.298367
   (2 vs 3)  |   1.261541   .1412415     2.08   0.038     1.012981    1.571091
   (4 vs 3)  |   1.108944   .1022362     1.12   0.262      .925625    1.328568
   (5 vs 3)  |   1.475707   .1227504     4.68   0.000     1.253709    1.737016
   (6 vs 3)  |   1.161888   .1088755     1.60   0.109     .9669449    1.396132
   (7 vs 3)  |   .6613163   .0797975    -3.43   0.001     .5220346     .837759
   (8 vs 3)  |   .1339766   .0249988   -10.77   0.000       .09294    .1931324
------------------------------------------------------------------------------

*/

// now to understand the meaning of the interactions 


logit pcsk9i i.age_gp i.condition_n##i.ldl_cat_n DM AF COPD HF PRIOR_MI ckd HTN ///
	PRIOR_PCI i.dep_index_n i.inc_group_n gender_n ///
	i.race_n polyvasc smoking vhr, or

	
contrast r.condition_n@1.ldl_cat_n, nowald effects or	

/*
---------------------------------------------------------------------------------------
                      | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
condition_n@ldl_cat_n |
          (1 vs 0) 1  |    .501239    .086188    -4.02   0.000     .3578333    .7021161
          (2 vs 0) 1  |   .2380129   .0537974    -6.35   0.000      .152829    .3706767
---------------------------------------------------------------------------------------
*/

contrast r.condition_n@2.ldl_cat_n, nowald effects or 	

/*

---------------------------------------------------------------------------------------
                      | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
condition_n@ldl_cat_n |
          (1 vs 0) 2  |   .2520209   .0478162    -7.26   0.000      .173755    .3655409
          (2 vs 0) 2  |   .2785941    .045171    -7.88   0.000      .202749    .3828116
---------------------------------------------------------------------------------------
*/

contrast r.condition_n@3.ldl_cat_n, nowald effects or 

/*
Margins: asbalanced

---------------------------------------------------------------------------------------
                      | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
----------------------+----------------------------------------------------------------
condition_n@ldl_cat_n |
          (1 vs 0) 3  |   .3298082   .0383651    -9.54   0.000     .2625698    .4142647
          (2 vs 0) 3  |   .3397314   .0334792   -10.96   0.000     .2800614    .4121148
---------------------------------------------------------------------------------------
*/

save "P:/ORD_Deo_202010005D/LIPID_STUDY/ALIROCUMAB/datasets/model_stata_mod.dta", replace // save this dataset 


	
