/*

#########################################################
# PCSK9I USE IN A LARGE OBSERVATIONAL COHORT   ##########
#########################################################

AUTHOR: SVD

DATE: 11/12/2021

STUDY: PCSK9I USE IN A LARGE OBSERVATIONAL COHORT 

MAIN PURPOSE: TO CREATE A COHORT OF PATIENTS WITH A PRIMARY DIAGNOSIS OF PAD, CAD, CVD VISITING 
OUTPATIENT VA CLINICS BETWEEN 2016-01-01 AND 2019-01-01

FURTHER DETAILS: CREATE COHORT, GET CLINICAL CHARACTERISTICS OF PATIENTS

DB: ORD_DEO_20210005D

VIEWS USED: 


VIEWS CREATED: 


TABLES CREATED: 
DFLT.ALI_AGE_VITALS
DFLT.OUTPAT_ALI_BASECOHORT
DFLT.ALI_SEC_DIAG
DFLT.ALI_BP
DFLT.ALI_HEIGHT_TABLE
DFLT.ALI_WEIGHT_TABLE
DFLT.ALI_ADD_DIAG
DFLT.ALI_GENDER -- not useful here -- need another way to identify gender
DFLT.ALI_CKD_DIAG

------------------------------------------------------------ */

USE ORD_Deo_202010005D

-- we can get the icdsid from the frailty score code.

/* cad */

select top 10*
from CDWWork.Dim.ICD10
where ICD10Code like 'I25%'

SELECT 
	DISTINCT a.ICD10SID, a.ICD10Code,	
	'CAD' as 'condition'

into #cadicd

FROM
	CDWWork.Dim.ICD10 as a 
WHERE
ICD10Code like 'I20.0%' OR
ICD10Code like 'I20.0%' OR
ICD10Code like 'I21.01%' OR
ICD10Code like 'I21.02%' OR
ICD10Code like 'I21.09%' OR
ICD10Code like 'I21.11%' OR
ICD10Code like 'I21.19%' OR
ICD10Code like 'I21.21%' OR
ICD10Code like 'I21.29%' OR
ICD10Code like 'I21.3%' OR
ICD10Code like 'I21.4%' OR
ICD10Code like 'I21.9%' OR
ICD10Code like 'I21.A1%' OR
ICD10Code like 'I21.A9%' OR
ICD10Code like 'I22.0%' OR
ICD10Code like 'I22.1%' OR
ICD10Code like 'I22.2%' OR
ICD10Code like 'I22.8%' OR
ICD10Code like 'I22.9%' OR
ICD10Code like 'I23.5%' OR
ICD10Code like 'I23.0%' OR
ICD10Code like 'I23.1%' OR
ICD10Code like 'I23.2%' OR
ICD10Code like 'I23.3%' OR
ICD10Code like 'I23.4%' OR
ICD10Code like 'I23.6%' OR
ICD10Code like 'I23.7%' OR
ICD10Code like 'I23.8%' OR
ICD10Code like 'I24.0%' OR
ICD10Code like 'I24.1%' OR
ICD10Code like 'I24.8%' OR
ICD10Code like 'I24.9%' OR
ICD10Code like 'I25.0%' OR
ICD10Code like 'I25.9%' OR
ICD10Code like 'I25.10%' OR
ICD10Code like 'I251.10%' OR
ICD10Code like 'I251.11%' OR
ICD10Code like 'I251.18%' OR
ICD10Code like 'I25.119%' OR
ICD10Code like 'I25.2%' OR
ICD10Code like 'I25.3%' OR
ICD10Code like 'I25.41%' OR
ICD10Code like 'I25.42%' OR
ICD10Code like 'I25.5%' OR
ICD10Code like 'I25.6%' OR
ICD10Code like 'I25.700%' OR
ICD10Code like 'I25.701%' OR
ICD10Code like 'I25.708%' OR
ICD10Code like 'I25.709%' OR
ICD10Code like 'I25.710%' OR
ICD10Code like 'I25.711%' OR
ICD10Code like 'I25.718%' OR
ICD10Code like 'I25.719%' OR
ICD10Code like 'I25.720%' OR
ICD10Code like 'I25.721%' OR
ICD10Code like 'I25.728%' OR
ICD10Code like 'I25.729%' OR
ICD10Code like 'I25.730%' OR
ICD10Code like 'I25.731%' OR
ICD10Code like 'I25.738%' OR
ICD10Code like 'I25.739%' OR
ICD10Code like 'I25.750%' OR
ICD10Code like 'I25.751%' OR
ICD10Code like 'I25.758%' OR
ICD10Code like 'I25.759%' OR
ICD10Code like 'I25.760%' OR
ICD10Code like 'I25.761%' OR
ICD10Code like 'I25.768%' OR
ICD10Code like 'I25.769%' OR
ICD10Code like 'I25.790%' OR
ICD10Code like 'I25.791%' OR
ICD10Code like 'I25.798%' OR
ICD10Code like 'I25.799%' OR
ICD10Code like 'I25.810%' OR
ICD10Code like 'I25.811%' OR
ICD10Code like 'I25.812%' OR
ICD10Code like 'I25.82%' OR
ICD10Code like 'I25.83%' OR
ICD10Code like 'I25.84%' OR
ICD10Code like 'I25.89%' OR
ICD10Code like 'I25.9%' OR
ICD10Code like 'I51.0%' OR
ICD10Code like 'I51.1%' OR
ICD10Code like 'Z95.5%' OR
ICD10Code like 'Z98.61%' 

/* cvd */


SELECT 
	DISTINCT a.ICD10SID, a.ICD10Code,
	'CVA' as 'condition'

into #cvdsid

FROM
	CDWWork.dim.ICD10 as a 
WHERE
ICD10Code like 'G45.0%' OR
ICD10Code like 'G45.1%' OR
ICD10Code like 'G45.2%' OR
ICD10Code like 'G45.3%' OR
ICD10Code like 'G45.8%' OR
ICD10Code like 'G45.9%' OR
ICD10Code like 'G46.0%' OR
ICD10Code like 'G46.1%' OR
ICD10Code like 'G46.2%' OR
ICD10Code like 'G46.3%' OR
ICD10Code like 'G46.4%' OR
ICD10Code like 'G46.5%' OR
ICD10Code like 'G46.6%' OR
ICD10Code like 'G46.7%' OR
ICD10Code like 'G46.8%' OR
ICD10Code like 'H34.00%' OR
ICD10Code like 'H34.01%' OR
ICD10Code like 'H34.02%' OR
ICD10Code like 'H34.03%' OR
ICD10Code like 'I60.00%' OR
ICD10Code like 'I60.01%' OR
ICD10Code like 'I60.02%' OR
ICD10Code like 'I60.10%' OR
ICD10Code like 'I60.11%' OR
ICD10Code like 'I60.12%' OR
ICD10Code like 'I60.20%' OR
ICD10Code like 'I60.21%' OR
ICD10Code like 'I60.22%' OR
ICD10Code like 'I60.30%' OR
ICD10Code like 'I60.31%' OR
ICD10Code like 'I60.32%' OR
ICD10Code like 'I60.4%' OR
ICD10Code like 'I60.50%' OR
ICD10Code like 'I60.51%' OR
ICD10Code like 'I60.52%' OR
ICD10Code like 'I60.6%' OR
ICD10Code like 'I60.7%' OR
ICD10Code like 'I60.8%' OR
ICD10Code like 'I60.9%' OR
ICD10Code like 'I61.0%' OR
ICD10Code like 'I61.1%' OR
ICD10Code like 'I61.2%' OR
ICD10Code like 'I61.3%' OR
ICD10Code like 'I61.4%' OR
ICD10Code like 'I61.5%' OR
ICD10Code like 'I61.6%' OR
ICD10Code like 'I61.8%' OR
ICD10Code like 'I61.9%' OR
ICD10Code like 'I63.00%' OR
ICD10Code like 'I63.011%' OR
ICD10Code like 'I63.012%' OR
ICD10Code like 'I63.013%' OR
ICD10Code like 'I63.019%' OR
ICD10Code like 'I63.02%' OR
ICD10Code like 'I63.031%' OR
ICD10Code like 'I63.032%' OR
ICD10Code like 'I63.033%' OR
ICD10Code like 'I63.039%' OR
ICD10Code like 'I63.09%' OR
ICD10Code like 'I63.10%' OR
ICD10Code like 'I63.111%' OR
ICD10Code like 'I63.112%' OR
ICD10Code like 'I63.113%' OR
ICD10Code like 'I63.119%' OR
ICD10Code like 'I63.12%' OR
ICD10Code like 'I63.131%' OR
ICD10Code like 'I63.132%' OR
ICD10Code like 'I63.133%' OR
ICD10Code like 'I63.139%' OR
ICD10Code like 'I63.19%' OR
ICD10Code like 'I63.20%' OR
ICD10Code like 'I63.211%' OR
ICD10Code like 'I63.212%' OR
ICD10Code like 'I63.213%' OR
ICD10Code like 'I63.219%' OR
ICD10Code like 'I63.22%' OR
ICD10Code like 'I63.231%' OR
ICD10Code like 'I63.232%' OR
ICD10Code like 'I63.233%' OR
ICD10Code like 'I63.239%' OR
ICD10Code like 'I63.29%' OR
ICD10Code like 'I63.30%' OR
ICD10Code like 'I63.311%' OR
ICD10Code like 'I63.312%' OR
ICD10Code like 'I63.313%' OR
ICD10Code like 'I63.319%' OR
ICD10Code like 'I63.321%' OR
ICD10Code like 'I63.322%' OR
ICD10Code like 'I63.323%' OR
ICD10Code like 'I63.329%' OR
ICD10Code like 'I63.331%' OR
ICD10Code like 'I63.332%' OR
ICD10Code like 'I63.333%' OR
ICD10Code like 'I63.339%' OR
ICD10Code like 'I63.341%' OR
ICD10Code like 'I63.342%' OR
ICD10Code like 'I63.343%' OR
ICD10Code like 'I63.349%' OR
ICD10Code like 'I63.39%' OR
ICD10Code like 'I63.40%' OR
ICD10Code like 'I63.411%' OR
ICD10Code like 'I63.412%' OR
ICD10Code like 'I63.413%' OR
ICD10Code like 'I63.419%' OR
ICD10Code like 'I63.421%' OR
ICD10Code like 'I63.422%' OR
ICD10Code like 'I63.423%' OR
ICD10Code like 'I63.429%' OR
ICD10Code like 'I63.431%' OR
ICD10Code like 'I63.432%' OR
ICD10Code like 'I63.433%' OR
ICD10Code like 'I63.439%' OR
ICD10Code like 'I63.441%' OR
ICD10Code like 'I63.442%' OR
ICD10Code like 'I63.443%' OR
ICD10Code like 'I63.449%' OR
ICD10Code like 'I63.49%' OR
ICD10Code like 'I63.50%' OR
ICD10Code like 'I63.511%' OR
ICD10Code like 'I63.512%' OR
ICD10Code like 'I63.513%' OR
ICD10Code like 'I63.519%' OR
ICD10Code like 'I63.521%' OR
ICD10Code like 'I63.522%' OR
ICD10Code like 'I63.523%' OR
ICD10Code like 'I63.529%' OR
ICD10Code like 'I63.531%' OR
ICD10Code like 'I63.532%' OR
ICD10Code like 'I63.533%' OR
ICD10Code like 'I63.539%' OR
ICD10Code like 'I63.541%' OR
ICD10Code like 'I63.542%' OR
ICD10Code like 'I63.543%' OR
ICD10Code like 'I63.549%' OR
ICD10Code like 'I63.59%' OR
ICD10Code like 'I63.6%' OR
ICD10Code like 'I63.8%' OR
ICD10Code like 'I63.9%' OR
ICD10Code like 'I64%' OR
ICD10Code like 'I65.8%' OR
ICD10Code like 'I65.01%' OR
ICD10Code like 'I65.02%' OR
ICD10Code like 'I65.03%' OR
ICD10Code like 'I65.09%' OR
ICD10Code like 'I65.1%' OR
ICD10Code like 'I65.21%' OR
ICD10Code like 'I65.22%' OR
ICD10Code like 'I65.23%' OR
ICD10Code like 'I65.29%' OR
ICD10Code like 'I65.8%' OR
ICD10Code like 'I65.9%' OR
ICD10Code like 'I66.4%' OR
ICD10Code like 'I66.01%' OR
ICD10Code like 'I66.02%' OR
ICD10Code like 'I66.03%' OR
ICD10Code like 'I66.09%' OR
ICD10Code like 'I66.11%' OR
ICD10Code like 'I66.12%' OR
ICD10Code like 'I66.13%' OR
ICD10Code like 'I66.19%' OR
ICD10Code like 'I66.21%' OR
ICD10Code like 'I66.22%' OR
ICD10Code like 'I66.23%' OR
ICD10Code like 'I66.29%' OR
ICD10Code like 'I66.3%' OR
ICD10Code like 'I66.8%' OR
ICD10Code like 'I66.9%' OR
ICD10Code like 'I67.2%' OR
ICD10Code like 'I67.81%' OR
ICD10Code like 'I67.82%' OR
ICD10Code like 'I67.841%' OR
ICD10Code like 'I67.848%' OR
ICD10Code like 'I67.89%' OR
ICD10Code like 'I69.4%' OR
ICD10Code like 'I69.00%' OR
ICD10Code like 'I69.010%' OR
ICD10Code like 'I69.011%' OR
ICD10Code like 'I69.012%' OR
ICD10Code like 'I69.013%' OR
ICD10Code like 'I69.014%' OR
ICD10Code like 'I69.015%' OR
ICD10Code like 'I69.018%' OR
ICD10Code like 'I69.019%' OR
ICD10Code like 'I69.020%' OR
ICD10Code like 'I69.021%' OR
ICD10Code like 'I69.022%' OR
ICD10Code like 'I69.023%' OR
ICD10Code like 'I69.028%' OR
ICD10Code like 'I69.031%' OR
ICD10Code like 'I69.032%' OR
ICD10Code like 'I69.033%' OR
ICD10Code like 'I69.034%' OR
ICD10Code like 'I69.039%' OR
ICD10Code like 'I69.041%' OR
ICD10Code like 'I69.042%' OR
ICD10Code like 'I69.043%' OR
ICD10Code like 'I69.044%' OR
ICD10Code like 'I69.049%' OR
ICD10Code like 'I69.051%' OR
ICD10Code like 'I69.052%' OR
ICD10Code like 'I69.053%' OR
ICD10Code like 'I69.054%' OR
ICD10Code like 'I69.059%' OR
ICD10Code like 'I69.061%' OR
ICD10Code like 'I69.062%' OR
ICD10Code like 'I69.063%' OR
ICD10Code like 'I69.064%' OR
ICD10Code like 'I69.065%' OR
ICD10Code like 'I69.069%' OR
ICD10Code like 'I69.090%' OR
ICD10Code like 'I69.091%' OR
ICD10Code like 'I69.098%' OR
ICD10Code like 'I69.10%' OR
ICD10Code like 'I69.110%' OR
ICD10Code like 'I69.111%' OR
ICD10Code like 'I69.112%' OR
ICD10Code like 'I69.113%' OR
ICD10Code like 'I69.114%' OR
ICD10Code like 'I69.115%' OR
ICD10Code like 'I69.118%' OR
ICD10Code like 'I69.119%' OR
ICD10Code like 'I69.120%' OR
ICD10Code like 'I69.121%' OR
ICD10Code like 'I69.122%' OR
ICD10Code like 'I69.123%' OR
ICD10Code like 'I69.128%' OR
ICD10Code like 'I69.131%' OR
ICD10Code like 'I69.132%' OR
ICD10Code like 'I69.133%' OR
ICD10Code like 'I69.134%' OR
ICD10Code like 'I69.139%' OR
ICD10Code like 'I69.141%' OR
ICD10Code like 'I69.142%' OR
ICD10Code like 'I69.143%' OR
ICD10Code like 'I69.144%' OR
ICD10Code like 'I69.149%' OR
ICD10Code like 'I69.151%' OR
ICD10Code like 'I69.152%' OR
ICD10Code like 'I69.153%' OR
ICD10Code like 'I69.154%' OR
ICD10Code like 'I69.159%' OR
ICD10Code like 'I69.161%' OR
ICD10Code like 'I69.162%' OR
ICD10Code like 'I69.163%' OR
ICD10Code like 'I69.164%' OR
ICD10Code like 'I69.165%' OR
ICD10Code like 'I69.169%' OR
ICD10Code like 'I69.190%' OR
ICD10Code like 'I69.191%' OR
ICD10Code like 'I69.198%' OR
ICD10Code like 'I69.20%' OR
ICD10Code like 'I69.210%' OR
ICD10Code like 'I69.211%' OR
ICD10Code like 'I69.212%' OR
ICD10Code like 'I69.213%' OR
ICD10Code like 'I69.214%' OR
ICD10Code like 'I69.215%' OR
ICD10Code like 'I69.218%' OR
ICD10Code like 'I69.219%' OR
ICD10Code like 'I69.220%' OR
ICD10Code like 'I69.221%' OR
ICD10Code like 'I69.222%' OR
ICD10Code like 'I69.223%' OR
ICD10Code like 'I69.228%' OR
ICD10Code like 'I69.231%' OR
ICD10Code like 'I69.232%' OR
ICD10Code like 'I69.233%' OR
ICD10Code like 'I69.234%' OR
ICD10Code like 'I69.239%' OR
ICD10Code like 'I69.241%' OR
ICD10Code like 'I69.242%' OR
ICD10Code like 'I69.243%' OR
ICD10Code like 'I69.244%' OR
ICD10Code like 'I69.249%' OR
ICD10Code like 'I69.251%' OR
ICD10Code like 'I69.252%' OR
ICD10Code like 'I69.253%' OR
ICD10Code like 'I69.254%' OR
ICD10Code like 'I69.259%' OR
ICD10Code like 'I69.261%' OR
ICD10Code like 'I69.262%' OR
ICD10Code like 'I69.263%' OR
ICD10Code like 'I69.264%' OR
ICD10Code like 'I69.265%' OR
ICD10Code like 'I69.269%' OR
ICD10Code like 'I69.290%' OR
ICD10Code like 'I69.291%' OR
ICD10Code like 'I69.298%' OR
ICD10Code like 'I69.30%' OR
ICD10Code like 'I69.310%' OR
ICD10Code like 'I69.311%' OR
ICD10Code like 'I69.312%' OR
ICD10Code like 'I69.313%' OR
ICD10Code like 'I69.314%' OR
ICD10Code like 'I69.315%' OR
ICD10Code like 'I69.318%' OR
ICD10Code like 'I69.319%' OR
ICD10Code like 'I69.320%' OR
ICD10Code like 'I69.321%' OR
ICD10Code like 'I69.322%' OR
ICD10Code like 'I69.323%' OR
ICD10Code like 'I69.328%' OR
ICD10Code like 'I69.331%' OR
ICD10Code like 'I69.332%' OR
ICD10Code like 'I69.333%' OR
ICD10Code like 'I69.334%' OR
ICD10Code like 'I69.339%' OR
ICD10Code like 'I69.341%' OR
ICD10Code like 'I69.342%' OR
ICD10Code like 'I69.343%' OR
ICD10Code like 'I69.344%' OR
ICD10Code like 'I69.349%' OR
ICD10Code like 'I69.351%' OR
ICD10Code like 'I69.352%' OR
ICD10Code like 'I69.353%' OR
ICD10Code like 'I69.354%' OR
ICD10Code like 'I69.359%' OR
ICD10Code like 'I69.361%' OR
ICD10Code like 'I69.362%' OR
ICD10Code like 'I69.363%' OR
ICD10Code like 'I69.364%' OR
ICD10Code like 'I69.365%' OR
ICD10Code like 'I69.369%' OR
ICD10Code like 'I69.390%' OR
ICD10Code like 'I69.391%' OR
ICD10Code like 'I69.398%' OR
ICD10Code like 'I69.80%' OR
ICD10Code like 'I69.810%' OR
ICD10Code like 'I69.811%' OR
ICD10Code like 'I69.812%' OR
ICD10Code like 'I69.813%' OR
ICD10Code like 'I69.814%' OR
ICD10Code like 'I69.815%' OR
ICD10Code like 'I69.818%' OR
ICD10Code like 'I69.819%' OR
ICD10Code like 'I69.820%' OR
ICD10Code like 'I69.821%' OR
ICD10Code like 'I69.822%' OR
ICD10Code like 'I69.823%' OR
ICD10Code like 'I69.828%' OR
ICD10Code like 'I69.831%' OR
ICD10Code like 'I69.832%' OR
ICD10Code like 'I69.833%' OR
ICD10Code like 'I69.834%' OR
ICD10Code like 'I69.839%' OR
ICD10Code like 'I69.841%' OR
ICD10Code like 'I69.842%' OR
ICD10Code like 'I69.843%' OR
ICD10Code like 'I69.844%' OR
ICD10Code like 'I69.849%' OR
ICD10Code like 'I69.851%' OR
ICD10Code like 'I69.852%' OR
ICD10Code like 'I69.853%' OR
ICD10Code like 'I69.854%' OR
ICD10Code like 'I69.859%' OR
ICD10Code like 'I69.861%' OR
ICD10Code like 'I69.862%' OR
ICD10Code like 'I69.863%' OR
ICD10Code like 'I69.864%' OR
ICD10Code like 'I69.865%' OR
ICD10Code like 'I69.869%' OR
ICD10Code like 'I69.890%' OR
ICD10Code like 'I69.891%' OR
ICD10Code like 'I69.898%' OR
ICD10Code like 'I69.90%' OR
ICD10Code like 'I69.910%' OR
ICD10Code like 'I69.911%' OR
ICD10Code like 'I69.912%' OR
ICD10Code like 'I69.913%' OR
ICD10Code like 'I69.914%' OR
ICD10Code like 'I69.915%' OR
ICD10Code like 'I69.918%' OR
ICD10Code like 'I69.919%' OR
ICD10Code like 'I69.920%' OR
ICD10Code like 'I69.921%' OR
ICD10Code like 'I69.922%' OR
ICD10Code like 'I69.923%' OR
ICD10Code like 'I69.928%' OR
ICD10Code like 'I69.931%' OR
ICD10Code like 'I69.932%' OR
ICD10Code like 'I69.933%' OR
ICD10Code like 'I69.934%' OR
ICD10Code like 'I69.939%' OR
ICD10Code like 'I69.941%' OR
ICD10Code like 'I69.942%' OR
ICD10Code like 'I69.943%' OR
ICD10Code like 'I69.944%' OR
ICD10Code like 'I69.949%' OR
ICD10Code like 'I69.951%' OR
ICD10Code like 'I69.952%' OR
ICD10Code like 'I69.953%' OR
ICD10Code like 'I69.954%' OR
ICD10Code like 'I69.959%' OR
ICD10Code like 'I69.961%' OR
ICD10Code like 'I69.962%' OR
ICD10Code like 'I69.963%' OR
ICD10Code like 'I69.964%' OR
ICD10Code like 'I69.965%' OR
ICD10Code like 'I69.969%' OR
ICD10Code like 'I69.990%' OR
ICD10Code like 'I69.991%' OR
ICD10Code like 'I69.998%' OR
ICD10Code like 'I97.810%' OR
ICD10Code like 'I97.811%' OR
ICD10Code like 'I97.820%' OR
ICD10Code like 'I97.821%' 

/* pad */


SELECT 
	DISTINCT ICD10SID, ICD10Code,	
	'PVD' as 'condition'

into #padicd

FROM
	CDWWork.dim.ICD10
WHERE

ICD10Code like 'E09.51%' OR
ICD10Code like 'E09.52%' OR
ICD10Code like 'E10.51%' OR
ICD10Code like 'E10.52%' OR
ICD10Code like 'E11.51%' OR
ICD10Code like 'E11.52%' OR
ICD10Code like 'E13.51%' OR
ICD10Code like 'E13.52%' OR
ICD10Code like 'I67.0%' OR
ICD10Code like 'I70.0%' OR
ICD10Code like 'I70.1%' OR
ICD10Code like 'I70.201%' OR
ICD10Code like 'I70.202%' OR
ICD10Code like 'I70.203%' OR
ICD10Code like 'I70.208%' OR
ICD10Code like 'I70.209%' OR
ICD10Code like 'I70.211%' OR
ICD10Code like 'I70.212%' OR
ICD10Code like 'I70.213%' OR
ICD10Code like 'I70.218%' OR
ICD10Code like 'I70.219%' OR
ICD10Code like 'I70.221%' OR
ICD10Code like 'I70.222%' OR
ICD10Code like 'I70.223%' OR
ICD10Code like 'I70.228%' OR
ICD10Code like 'I70.229%' OR
ICD10Code like 'I70.231%' OR
ICD10Code like 'I70.232%' OR
ICD10Code like 'I70.233%' OR
ICD10Code like 'I70.234%' OR
ICD10Code like 'I70.235%' OR
ICD10Code like 'I70.238%' OR
ICD10Code like 'I70.239%' OR
ICD10Code like 'I70.241%' OR
ICD10Code like 'I70.242%' OR
ICD10Code like 'I70.243%' OR
ICD10Code like 'I70.244%' OR
ICD10Code like 'I70.245%' OR
ICD10Code like 'I70.248%' OR
ICD10Code like 'I70.249%' OR
ICD10Code like 'I70.25%' OR
ICD10Code like 'I70.261%' OR
ICD10Code like 'I70.262%' OR
ICD10Code like 'I70.263%' OR
ICD10Code like 'I70.268%' OR
ICD10Code like 'I70.269%' OR
ICD10Code like 'I70.291%' OR
ICD10Code like 'I70.292%' OR
ICD10Code like 'I70.293%' OR
ICD10Code like 'I70.298%' OR
ICD10Code like 'I70.299%' OR
ICD10Code like 'I70.301%' OR
ICD10Code like 'I70.302%' OR
ICD10Code like 'I70.303%' OR
ICD10Code like 'I70.308%' OR
ICD10Code like 'I70.309%' OR
ICD10Code like 'I70.311%' OR
ICD10Code like 'I70.312%' OR
ICD10Code like 'I70.313%' OR
ICD10Code like 'I70.318%' OR
ICD10Code like 'I70.319%' OR
ICD10Code like 'I70.321%' OR
ICD10Code like 'I70.322%' OR
ICD10Code like 'I70.323%' OR
ICD10Code like 'I70.328%' OR
ICD10Code like 'I70.329%' OR
ICD10Code like 'I70.331%' OR
ICD10Code like 'I70.332%' OR
ICD10Code like 'I70.333%' OR
ICD10Code like 'I70.334%' OR
ICD10Code like 'I70.335%' OR
ICD10Code like 'I70.338%' OR
ICD10Code like 'I70.339%' OR
ICD10Code like 'I70.341%' OR
ICD10Code like 'I70.342%' OR
ICD10Code like 'I70.343%' OR
ICD10Code like 'I70.344%' OR
ICD10Code like 'I70.345%' OR
ICD10Code like 'I70.348%' OR
ICD10Code like 'I70.349%' OR
ICD10Code like 'I70.35%' OR
ICD10Code like 'I70.361%' OR
ICD10Code like 'I70.362%' OR
ICD10Code like 'I70.363%' OR
ICD10Code like 'I70.368%' OR
ICD10Code like 'I70.369%' OR
ICD10Code like 'I70.391%' OR
ICD10Code like 'I70.392%' OR
ICD10Code like 'I70.393%' OR
ICD10Code like 'I70.398%' OR
ICD10Code like 'I70.399%' OR
ICD10Code like 'I70.401%' OR
ICD10Code like 'I70.402%' OR
ICD10Code like 'I70.403%' OR
ICD10Code like 'I70.408%' OR
ICD10Code like 'I70.409%' OR
ICD10Code like 'I70.411%' OR
ICD10Code like 'I70.412%' OR
ICD10Code like 'I70.413%' OR
ICD10Code like 'I70.418%' OR
ICD10Code like 'I70.419%' OR
ICD10Code like 'I70.421%' OR
ICD10Code like 'I70.422%' OR
ICD10Code like 'I70.423%' OR
ICD10Code like 'I70.428%' OR
ICD10Code like 'I70.429%' OR
ICD10Code like 'I70.431%' OR
ICD10Code like 'I70.432%' OR
ICD10Code like 'I70.433%' OR
ICD10Code like 'I70.434%' OR
ICD10Code like 'I70.435%' OR
ICD10Code like 'I70.438%' OR
ICD10Code like 'I70.439%' OR
ICD10Code like 'I70.441%' OR
ICD10Code like 'I70.442%' OR
ICD10Code like 'I70.443%' OR
ICD10Code like 'I70.444%' OR
ICD10Code like 'I70.445%' OR
ICD10Code like 'I70.448%' OR
ICD10Code like 'I70.449%' OR
ICD10Code like 'I70.45%' OR
ICD10Code like 'I70.461%' OR
ICD10Code like 'I70.462%' OR
ICD10Code like 'I70.463%' OR
ICD10Code like 'I70.468%' OR
ICD10Code like 'I70.469%' OR
ICD10Code like 'I70.491%' OR
ICD10Code like 'I70.492%' OR
ICD10Code like 'I70.493%' OR
ICD10Code like 'I70.498%' OR
ICD10Code like 'I70.499%' OR
ICD10Code like 'I70.501%' OR
ICD10Code like 'I70.502%' OR
ICD10Code like 'I70.503%' OR
ICD10Code like 'I70.508%' OR
ICD10Code like 'I70.509%' OR
ICD10Code like 'I70.511%' OR
ICD10Code like 'I70.512%' OR
ICD10Code like 'I70.513%' OR
ICD10Code like 'I70.518%' OR
ICD10Code like 'I70.519%' OR
ICD10Code like 'I70.521%' OR
ICD10Code like 'I70.522%' OR
ICD10Code like 'I70.523%' OR
ICD10Code like 'I70.528%' OR
ICD10Code like 'I70.529%' OR
ICD10Code like 'I70.531%' OR
ICD10Code like 'I70.532%' OR
ICD10Code like 'I70.533%' OR
ICD10Code like 'I70.534%' OR
ICD10Code like 'I70.535%' OR
ICD10Code like 'I70.538%' OR
ICD10Code like 'I70.539%' OR
ICD10Code like 'I70.541%' OR
ICD10Code like 'I70.542%' OR
ICD10Code like 'I70.543%' OR
ICD10Code like 'I70.544%' OR
ICD10Code like 'I70.545%' OR
ICD10Code like 'I70.548%' OR
ICD10Code like 'I70.549%' OR
ICD10Code like 'I70.55%' OR
ICD10Code like 'I70.561%' OR
ICD10Code like 'I70.562%' OR
ICD10Code like 'I70.563%' OR
ICD10Code like 'I70.568%' OR
ICD10Code like 'I70.569%' OR
ICD10Code like 'I70.591%' OR
ICD10Code like 'I70.592%' OR
ICD10Code like 'I70.593%' OR
ICD10Code like 'I70.598%' OR
ICD10Code like 'I70.599%' OR
ICD10Code like 'I70.601%' OR
ICD10Code like 'I70.602%' OR
ICD10Code like 'I70.603%' OR
ICD10Code like 'I70.608%' OR
ICD10Code like 'I70.609%' OR
ICD10Code like 'I70.611%' OR
ICD10Code like 'I70.612%' OR
ICD10Code like 'I70.613%' OR
ICD10Code like 'I70.618%' OR
ICD10Code like 'I70.619%' OR
ICD10Code like 'I70.621%' OR
ICD10Code like 'I70.622%' OR
ICD10Code like 'I70.623%' OR
ICD10Code like 'I70.628%' OR
ICD10Code like 'I70.629%' OR
ICD10Code like 'I70.631%' OR
ICD10Code like 'I70.632%' OR
ICD10Code like 'I70.633%' OR
ICD10Code like 'I70.634%' OR
ICD10Code like 'I70.635%' OR
ICD10Code like 'I70.638%' OR
ICD10Code like 'I70.639%' OR
ICD10Code like 'I70.641%' OR
ICD10Code like 'I70.642%' OR
ICD10Code like 'I70.643%' OR
ICD10Code like 'I70.644%' OR
ICD10Code like 'I70.645%' OR
ICD10Code like 'I70.648%' OR
ICD10Code like 'I70.649%' OR
ICD10Code like 'I70.65%' OR
ICD10Code like 'I70.661%' OR
ICD10Code like 'I70.662%' OR
ICD10Code like 'I70.663%' OR
ICD10Code like 'I70.668%' OR
ICD10Code like 'I70.669%' OR
ICD10Code like 'I70.691%' OR
ICD10Code like 'I70.692%' OR
ICD10Code like 'I70.693%' OR
ICD10Code like 'I70.698%' OR
ICD10Code like 'I70.699%' OR
ICD10Code like 'I70.701%' OR
ICD10Code like 'I70.702%' OR
ICD10Code like 'I70.703%' OR
ICD10Code like 'I70.708%' OR
ICD10Code like 'I70.709%' OR
ICD10Code like 'I70.711%' OR
ICD10Code like 'I70.712%' OR
ICD10Code like 'I70.713%' OR
ICD10Code like 'I70.718%' OR
ICD10Code like 'I70.719%' OR
ICD10Code like 'I70.721%' OR
ICD10Code like 'I70.722%' OR
ICD10Code like 'I70.723%' OR
ICD10Code like 'I70.728%' OR
ICD10Code like 'I70.729%' OR
ICD10Code like 'I70731%' OR
ICD10Code like 'I70.732%' OR
ICD10Code like 'I70.733%' OR
ICD10Code like 'I70.734%' OR
ICD10Code like 'I70.735%' OR
ICD10Code like 'I70.738%' OR
ICD10Code like 'I70.739%' OR
ICD10Code like 'I70.741%' OR
ICD10Code like 'I70.742%' OR
ICD10Code like 'I70.743%' OR
ICD10Code like 'I70.744%' OR
ICD10Code like 'I70.745%' OR
ICD10Code like 'I70.748%' OR
ICD10Code like 'I70.749%' OR
ICD10Code like 'I70.75%' OR
ICD10Code like 'I70.761%' OR
ICD10Code like 'I70.762%' OR
ICD10Code like 'I70.763%' OR
ICD10Code like 'I70.768%' OR
ICD10Code like 'I70.769%' OR
ICD10Code like 'I70.791%' OR
ICD10Code like 'I70.792%' OR
ICD10Code like 'I70.793%' OR
ICD10Code like 'I70.798%' OR
ICD10Code like 'I70.799%' OR
ICD10Code like 'I70.8%' OR
ICD10Code like 'I70.90%' OR
ICD10Code like 'I70.91%' OR
ICD10Code like 'I70.92%' OR
ICD10Code like 'I73.00%' OR
ICD10Code like 'I73.01%' OR
ICD10Code like 'I73.1%' OR
ICD10Code like 'I73.81%' OR
ICD10Code like 'I73.89%' OR
ICD10Code like 'I73.9%' 

/* now to identify those patients that have these primary diagnoses */
 -- first create a union all of these tables 

 select *
into #diagsid

 from #cadicd
 union all 
 
 select *
 from #padicd
 union all 

 select *
 from #cvdsid


 -- see the outpat files and then identify patients

 select top 10*
 from src.Outpat_VDiagnosis

 -- get the list of patientsid

 select a.PatientSID, cast(a.VisitDateTime as date) as visitdate, a.PrimarySecondary,
	a.Sta3n, b.condition, b.ICD10Code

into #outpat_ali

 from src.Outpat_VDiagnosis as a 
 inner join #diagsid as b 
 
 on a.ICD10SID = b.ICD10SID 

 where a.VisitDateTime between '2016-01-01' and '2019-12-31'
	and a.PrimarySecondary = 'p'

-- 

select count(patientsid) 
from #outpat_ali -- 6917291 rows 

-- we need to get the scrssn into this table 

select a.*, b.scrssn 

into #outpat_ali2

from #outpat_ali as a
inner join src.CohortCrosswalk as b
on a.PatientSID = b.PatientSID
order by scrssn, visitdate

-- see the number of patients 

select count(distinct(scrssn))
from #outpat_ali2

-- 1139607 patients with cad, pad or cvd as their primary diagnosis.
-- need to only keep the first such visit in this time period.

drop table dflt.ali_outpat1

-- need to only keep the first such visit 

select top 10*
from #outpat_ali2

--

WITH CTE AS(

	SELECT 
		*,
		RANK() OVER(PARTITION BY scrssn ORDER BY VISITDATE)AS [R]
	FROM #outpat_ali2
	)

SELECT *

INTO #OUTPAT_ALI3

FROM CTE 

WHERE [R] = 1

-- NOW TO SEE THE NEW TABLE 

SELECT TOP 10*
FROM #OUTPAT_ALI3

-- NOW TO SEE THE NUMBER OF PATIENTS

SELECT COUNT(DISTINCT(SCRSSN))
FROM #OUTPAT_ALI3

SELECT COUNT(SCRSSN)
FROM #OUTPAT_ALI3

-- 1139607 PATIENTS WITH PAD,CAD,CVD OUTPAT VISIT IN THE TIME FRAME / SO STILL SOME DUPLICATES 


with cte as 
(
select *,
	row_number() over(partition by scrssn  order by(select null)) seq

	from #OUTPAT_ALI3 a

)
delete from cte 
	where seq > 1 

-- SOME ROWS REMOVED, NOW DISTINCT ROWS ONLY
-- GET MORE INFORMATION FOR THESE PATIENTS
-- SECONDARY DIAGNOSES TO BE ADDED TO THIS TABLE 

SELECT TOP 10*
FROM #OUTPAT_ALI3

-- SAVE THIS TO A TABLE 

SELECT *
INTO DFLT.OUTPAT_ALI_BASECOHORT
FROM #OUTPAT_ALI3

SELECT TOP 10*
FROM SRC.Outpat_VDiagnosis

-- WE NEED TO GET THE OTHER COMORBIDITIES
-- DM, HTN, DYSLIP, PRIOR PCI, PRIOR CABG, PRIOR STROKE, PRIOR MI, COPD, CKD, ESRD,AF 
-- LABS - HBA1C, HB, LDL, EGFR
-- VITALS - HR, SBP, BMI
-- SEE IF WE NEED TO GET THE VARIABLES TO CALCULATE THE REACH/SMART SCORE

-- NEED TO BE ABLE TO IDENTIFY AHA 2018 HIGH RISK CRITERIA

-- COPD 


SELECT 
	DISTINCT ICD10SID, ICD10Code,	
	'Lung' as 'SHORTNAME'

INTO #COPDICD
FROM CDWWork.DIM.ICD10	


WHERE
ICD10Code like 'J40.%' OR
ICD10Code like 'J41.0%' OR
ICD10Code like 'J41.1%' OR
ICD10Code like 'J41.8%' OR
ICD10Code like 'J42.%' OR
ICD10Code like 'J43.0%' OR
ICD10Code like 'J43.1%' OR
ICD10Code like 'J43.2%' OR
ICD10Code like 'J43.8%' OR
ICD10Code like 'J43.9%' OR
ICD10Code like 'J44.8%' OR
ICD10Code like 'J44.0%' OR
ICD10Code like 'J44.1%' OR
ICD10Code like 'J44.9%' OR
ICD10Code like 'J45.%' OR
ICD10Code like 'J45.0%' OR
ICD10Code like 'J45.1%' OR
ICD10Code like 'J45.8%' OR
ICD10Code like 'J45.9%' OR
ICD10Code like 'J45.20%' OR
ICD10Code like 'J45.21%' OR
ICD10Code like 'J45.22%' OR
ICD10Code like 'J45.30%' OR
ICD10Code like 'J45.31%' OR
ICD10Code like 'J45.32%' OR
ICD10Code like 'J45.40%' OR
ICD10Code like 'J45.41%' OR
ICD10Code like 'J45.42%' OR
ICD10Code like 'J45.50%' OR
ICD10Code like 'J45.50,' OR
ICD10Code like 'J45.51%' OR
ICD10Code like 'J45.52%' OR
ICD10Code like 'J45.901%' OR
ICD10Code like 'J45.902%' OR
ICD10Code like 'J45.909%' OR
ICD10Code like 'J45.990%' OR
ICD10Code like 'J45.991%' OR
ICD10Code like 'J45.998%' OR
ICD10Code like 'J47.0%' OR
ICD10Code like 'J47.1%' OR
ICD10Code like 'J47.9%' OR
ICD10Code like 'J66.%' OR
ICD10Code like 'J67.0%' OR
ICD10Code like 'J67.1%' OR
ICD10Code like 'J67.2%' OR
ICD10Code like 'J67.3%' OR
ICD10Code like 'J67.4%' OR
ICD10Code like 'J67.5%' OR
ICD10Code like 'J67.6%' OR
ICD10Code like 'J67.7%' OR
ICD10Code like 'J67.8%' OR
ICD10Code like 'J67.9%' OR
ICD10Code like 'J82.%' OR
ICD10Code like 'J84.%' OR
ICD10Code like 'J98.2%' OR
ICD10Code like 'J98.3%' OR
ICD10Code like 'J98.9%' 



SELECT 
	DISTINCT ICD10SID, ICD10Code,	
	'Diabetes' as 'SHORTNAME'

INTO #DMSID

FROM

	CDWWORK.DIM.ICD10
WHERE
ICD10Code like 'E08.00%' OR
ICD10Code like 'E08.01%' OR
ICD10Code like 'E08.10%' OR
ICD10Code like 'E08.11%' OR
ICD10Code like 'E08.21%' OR
ICD10Code like 'E08.22%' OR
ICD10Code like 'E08.29%' OR
ICD10Code like 'E08.311%' OR
ICD10Code like 'E08.319%' OR
ICD10Code like 'E08.321%' OR
ICD10Code like 'E08.3211%' OR
ICD10Code like 'E08.3212%' OR
ICD10Code like 'E08.3213%' OR
ICD10Code like 'E08.3219%' OR
ICD10Code like 'E08.329%' OR
ICD10Code like 'E08.3291%' OR
ICD10Code like 'E08.3292%' OR
ICD10Code like 'E08.3293%' OR
ICD10Code like 'E08.3299%' OR
ICD10Code like 'E08.331%' OR
ICD10Code like 'E08.3311%' OR
ICD10Code like 'E08.3312%' OR
ICD10Code like 'E08.3313%' OR
ICD10Code like 'E08.3319%' OR
ICD10Code like 'E08.339%' OR
ICD10Code like 'E08.3391%' OR
ICD10Code like 'E08.3392%' OR
ICD10Code like 'E08.3393%' OR
ICD10Code like 'E08.3399%' OR
ICD10Code like 'E08.341%' OR

ICD10Code like 'E08.349%' OR
ICD10Code like 'E08.3491%' OR
ICD10Code like 'E08.3492%' OR
ICD10Code like 'E08.3493%' OR
ICD10Code like 'E08.3499%' OR
ICD10Code like 'E08.351%' OR
ICD10Code like 'E08.3511%' OR
ICD10Code like 'E08.3512%' OR
ICD10Code like 'E08.3513%' OR
ICD10Code like 'E08.3519%' OR
ICD10Code like 'E08.3521%' OR
ICD10Code like 'E08.3522%' OR
ICD10Code like 'E08.3523%' OR
ICD10Code like 'E08.3529%' OR
ICD10Code like 'E08.3531%' OR
ICD10Code like 'E08.3532%' OR
ICD10Code like 'E08.3533%' OR
ICD10Code like 'E08.3539%' OR
ICD10Code like 'E08.3541%' OR
ICD10Code like 'E08.3542%' OR
ICD10Code like 'E08.3543%' OR
ICD10Code like 'E08.3549%' OR
ICD10Code like 'E08.3551%' OR
ICD10Code like 'E08.3552%' OR
ICD10Code like 'E08.3553%' OR
ICD10Code like 'E08.3559%' OR
ICD10Code like 'E08.359%' OR
ICD10Code like 'E08.3591%' OR
ICD10Code like 'E08.3592%' OR
ICD10Code like 'E08.3593%' OR
ICD10Code like 'E08.3599%' OR
ICD10Code like 'E08.36%' OR
ICD10Code like 'E08.37X1%' OR
ICD10Code like 'E08.37X2%' OR
ICD10Code like 'E08.37X3%' OR
ICD10Code like 'E08.37X9%' OR
ICD10Code like 'E08.39%' OR
ICD10Code like 'E08.40%' OR
ICD10Code like 'E08.41%' OR
ICD10Code like 'E08.42%' OR
ICD10Code like 'E08.43%' OR
ICD10Code like 'E08.44%' OR
ICD10Code like 'E08.49%' OR
ICD10Code like 'E08.51%' OR
ICD10Code like 'E08.52%' OR
ICD10Code like 'E08.59%' OR
ICD10Code like 'E08.610%' OR
ICD10Code like 'E08.618%' OR
ICD10Code like 'E08.620%' OR
ICD10Code like 'E08.621%' OR
ICD10Code like 'E08.622%' OR
ICD10Code like 'E08.628%' OR
ICD10Code like 'E08.630%' OR
ICD10Code like 'E08.638%' OR
ICD10Code like 'E08.641%' OR
ICD10Code like 'E08.649%' OR
ICD10Code like 'E08.65%' OR
ICD10Code like 'E08.69%' OR
ICD10Code like 'E08.8%' OR
ICD10Code like 'E08.9%' OR
ICD10Code like 'E09.00%' OR
ICD10Code like 'E09.01%' OR
ICD10Code like 'E09.10%' OR
ICD10Code like 'E09.11%' OR
ICD10Code like 'E09.21%' OR
ICD10Code like 'E09.22%' OR
ICD10Code like 'E09.29%' OR
ICD10Code like 'E09.311%' OR
ICD10Code like 'E09.319%' OR
ICD10Code like 'E09.321%' OR
ICD10Code like 'E09.3211%' OR
ICD10Code like 'E09.3212%' OR
ICD10Code like 'E09.3213%' OR
ICD10Code like 'E09.3219%' OR
ICD10Code like 'E09.329%' OR
ICD10Code like 'E09.3291%' OR
ICD10Code like 'E09.3292%' OR
ICD10Code like 'E09.3293%' OR
ICD10Code like 'E09.3299%' OR
ICD10Code like 'E09.331%' OR
ICD10Code like 'E09.3311%' OR
ICD10Code like 'E09.3312%' OR
ICD10Code like 'E09.3313%' OR
ICD10Code like 'E09.3319%' OR
ICD10Code like 'E09.339%' OR
ICD10Code like 'E09.3391%' OR
ICD10Code like 'E09.3392%' OR
ICD10Code like 'E09.3393%' OR
ICD10Code like 'E09.3399%' OR
ICD10Code like 'E09.341%' OR
ICD10Code like 'E09.3411%' OR
ICD10Code like 'E09.3412%' OR
ICD10Code like 'E09.3413%' OR
ICD10Code like 'E09.3419%' OR
ICD10Code like 'E09.349%' OR
ICD10Code like 'E09.3491%' OR
ICD10Code like 'E09.3492%' OR
ICD10Code like 'E09.3493%' OR
ICD10Code like 'E09.3499%' OR
ICD10Code like 'E09.351%' OR
ICD10Code like 'E09.3511%' OR
ICD10Code like 'E09.3512%' OR
ICD10Code like 'E09.3513%' OR
ICD10Code like 'E09.3519%' OR
ICD10Code like 'E09.3521%' OR
ICD10Code like 'E09.3522%' OR
ICD10Code like 'E09.3523%' OR
ICD10Code like 'E09.3529%' OR
ICD10Code like 'E09.3531%' OR
ICD10Code like 'E09.3532%' OR
ICD10Code like 'E09.3533%' OR
ICD10Code like 'E09.3539%' OR
ICD10Code like 'E09.3541%' OR
ICD10Code like 'E09.3542%' OR
ICD10Code like 'E09.3543%' OR
ICD10Code like 'E09.3549%' OR
ICD10Code like 'E09.3551%' OR
ICD10Code like 'E09.3552%' OR
ICD10Code like 'E09.3553%' OR
ICD10Code like 'E09.3559%' OR
ICD10Code like 'E09.359%' OR
ICD10Code like 'E09.3591%' OR
ICD10Code like 'E09.3592%' OR
ICD10Code like 'E09.3593%' OR
ICD10Code like 'E09.3599%' OR
ICD10Code like 'E09.36%' OR
ICD10Code like 'E09.37X1%' OR
ICD10Code like 'E09.37X2%' OR
ICD10Code like 'E09.37X3%' OR
ICD10Code like 'E09.37X9%' OR
ICD10Code like 'E09.39%' OR
ICD10Code like 'E09.40%' OR
ICD10Code like 'E09.4%' OR
ICD10Code like 'E09.42%' OR
ICD10Code like 'E09.43%' OR
ICD10Code like 'E09.44%' OR
ICD10Code like 'E09.49%' OR
ICD10Code like 'E09.51%' OR
ICD10Code like 'E09.52%' OR
ICD10Code like 'E09.59%' OR
ICD10Code like 'E09.610%' OR
ICD10Code like 'E09.618%' OR
ICD10Code like 'E09.620%' OR
ICD10Code like 'E09.621%' OR
ICD10Code like 'E09.622%' OR
ICD10Code like 'E09.628%' OR
ICD10Code like 'E09.630%' OR
ICD10Code like 'E09.638%' OR
ICD10Code like 'E09.641%' OR
ICD10Code like 'E09.649%' OR
ICD10Code like 'E09.65%' OR
ICD10Code like 'E09.69%' OR
ICD10Code like 'E09.8%' OR
ICD10Code like 'E09.9%' OR
ICD10Code like 'E10.9%' OR
ICD10Code like 'E11.7%' OR
ICD10Code like 'E11.00%' OR
ICD10Code like 'E11.01%' OR
ICD10Code like 'E11.10%' OR
ICD10Code like 'E11.11%' OR
ICD10Code like 'E11.21%' OR
ICD10Code like 'E11.22%' OR
ICD10Code like 'E11.29%' OR
ICD10Code like 'E11.311%' OR
ICD10Code like 'E11.319%' OR
ICD10Code like 'E11.321%' OR
ICD10Code like 'E11.3211%' OR
ICD10Code like 'E11.3212%' OR
ICD10Code like 'E11.3213%' OR
ICD10Code like 'E11.3219%' OR
ICD10Code like 'E11.329%' OR
ICD10Code like 'E11.3291%' OR
ICD10Code like 'E11.3292%' OR
ICD10Code like 'E11.3293%' OR
ICD10Code like 'E11.3299%' OR
ICD10Code like 'E11.331%' OR
ICD10Code like 'E11.3311%' OR
ICD10Code like 'E11.3312%' OR
ICD10Code like 'E11.3313%' OR
ICD10Code like 'E11.3319%' OR
ICD10Code like 'E11.339%' OR
ICD10Code like 'E11.3391%' OR
ICD10Code like 'E11.3392%' OR
ICD10Code like 'E11.3393%' OR
ICD10Code like 'E11.3399%' OR
ICD10Code like 'E11.341%' OR
ICD10Code like 'E11.3411%' OR
ICD10Code like 'E11.3412%' OR
ICD10Code like 'E11.3413%' OR
ICD10Code like 'E11.3419%' OR
ICD10Code like 'E11.349%' OR
ICD10Code like 'E11.3491%' OR
ICD10Code like 'E11.3492%' OR
ICD10Code like 'E11.3493%' OR
ICD10Code like 'E11.3499%' OR
ICD10Code like 'E11.351%' OR
ICD10Code like 'E11.3511%' OR
ICD10Code like 'E11.3512%' OR
ICD10Code like 'E11.3513%' OR
ICD10Code like 'E11.3519%' OR
ICD10Code like 'E11.3521%' OR
ICD10Code like 'E11.3522%' OR
ICD10Code like 'E11.3523%' OR
ICD10Code like 'E11.3529%' OR
ICD10Code like 'E11.3531%' OR
ICD10Code like 'E11.3532%' OR
ICD10Code like 'E11.3533%' OR
ICD10Code like 'E11.3539%' OR
ICD10Code like 'E11.3541%' OR
ICD10Code like 'E11.3542%' OR
ICD10Code like 'E11.3543%' OR
ICD10Code like 'E11.3549%' OR
ICD10Code like 'E11.3551%' OR
ICD10Code like 'E11.3552%' OR
ICD10Code like 'E11.3553%' OR
ICD10Code like 'E11.3559%' OR
ICD10Code like 'E11.359%' OR
ICD10Code like 'E11.3591%' OR
ICD10Code like 'E11.3592%' OR
ICD10Code like 'E11.3593%' OR
ICD10Code like 'E11.3599%' OR
ICD10Code like 'E11.36%' OR
ICD10Code like 'E11.37X1%' OR
ICD10Code like 'E11.37X2%' OR
ICD10Code like 'E11.37X3%' OR
ICD10Code like 'E11.37X9%' OR
ICD10Code like 'E11.39%' OR
ICD10Code like 'E11.40%' OR
ICD10Code like 'E11.41%' OR
ICD10Code like 'E11.42%' OR
ICD10Code like 'E11.43%' OR
ICD10Code like 'E11.44%' OR
ICD10Code like 'E11.49%' OR
ICD10Code like 'E11.51%' OR
ICD10Code like 'E11.52%' OR
ICD10Code like 'E11.59%' OR
ICD10Code like 'E11.610%' OR
ICD10Code like 'E11.618%' OR
ICD10Code like 'E11.620%' OR
ICD10Code like 'E11.621%' OR
ICD10Code like 'E11.622%' OR
ICD10Code like 'E11.628%' OR
ICD10Code like 'E11.630%' OR
ICD10Code like 'E11.638%' OR
ICD10Code like 'E11.641%' OR
ICD10Code like 'E11.649%' OR
ICD10Code like 'E11.65%' OR
ICD10Code like 'E11.69%' OR
ICD10Code like 'E11.8%' OR
ICD10Code like 'E11.9%' OR
ICD10Code like 'E13.7%' OR
ICD10Code like 'E13.00%' OR
ICD10Code like 'E13.01%' OR
ICD10Code like 'E13.10%' OR
ICD10Code like 'E13.11%' OR
ICD10Code like 'E13.21%' OR
ICD10Code like 'E13.22%' OR
ICD10Code like 'E13.29%' OR
ICD10Code like 'E13.311%' OR
ICD10Code like 'E13.319%' OR
ICD10Code like 'E13.321%' OR
ICD10Code like 'E13.3211%' OR
ICD10Code like 'E13.3212%' OR
ICD10Code like 'E13.3213%' OR
ICD10Code like 'E13.3219%' OR
ICD10Code like 'E13.329%' OR
ICD10Code like 'E13.3291%' OR
ICD10Code like 'E13.3292%' OR
ICD10Code like 'E13.3293%' OR
ICD10Code like 'E13.3299%' OR
ICD10Code like 'E13.331%' OR
ICD10Code like 'E13.3311%' OR
ICD10Code like 'E13.3312%' OR
ICD10Code like 'E13.3313%' OR
ICD10Code like 'E13.3319%' OR
ICD10Code like 'E13.339%' OR
ICD10Code like 'E13.3391%' OR
ICD10Code like 'E13.3392%' OR
ICD10Code like 'E13.3393%' OR
ICD10Code like 'E13.3399%' OR
ICD10Code like 'E13.341%' OR
ICD10Code like 'E13.3411%' OR
ICD10Code like 'E13.3412%' OR
ICD10Code like 'E13.3413%' OR
ICD10Code like 'E13.3419%' OR
ICD10Code like 'E13.349%' OR
ICD10Code like 'E13.3491%' OR
ICD10Code like 'E13.3492%' OR
ICD10Code like 'E13.3493%' OR
ICD10Code like 'E13.3499%' OR
ICD10Code like 'E13.351%' OR
ICD10Code like 'E13.3511%' OR
ICD10Code like 'E13.3512%' OR
ICD10Code like 'E13.3513%' OR
ICD10Code like 'E13.3519%' OR
ICD10Code like 'E13.3521%' OR
ICD10Code like 'E13.3522%' OR
ICD10Code like 'E13.3523%' OR
ICD10Code like 'E13.3529%' OR
ICD10Code like 'E13.3531%' OR
ICD10Code like 'E13.3532%' OR
ICD10Code like 'E13.3533%' OR
ICD10Code like 'E13.3539%' OR
ICD10Code like 'E13.3541%' OR
ICD10Code like 'E13.3542%' OR
ICD10Code like 'E13.3543%' OR
ICD10Code like 'E13.3549%' OR
ICD10Code like 'E13.3551%' OR
ICD10Code like 'E13.3552%' OR
ICD10Code like 'E13.3553%' OR
ICD10Code like 'E13.3559%' OR
ICD10Code like 'E13.359%' OR
ICD10Code like 'E13.3591%' OR
ICD10Code like 'E13.3592%' OR
ICD10Code like 'E13.3593%' OR
ICD10Code like 'E13.3599%' OR
ICD10Code like 'E13.36%' OR
ICD10Code like 'E13.37X1%' OR
ICD10Code like 'E13.37X2%' OR
ICD10Code like 'E13.37X3%' OR
ICD10Code like 'E13.37X9%' OR
ICD10Code like 'E13.39%' OR
ICD10Code like 'E13.40%' OR
ICD10Code like 'E13.41%' OR
ICD10Code like 'E13.42%' OR
ICD10Code like 'E13.43%' OR
ICD10Code like 'E13.44%' OR
ICD10Code like 'E13.49%' OR
ICD10Code like 'E13.51%' OR
ICD10Code like 'E13.52%' OR
ICD10Code like 'E13.59%' OR
ICD10Code like 'E13.610%' OR
ICD10Code like 'E13.618%' OR
ICD10Code like 'E13.620%' OR
ICD10Code like 'E13.621%' OR
ICD10Code like 'E13.622%' OR
ICD10Code like 'E13.628%' OR
ICD10Code like 'E13.630%' OR
ICD10Code like 'E13.638%' OR
ICD10Code like 'E13.641%' OR
ICD10Code like 'E13.649%' OR
ICD10Code like 'E13.65%' OR
ICD10Code like 'E13.69%' OR
ICD10Code like 'E13.8%' OR
ICD10Code like 'E13.9%' OR
ICD10Code like 'E14.7%' 

-- HF



SELECT 
	DISTINCT ICD10SID, ICD10Code,	
	'HF' as 'shortName'

INTO #HFSID

FROM CDWWork.DIM.ICD10

WHERE
ICD10Code like 'I09.81%' OR
ICD10Code like 'I11.0%' OR
ICD10Code like 'I13.0%' OR
ICD10Code like 'I13.2%' OR
ICD10Code like 'I50.1%' OR
ICD10Code like 'I50.20%' OR
ICD10Code like 'I50.21%' OR
ICD10Code like 'I50.22%' OR
ICD10Code like 'I50.23%' OR
ICD10Code like 'I50.30%' OR
ICD10Code like 'I50.31%' OR
ICD10Code like 'I50.32%' OR
ICD10Code like 'I50.33%' OR
ICD10Code like 'I50.40%' OR
ICD10Code like 'I50.41%' OR
ICD10Code like 'I50.42%' OR
ICD10Code like 'I50.43%' OR
ICD10Code like 'I50.810%' OR
ICD10Code like 'I50.811%' OR
ICD10Code like 'I50.812%' OR
ICD10Code like 'I50.813%' OR
ICD10Code like 'I50.814%' OR
ICD10Code like 'I50.82%' OR
ICD10Code like 'I50.83%' OR
ICD10Code like 'I50.84%' OR
ICD10Code like 'I50.89%' OR
ICD10Code like 'I50.9%' 

-- NOW TO IDENTIFY PATIENTS FROM OUTPAT FILES

SELECT TOP 10*
FROM SRC.Outpat_VDiagnosis

-- GET THE LIST OF PATIENTS WITH COPD

SELECT A.PatientSID,
	'COPD' AS 'COND',
	B.SCRSSN

INTO #ALI_COPD

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #OUTPAT_ALI3 AS B
ON A.PatientSID = B.PATIENTSID

INNER JOIN #COPDICD AS C 
ON C.ICD10SID = A.ICD10SID
	WHERE A.PrimarySecondary = 'S' AND
	CAST(A.VisitDateTime AS DATE) <= B.VISITDATE

--

SELECT COUNT(DISTINCT(SCRSSN))
FROM #ALI_COPD

-- HF 


SELECT A.PatientSID,
	'HF' AS 'COND',
	B.SCRSSN

INTO #ALI_HF

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #OUTPAT_ALI3 AS B
ON A.PatientSID = B.PATIENTSID

INNER JOIN #HFSID AS C 
ON C.ICD10SID = A.ICD10SID
	WHERE A.PrimarySecondary = 'S' AND
	CAST(A.VisitDateTime AS DATE) <= B.VISITDATE

-- DM 


SELECT A.PatientSID,
	'DM' AS 'COND',
	B.SCRSSN

INTO #ALI_DM

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #OUTPAT_ALI3 AS B
ON A.PatientSID = B.PATIENTSID

INNER JOIN #DMSID AS C 
ON C.ICD10SID = A.ICD10SID
	WHERE A.PrimarySecondary = 'S' AND
	CAST(A.VisitDateTime AS DATE) <= B.VISITDATE

-- HTN

SELECT 
	DISTINCT ICD10SID, ICD10Code,	
	'HTN' as 'SHORTNAME'

INTO #HTNSID

FROM
	CDWWork.DIM.ICD10
WHERE
ICD10Code like 'H35.031%' OR
ICD10Code like 'H35.032%' OR
ICD10Code like 'H35.033%' OR
ICD10Code like 'H35.039%' OR
ICD10Code like 'I10.%' OR
ICD10Code like 'I11.%' OR
ICD10Code like 'I12.%' OR
ICD10Code like 'I13.%' OR
ICD10Code like 'I15.%' OR
ICD10Code like 'I15.1%' OR
ICD10Code like 'I15.2%' OR
ICD10Code like 'I15.9%' OR
ICD10Code like 'N26.2%' 

--

SELECT A.PatientSID,
	'HTN' AS 'COND',
	B.SCRSSN

INTO #ALI_HTN

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #OUTPAT_ALI3 AS B
ON A.PatientSID = B.PATIENTSID

INNER JOIN #HTNSID AS C 
ON C.ICD10SID = A.ICD10SID
	WHERE A.PrimarySecondary = 'S' AND
	CAST(A.VisitDateTime AS DATE) <= B.VISITDATE

-- AF

SELECT 
	DISTINCT ICD10SID, ICD10Code,	
	'AF' as 'SHORTNAME'

INTO #AFSID

FROM
	CDWWork.DIM.ICD10
WHERE
ICD10Code like 'I48%' OR
ICD10Code like 'I48.0%' OR
ICD10Code like 'I48.1%' OR
ICD10Code like 'I48.19%' OR
ICD10Code like 'I48.2%' OR
ICD10Code like 'I48.20%' OR
ICD10Code like 'I48.21%' OR
ICD10Code like 'I48.3%' OR
ICD10Code like 'I48.4%' OR
ICD10Code like 'I48.9%' OR
ICD10Code like 'I48.91%' OR
ICD10Code like 'I48.92%' 

-- IDENTIFY PATIENTS WITH AF


SELECT A.PatientSID,
	'AF' AS 'COND',
	B.SCRSSN

INTO #ALI_AF

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #OUTPAT_ALI3 AS B
ON A.PatientSID = B.PATIENTSID

INNER JOIN #AFSID AS C 
ON C.ICD10SID = A.ICD10SID
	WHERE A.PrimarySecondary = 'S' AND
	CAST(A.VisitDateTime AS DATE) <= B.VISITDATE

-- COMBINE ALL THE TABLES 

-- PRIOR CABG


SELECT 
	DISTINCT ICD10SID, ICD10Code,	
	'PRIOR_CABG' as 'SHORTNAME'

INTO #PRIOR_CABGSID

FROM
	CDWWork.DIM.ICD10
WHERE
ICD10Code like 'I25.810%' OR
ICD10Code like 'Z95.10%' 
--
-- PATIENTS WITH PRIOR CABG



SELECT A.PatientSID,
	'AF' AS 'COND',
	B.SCRSSN

INTO #ALI_PRIOR_CABG

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #OUTPAT_ALI3 AS B
ON A.PatientSID = B.PATIENTSID

INNER JOIN #PRIOR_CABGSID AS C 
ON C.ICD10SID = A.ICD10SID
	WHERE A.PrimarySecondary = 'S' AND
	CAST(A.VisitDateTime AS DATE) <= B.VISITDATE

---

-- PRIOR PCI 

SELECT TOP 10*
FROM DFLT.PRIORPCI_ICD_CODES

-- GET PATIENTS



SELECT A.PatientSID,
	'PRIOR_PCI' AS 'COND',
	B.SCRSSN

INTO #ALI_PRIOR_PCI

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #OUTPAT_ALI3 AS B
ON A.PatientSID = B.PATIENTSID

INNER JOIN DFLT.PRIORPCI_ICD_CODES AS C 
ON C.ICDSID = A.ICD10SID
	WHERE A.PrimarySecondary = 'S' AND
	CAST(A.VisitDateTime AS DATE) <= B.VISITDATE

-- PRIOR MI 

SELECT TOP 10*
FROM DFLT.PRIORMI_ICD_CODES

-- PATIENTS NOW



SELECT A.PatientSID,
	'PRIOR_MI' AS 'COND',
	B.SCRSSN

INTO #ALI_PRIOR_MI

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #OUTPAT_ALI3 AS B
ON A.PatientSID = B.PATIENTSID

INNER JOIN DFLT.PRIORMI_ICD_CODES AS C 
ON C.ICDSID = A.ICD10SID
	WHERE A.PrimarySecondary = 'S' AND
	CAST(A.VisitDateTime AS DATE) <= B.VISITDATE

-- NOW TO COMBINE ALL TABLES TOGETHER

SELECT *

INTO DFLT.ALI_SEC_DIAG

FROM #ALI_AF 
UNION ALL 
SELECT * FROM #ALI_COPD
UNION ALL 
SELECT * FROM #ALI_DM
UNION ALL 
SELECT * FROM #ALI_HF
UNION ALL 
SELECT * FROM #ALI_HTN
UNION ALL 
SELECT * FROM #ALI_PRIOR_CABG
UNION ALL 
SELECT * FROM #ALI_PRIOR_MI
UNION ALL 
SELECT * FROM #ALI_PRIOR_PCI

-- NOW TO GET THE VITALS AND THEN THE LAB VALUES FOR THESE PATIENTS.

-- AGE

SELECT b.ACT_LAST_DT, b.MVI_DOB, b.LIVING_IND, A.SCRSSN

INTO DFLT.ALI_AGE_VITALS

FROM DFLT.OUTPAT_ALI_BASECOHORT AS A
INNER JOIN SRC.VitalStatus_Master AS B 
ON A.SCRSSN = B.SCRSSN 


-- SBP 

select *
-- into #bp 
from CDWWOrk.dim.VitalType a
where a.VitalType like '%blood pressure%'

--
if OBJECT_ID('tempdb..#BP_TABLE1') is not null 
drop table #BP_TABLE1

select   a.VitalSignSID, a.Systolic,  a.PatientSID, 
		A.VitalSignEnteredDateTime,c.ScrSSN,
		A.Diastolic,
		DATEDIFF(DAY,  CAST(A.VitalSignTakenDateTime AS DATE), C.VISITDATE) AS DAYS
		
INTO #BP_TABLE1

from Src.Vital_VitalSign as a
	inner join #bp b
on a.VitalTypeSID = b.VitalTypeSID

	inner join DFLT.OUTPAT_ALI_BASECOHORT AS C

ON C.PATIENTSID = A.PatientSID

	WHERE DATEDIFF(DAY,  CAST(A.VitalSignTakenDateTime AS DATE), C.VISITDATE) BETWEEN 0 AND 90 	
	AND
		(A.Systolic IS NOT NULL) AND 
		(A.Diastolic IS NOT NULL)

--

SELECT *
INTO DFLT.ALI_BP
FROM #BP_TABLE1



--

-- NOW TO ONLY KEEP THE MOST RECENT SBP 

USE ORD_Deo_202010005D

-- age

SELECT TOP 10*
FROM SRC.Patient_Patient

-- GET AGE FOR MY PATIENTS.

SELECT A.PatientSID,
	A.Age, B.scrssn

into dflt.ali_age

FROM SRC.Patient_Patient AS A 
INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS B
ON A.PatientSID = B.PatientSID
ORDER BY scrssn

-- NOW TO GET THE PATIENT ZIP CODES
-- CAN GET MEDIAN INCOME USING ZIP CODE
-- EDUCATION LEVEL IS NOT AVAILABLE??

SELECT top 100 a.PatientFIPS, a.PatientSID, a.PatientZIP
FROM SRC.Outpat_Visit as a
where a.PatientFIPS is not null

--

SELECT A.PatientZIP, A.PatientSID, A.County, A.PatientIncome, A.PatientInsuranceType,
	A.VisitDateTime,  A.PatientFIPS,b.scrssn,B.visitdate

INTO DFLT.ALI_ZIP

FROM SRC.OUTPAT_VISIT AS A

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS B

ON A.PatientSID = B.PatientSID

	WHERE DATEDIFF(DAY, CAST(A.VISITDATETIME AS DATE), CAST(B.VISITDATE AS DATE)) BETWEEN 0 AND 180
AND A.PatientZIP IS NOT NULL 


SELECT TOP 10*
FROM DFLT.ALI_ZIP

-- PATIENTS MAY HAVE MORE THAN 1 DIAGNOSIS OF PAD/CAD/CVD
-- GET THE OTHER DIAGNOSES APART FROM THE PRIMARY DIAGNOSIS
-- NEED TO ONLY GET THE SCRSSN THAT HAVE THAT DIAGNOSIS BEFORE THE VISITDATE.

USE ORD_Deo_202010005D

SELECT TOP 10*
FROM SRC.Outpat_VDiagnosis

SELECT TOP 10*
FROM SRC.Inpat_InpatDischargeDiagnosis

SELECT TOP 10*
FROM SRC.Fee_FeeInpatInvoiceICDDiagnosis

-- START WITH OUTPAT INFO.

DROP TABLE #CAD_ADD_DIAG1


SELECT A.ICD10SID, C.scrssn,
	'CAD' AS 'ADD_DIAG'

INTO #CAD_ADD_DIAG1

FROM SRC.Outpat_VDiagnosis AS A

INNER JOIN #cadicd AS B
ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID

WHERE CAST(A.VisitDateTime AS DATE) <= CAST(C.VISITDATE AS DATE) 

-- NOW TO GET THE SAME USING INPAT DISCHARGE DIAGNOSES.

SELECT A.ICD10SID, C.scrssn,
	'CAD' AS 'ADD_DIAG'

INTO #CAD_ADD_DIAG2

FROM SRC.Inpat_InpatDischargeDiagnosis AS A

INNER JOIN #cadicd AS B
ON A.ICD10SID = B.ICD10SID 

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C

ON A.PatientSID = C.PatientSID
	WHERE CAST(A.ADMITDATETIME AS DATE) <= CAST(C.VISITDATE AS DATE)

-- COMBINE BOTH TOGETHER 

SELECT *

INTO DFLT.ALI_CAD_ADDDIAG

FROM #CAD_ADD_DIAG1
UNION ALL 
SELECT *

FROM #CAD_ADD_DIAG2

SELECT TOP 10*
FROM DFLT.ALI_CAD_ADDDIAG



-- NOW TO DO THE SAME FOR PAD AND THEN CVD


SELECT A.ICD10SID, C.scrssn,
	'PAD' AS 'ADD_DIAG'

INTO #PAD_ADD_DIAG1

FROM SRC.Outpat_VDiagnosis AS A

INNER JOIN #padicd AS B
ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID

WHERE CAST(A.VisitDateTime AS DATE) <= CAST(C.VISITDATE AS DATE) 

-- NOW FOR INPAT DATA


SELECT A.ICD10SID, C.scrssn,
	'PAD' AS 'ADD_DIAG'

INTO #PAD_ADD_DIAG2

FROM SRC.Inpat_InpatDischargeDiagnosis AS A

INNER JOIN #padicd AS B
ON A.ICD10SID = B.ICD10SID 

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C

ON A.PatientSID = C.PatientSID
	WHERE CAST(A.ADMITDATETIME AS DATE) <= CAST(C.VISITDATE AS DATE)


-- CVD NOW 



SELECT A.ICD10SID, C.scrssn,
	'CVD' AS 'ADD_DIAG'

INTO #CVD_ADD_DIAG1

FROM SRC.Outpat_VDiagnosis AS A

INNER JOIN #cvdsid AS B
ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID

WHERE CAST(A.VisitDateTime AS DATE) <= CAST(C.VISITDATE AS DATE) 

-- NOW FOR INPAT DATA


SELECT A.ICD10SID, C.scrssn,
	'CVD' AS 'ADD_DIAG'

INTO #CVD_ADD_DIAG2

FROM SRC.Inpat_InpatDischargeDiagnosis AS A

INNER JOIN #cvdsid AS B
ON A.ICD10SID = B.ICD10SID 

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C

ON A.PatientSID = C.PatientSID
	WHERE CAST(A.ADMITDATETIME AS DATE) <= CAST(C.VISITDATE AS DATE)


-- COMBINE ALL TOGETHER

SELECT * 

INTO DFLT.ALI_ADD_DIAG FROM DFLT.ALI_CAD_ADDDIAG

UNION ALL 
SELECT * FROM #PAD_ADD_DIAG1 
UNION ALL
SELECT * FROM #PAD_ADD_DIAG2
UNION ALL 
SELECT * FROM #CVD_ADD_DIAG1
UNION ALL
SELECT * FROM #CVD_ADD_DIAG2

-- NOW GOING TO GET THIS TABLE INTO THE MAIN DATASET.

-- BMI OR HEIGHT/WEIGHT AS VITALS 

use ORD_Deo_202010005D

SELECT TOP 10*
FROM SRC.Vital_VitalSign

--
CREATE VIEW DFLT.HT_VITALTYPESID 
AS 
SELECT A.VitalType, A.VitalTypeSID

FROM CDWWork.DIM.VitalType AS A 
WHERE A.VitalType LIKE 'HEIGHT%'
--

-- GET THE HEIGHT FOR MY PATIENTS.

CREATE VIEW DFLT.ALI_HEIGHT
AS
SELECT A.VitalResultNumeric AS HEIGHT, C.scrssn

FROM SRC.Vital_VitalSign AS A
INNER JOIN DFLT.HT_VITALTYPESID AS B
ON A.VitalTypeSID = B.VitalTypeSID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE DATEDIFF(DAY, CAST(A.VitalSignTakenDateTime AS DATE), C.visitdate) BETWEEN 0 AND 180
	AND A.VitalResultNumeric IS NOT  NULL 

-- SEE 

SELECT *

INTO DFLT.ALI_HEIGHT_TABLE

FROM DFLT.ALI_HEIGHT

-- WEIGHT 

CREATE VIEW DFLT.WEIGHT_VITALTYPESID
AS
SELECT A.VitalType, A.VitalTypeSID

FROM CDWWork.DIM.VitalType AS A 
WHERE A.VitalType LIKE 'WEIGHT%'

--
CREATE VIEW DFLT.ALI_WEIGHT
AS
SELECT A.VitalResultNumeric AS HEIGHT,C.scrssn

FROM SRC.Vital_VitalSign AS A
INNER JOIN DFLT.WEIGHT_VITALTYPESID AS B
ON A.VitalTypeSID = B.VitalTypeSID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE DATEDIFF(DAY, CAST(A.VitalSignTakenDateTime AS DATE), C.visitdate) BETWEEN 0 AND 180

	-- GET INTO TABLE 

SELECT *
INTO DFLT.ALI_WEIGHT_TABLE
FROM DFLT.ALI_WEIGHT

/* NOW THE LABS NEXT 
LDL, HBA1C, CREAT */

-- GET THE LABCHEMTESTSID FOR PATIENTS

CREATE VIEW DFLT.LDL_LABCHEMTESTSID
AS
--if OBJECT_ID('tempdb..#LDL_LABCHEMTESTSID') is not null 
--drop table #LDL_LABCHEMTESTSID

SELECT A.LabChemPrintTestName, A.LabChemTestSID,
		B.LabChemTestSpecimenSID,B.LOINCSID,B.Units,
		C.TOPOGRAPHY

-- INTO #LDL_LABCHEMTESTSID

FROM CDWWORK.DIM.LabChemTest AS A 

INNER JOIN CDWWORK.DIM.LABCHEMTESTSPECIMEN AS B
	ON A.LabChemTestSID = B.LabChemTestSID

INNER JOIN CDWWORK.DIM.TOPOGRAPHY AS C
	ON C.TopographySID = B.TopographySID

WHERE (a.LabChemTestName LIKE '%LDL%'OR
	a.LabChemTestName LIKE '%LDLC%' or 
	a.LabChemTestName like '%LOW%Chol%') and 
	(a.LabChemTestName not like '%ratio%' and
	a.LabChemTestName not like '%risk%'and 
	a.labchemtestname not like '%vldl%') and


	
	(C.Topography LIKE '%BLOOD%' OR
	C.Topography LIKE '%SERUM%' AND 
	C.Topography NOT LIKE '%CSF%' AND
	C.Topography NOT LIKE '%PLEURAL%' AND 
	C.Topography NOT LIKE '%URINE%') AND 
	(Units not like '%ratio%' and 
	units not like '%pattern%' )

-- NOW TO GET THE LDL FOR THE COHORT.

SELECT TOP 100*
FROM DFLT.LDL_LABCHEMTESTSID

-- GET THE VALUES OF LDL THAT ARE BETWEEN 0 AND 180 DAYS



CREATE VIEW DFLT.ALI_LDL
AS
SELECT A.LabChemTestSID, A.LabChemSpecimenDateTime, 
	A.LabChemResultNumericValue,A.PatientSID,C.SCRSSN,
	DATEDIFF(DAY, CAST(A.LabChemSpecimenDateTime AS DATE), C.visitdate) AS LDL_DAYS,
	C.visitdate

-- INTO #LDL_ALI_COHORT
FROM SRC.Chem_LabChem AS A 

INNER JOIN DFLT.LDL_LABCHEMTESTSID AS B

ON A.LabChemTestSID = B.LabChemTestSID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C

ON C.PATIENTSID = A.PatientSID
WHERE A.LabChemResultNumericValue IS NOT NULL 

-- SEE THE DATA 

SELECT TOP 100*
FROM DFLT.ALI_LDL

SELECT COUNT(DISTINCT(SCRSSN)) -- 999,430 PATIENTS HAVE MEASURED LDL VALUES 
FROM DFLT.ALI_LDL

-- GET INTO TABLE 

SELECT *
INTO DFLT.ALI_LDL_TABLE

FROM DFLT.ALI_LDL

-- MAY NEED MORE LABS, BUT FOR NOW AM GOING TO CONCENTRATE NOW ON MED REFILLS.
-- ALSO SEE THE # OF PATIENTS THAT HAVE HAD ALIROCUMAB & EVOLOCUMAB PRESCRIBED.

/* along with social predictors for use of alirocumab, also see if provider type, 
va location ... influence use of alirocumab and non statin therapies ...*/

use ORD_Deo_202010005D

SELECT TOP 10*
FROM DFLT.ALI_ZIP -- THIS CONTAINS THE COUNTY NAME. SO, WE CAN GET THE 
-- THE STATE NAME FROM THE ZIP CODE AND THEN GET THE OTHER PARAMETERS FROM THAT.


/* LOOKS LIKE I DO NOT HAVE SEX, CREAT, RACE, ETHNICITY, CKD INFO - RATHER THAN USING CREAT, I WILL USE ICD/CPT CODES TO GET CKD INFO */

USE ORD_Deo_202010005D

SELECT A.PatientSID, A.Gender
INTO #G_TAB
FROM SRC.Patient_Patient AS A

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS B
	ON A.PatientSID = B.[PatientSID]


-- GTAB CONTAINS GENDER INFO

SELECT A.Gender, B.ScrSSN, A.PatientSID

into dflt.ALI_GENDER
FROM #G_TAB AS A 

LEFT JOIN SRC.CohortScrSSN AS B 
	ON A.PatientSID = B.ScrSSN

-- IDENTIFY CKD (combination  OF ICD CODES AND CALCULATING SERUM CREAT FROM THE LAB DATA)

/* USING ICD CODES */

CREATE VIEW DFLT.ICD9CKD
AS
SELECT A.ICD9SID, A.ICD9CODE

FROM CDWWork.DIM.ICD9 AS A  
	WHERE 
	
ICD9CODE LIKE '016.0' OR
ICD9CODE LIKE '095.4'OR 
ICD9CODE LIKE '189.0'OR
ICD9CODE LIKE '189.9'OR
ICD9CODE LIKE '223.0'OR
ICD9CODE LIKE '236.91'OR
ICD9CODE LIKE '250.4'OR 
ICD9CODE LIKE '271.4'OR 
ICD9CODE LIKE '274.1'OR 
ICD9CODE LIKE '283.11'OR 
ICD9CODE LIKE '403.%' OR 
ICD9CODE LIKE '404.%' OR 
ICD9CODE LIKE '442.1' OR 
ICD9CODE LIKE '447.3' OR 
ICD9CODE LIKE '572.4' OR 
ICD9CODE LIKE '580%' OR 
ICD9CODE LIKE '581%' OR 
ICD9CODE LIKE '582%' OR 
ICD9CODE LIKE '583%' OR 
ICD9CODE LIKE '584%' OR 
ICD9CODE LIKE '585%' OR 
ICD9CODE LIKE'591%' OR 
ICD9CODE LIKE '642.1' OR 
ICD9CODE LIKE '646.2' OR 
ICD9CODE LIKE '753.1%' OR 
ICD9CODE LIKE '753.19' OR 
ICD9CODE LIKE '753.2' OR 
ICD9CODE LIKE '794.4'



CREATE VIEW DFLT.ICD10CKD
AS
SELECT ICD10SID, ICD10Code

FROM CDWWork.DIM.ICD10  AS A 
WHERE 
ICD10CODE LIKE 'A18.11' OR 
ICD10CODE LIKE'A52.75' OR 
ICD10CODE LIKE 'C64.9'OR 
A.ICD10CODE LIKE 'C68.9' OR 
A.ICD10CODE LIKE 'D30.00' OR 
A.ICD10CODE LIKE 'D41.00' OR 
A.ICD10CODE LIKE 'D41.20' OR 
A.ICD10CODE LIKE 'D59.3' OR 
A.ICD10CODE LIKE 'E10.21' OR 
A.ICD10CODE LIKE 'E10.29' OR 
A.ICD10CODE LIKE 'E11.21' OR 
A.ICD10CODE LIKE 'E11.29' OR
A.ICD10CODE LIKE 'E74.8'OR 
A.ICD10CODE LIKE 'I12.0' OR
A.ICD10CODE LIKE  'I12.9'OR 
A.ICD10CODE LIKE 'I13.0' OR 
A.ICD10CODE LIKE 'I13.10' OR 
A.ICD10CODE LIKE 'I13.11'OR 
A.ICD10CODE LIKE 'I13.2'OR 
A.ICD10CODE LIKE 'I70.1' OR 
A.ICD10CODE LIKE'I72.2' OR 
A.ICD10CODE LIKE 'K76.7' OR 
A.ICD10CODE LIKE 'M10.30' OR 
A.ICD10CODE LIKE 'N00.3' OR 
A.ICD10CODE LIKE 'N00.8' OR 
A.ICD10CODE LIKE 'N00.9' OR 
A.ICD10CODE LIKE 'N01.3' OR 
A.ICD10CODE LIKE 'N02.2' OR 
A.ICD10CODE LIKE 'N03.2' OR 
A.ICD10CODE LIKE 'N03.3' OR 
A.ICD10CODE LIKE 'N03.5' OR 
A.ICD10CODE LIKE 'N03.8' OR 
A.ICD10CODE LIKE 'N03.9' OR 
A.ICD10CODE LIKE 'N04.0' OR 
A.ICD10CODE LIKE 'N04.3' OR 
A.ICD10CODE LIKE 'N04.4' OR  
A.ICD10CODE LIKE 'N04.8' OR 
A.ICD10CODE LIKE 'N04.9' OR 
A.ICD10CODE LIKE 'N05.2' OR 
A.ICD10CODE LIKE 'N05.5' OR 
A.ICD10CODE LIKE 'N05.8' OR 
A.ICD10CODE LIKE 'N05.9' OR 
A.ICD10CODE LIKE 'N08.%' OR 
A.ICD10CODE LIKE 'N13.30' OR 
A.ICD10CODE LIKE 'N17.0' OR 
A.ICD10CODE LIKE 'N17.1' OR 
A.ICD10CODE LIKE 'N17.2' OR 
A.ICD10CODE LIKE 'N17.8' OR 
A.ICD10CODE LIKE 'N17.9' OR 
A.ICD10CODE LIKE  'N18.1' OR 
A.ICD10CODE LIKE 'N18.2' OR 
A.ICD10CODE LIKE 'N18.3' OR 
A.ICD10CODE LIKE 'N18.4' OR 
A.ICD10CODE LIKE 'N18.5' OR 
A.ICD10CODE LIKE 'N18.6' OR 
A.ICD10CODE LIKE 'N18.9' OR 
A.ICD10CODE LIKE 'N19'OR 
A.ICD10CODE LIKE 'N25.0'OR 
A.ICD10CODE LIKE 'N25.1' OR 
A.ICD10CODE LIKE 'N25.81' OR 
A.ICD10CODE LIKE 'N25.89' OR 
A.ICD10CODE LIKE 'N25.9' OR 
A.ICD10CODE LIKE 'N26.9' OR 
A.ICD10CODE LIKE 'Q61.02' OR 
A.ICD10CODE LIKE 'Q61.19' OR 
A.ICD10CODE LIKE 'Q61.2' OR 
A.ICD10CODE LIKE 'Q61.3' OR 
A.ICD10CODE LIKE 'Q61.4' OR 
A.ICD10CODE LIKE 'Q61.5' OR 
A.ICD10CODE LIKE 'Q61.8'OR 
A.ICD10CODE LIKE 'Q62.10' OR 
A.ICD10CODE LIKE 'Q62.11' OR 
A.ICD10CODE LIKE 'Q62.12'OR 
A.ICD10CODE LIKE 'Q62.31' OR 
A.ICD10CODE LIKE 'Q62.39' OR 
A.ICD10CODE LIKE 'R94.4'

/* VIEWS CREATED FOR CKDICD CODES FOR ICD9 & ICD10 
NOW TO IDENTIFY CKD AS A COVARIATE IN THE ALIROCUMAB COHORT */

USE ORD_Deo_202010005D

SELECT TOP 100*
FROM DFLT.ICD10CKD

--

SELECT A.ICD10SID, C.scrssn,
	'CKD' AS 'ADD_DIAG', A.VisitDateTime, C.visitdate

INTO #OUTPAT_CKD

FROM SRC.Outpat_VDiagnosis AS A

INNER JOIN  DFLT.ICD10CKD AS B 

ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID

WHERE DATEDIFF(DAY, CAST(A.VisitDateTime AS DATE), CAST(C.VISITDATE AS DATE)) BETWEEN 0 AND 365

--


SELECT A.ICD10SID, C.scrssn,
	'CKD' AS 'ADD_DIAG'

INTO #INPAT_CKD

FROM SRC.Inpat_InpatDischargeDiagnosis AS A

INNER JOIN DFLT.ICD10CKD AS B
ON A.ICD10SID = B.ICD10SID 

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C

ON A.PatientSID = C.PatientSID
	WHERE 
	DATEDIFF(DAY, CAST(A.ADMITDATETIME AS DATE),  CAST(C.VISITDATE AS DATE)) BETWEEN 0 AND 365

-- 

SELECT SCRSSN, 
	ADD_DIAG 

INTO DFLT.ALI_CKD_DIAG

FROM #OUTPAT_CKD AS A

UNION ALL 

SELECT SCRSSN,	ADD_DIAG
FROM #INPAT_CKD

/* better method for gender */

DROP TABLE DFLT.ALI_GENDER

-- 

select DISTINCT A.SCRSSN, A.MVI_SEX

INTO DFLT.ALI_GENDER

from src.VitalStatus_Master AS A 
INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS B
ON A.SCRSSN = B.scrssn

--

SELECT COUNT(DISTINCT(SCRSSN)), MVI_SEX
FROM DFLT.ALI_GENDER
GROUP BY MVI_SEX


/* NEED RACE, ETHNICITY DATA */

DROP TABLE DFLT.ALI_RACE

SELECT A.Race, A.PatientSID, C.ScrSSN

INTO DFLT.ALI_RACE

FROM SRC.PatSub_PatientRace AS A
INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS B
ON A.PatientSID = B.PatientSID

RIGHT JOIN SRC.CohortCrosswalk AS C
	ON A.PatientSID = C.PatientSID



/* NEED TO GET SCRSSN HERE AND THEN SAVE IT */

SELECT COUNT(DISTINCT(PATIENTSID)),RACE 
FROM DFLT.ALI_RACE
GROUP BY RACE 

--

/* SMOKING */

--

USE ORD_Deo_202010005D

SELECT A.ICD9CODE, A.ICD9SID
INTO DFLT.SMOKINGICD9
FROM CDWWork.DIM.ICD9 AS A 
WHERE 
A.ICD9CODE LIKE '305.1' OR
A.ICD9CODE LIKE '649.%' OR 
A.ICD9CODE LIKE  '989.84' OR 
A.ICD9CODE LIKE 'V15.82'


SELECT CPTCODE, CPTSID
INTO DFLT.SMOKING_CPT
FROM CDWWORK.DIM.CPT
WHERE 
CPTCODE LIKE '99406' OR 
CPTCODE LIKE '99407' OR 
CPTCODE LIKE 'G0436' OR 
CPTCODE LIKE 'G0437' OR 
CPTCODE LIKE 'G9016' OR 
CPTCODE LIKE 'S9453' OR 
CPTCODE LIKE 'S4995' OR 
CPTCODE LIKE 'G9276' OR 
CPTCODE LIKE 'G9458' OR 
CPTCODE LIKE '1034F' OR 
CPTCODE LIKE '4004F' OR 
CPTCODE LIKE '4001F'


SELECT ICD10CODE, ICD10SID 
INTO DFLT.SMOKINGICD10
FROM CDWWORK.DIM.ICD10 
WHERE 
ICD10CODE LIKE 'F17.200' OR 
ICD10CODE LIKE 'F17.201' OR 
ICD10CODE LIKE 'F17.210' OR 
ICD10CODE LIKE 'F17.211' OR 
ICD10CODE LIKE 'F17.220' OR 
ICD10CODE LIKE 'F17.221' OR 
ICD10CODE LIKE 'F17.290' OR
ICD10CODE LIKE 'F17.291' OR 
ICD10CODE LIKE 'Z87.891'

-- SELECT PATIENTS WITH DIAGNOSIS OF SMOKING 

SELECT A.PatientSID, 'SMOKE' AS ADD_DIAG, C.scrssn


INTO #SMOKE_PAT9

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN DFLT.SMOKINGICD9 AS B
	ON A.ICD9SID = B.ICD9SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
	ON A.PatientSID = C.PatientSID

--

SELECT A.PATIENTSID, 'SMOKE' AS ADD_DIAG, C.SCRSSN

INTO #SMOKE_PAT10

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN DFLT.SMOKINGICD10 AS B
	ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
	ON A.PatientSID = C.PatientSID

---

/* COMBINE BOTH TO GET THE DISTINCT SCRSSN */

SELECT DISTINCT SCRSSN 

INTO DFLT.ALI_SMOKING

FROM #SMOKE_PAT9 
UNION ALL 
SELECT DISTINCT SCRSSN 
FROM #SMOKE_PAT10

/* WANT TO GET THE NUMBER OF OUTPAT VISITS FOR EACH PATIENT 
IN THE ALIROCUMAB COHORT */
-- 2020-12-18

USE ORD_Deo_202010005D


CREATE VIEW DFLT.ALI_OUTPAT_VISITS 
AS
SELECT A.PatientSID, A.VisitDateTime, B.scrssn

FROM SRC.Outpat_Visit AS A 
INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS B
	ON A.PatientSID = B.PatientSID 
WHERE CAST(A.VisitDateTime AS DATE) BETWEEN '2016-01-01' AND '2020-04-01'

-- SEE TOTAL AND DISTINCT OUTPAT VISITS 

select *
into dflt.ALI_OUTPAT_V
from dflt.ALI_OUTPAT_VISITS


/* TYPE OF VISIT - CARDIOLOGY */
USE ORD_Deo_202010005D

SELECT TOP 10*
FROM CDWWork.DIM.ProviderType


SELECT *
--into #provider_cards
FROM CDWWORK.DIM.ProviderType

 WHERE AreaOfSpecialization LIKE 'CARDIOLOGY%' AND 
	PROVIDERTYPE LIKE 'PHYSICIAN%'
	
--

SELECT DISTINCT(AreaOfSpecialization)
FROM CDWWork.DIM.ProviderTYPE 
ORDER BY AreaOfSpecialization

SELECT *
FROM CDWWork.DIM.ProviderType
WHERE
AreaOfSpecialization LIKE 'Advanced Heart Failure and Transplant Cardiology%' 
	

SELECT DISTINCT(Classification)
FROM CDWWork.DIM.ProviderType
ORDER BY Classification


-- ALSO ACC. TO THE ENDOCRINOLOGISTS CAN PRESCRIBE PCSK9I

SELECT *
from #provider_cards

SELECT *
--INTO #PROVIDER_ENDO
FROM CDWWORK.DIM.ProviderType
	WHERE AreaOfSpecialization LIKE 'Endocrinology, Diabetes & Metabolism%' AND
	PROVIDERTYPE LIKE 'MD%'


SELECT ProviderTypeSID
INTO #PROV_TYPE
FROM #provider_cards 
	UNION ALL 
SELECT ProviderTypeSID
FROM #PROVIDER_ENDO

SELECT *
FROM #PROV_TYPE

/* GET PROVIDER SID FROM PROVIDERTYPESID */

SELECT TOP 10*
FROM CDWWork.DIM.ProviderNarrative


/* now using this info. we can limit the patients to those that had a cardiology visit between the index dates 
can we see who prescribed the medications; first see who mainly prescribed the medications;
if more cardiology than pcp (most likely) then define how many cardiology visits the patients had during 
the time period. */

SELECT TOP 10*
FROM SRC.Outpat_Visit

SELECT TOP 10*
FROM SRC.Outpat_VProvider AS A

--

select A.ProviderTypeSID, A.PatientSID,B.scrssn
-- INTO DFLT.ALI_PROV
from src.Outpat_VProvider as a
	INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS B
ON A.PatientSID = B.PatientSID
	INNER JOIN #PROV_TYPE AS C 
ON A.ProviderTypeSID = C.ProviderTypeSID

WHERE CAST(A.VisitDateTime AS DATE) BETWEEN '2015-07-01' AND '2020-04-01'

--

/* LOOK AT STN FOR EACH PATIENT AS HOME VA */

USE ORD_Deo_202010005D

SELECT  A.SCRSSN, B.Sta3n

FROM DFLT.ALI_PCSK9I_FILLS AS A
INNER JOIN SRC.RxOut_RxOutpatFill AS B 
ON A.PatientSID = B.PatientSID
	WHERE A.FILLDATE BETWEEN '2016-01-01' AND '2020-04-01'

-- WE ACTUALLY NEED THE HOME VA FOR EACH PATIENT, NOT ONLY THOSE THAT HAD PCSK9I FILLS 

DROP VIEW DFLT.ALI_HOMEVA

CREATE VIEW DFLT.ALI_HOMEVA
AS
SELECT A.PatientSID, A.scrssn, B.Sta3n

FROM DFLT.OUTPAT_ALI_BASECOHORT AS A
INNER JOIN SRC.Outpat_VDiagnosis AS B
	ON A.PatientSID = B.PatientSID


--
SELECT TOP 10*
FROM DFLT.ALI_HOMEVA

SELECT *
INTO DFLT.ALI_HOMEVA2
FROM DFLT.ALI_HOMEVA
	
--

use ORD_Deo_202010005D

SELECT A.LocalDrugNameWithDose, A.LocalDrugSID, a.PatientSID

FROM SRC.RxOut_RxOutpatFill AS A 
WHERE A.LocalDrugNameWithDose LIKE 'BEMPEDOIC ACID%'
