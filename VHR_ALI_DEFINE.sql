/*

#########################################################
# PCSK9I USE IN A LARGE OBSERVATIONAL COHORT   ##########
#########################################################

AUTHOR: SVD

DATE: 11/12/2021

STUDY: PCSK9I USE IN A LARGE OBSERVATIONAL COHORT 

MAIN PURPOSE: TO IDENTIFY SOME CONDITIONS THAT WILL BE USED TO DEFINE AHA 2018 VERY HIGH RISK COHORT.

FURTHER DETAILS: 

DB: ORD_DEO_20210005D

VIEWS USED: 


VIEWS CREATED: 


TABLES CREATED: 


------------------------------------------------------------ */

USE ORD_Deo_202010005D

DROP TABLE #T1

SELECT A.HealthFactorType, A.HealthFactorTypeSID,
C.scrssn, C.visitdate, CAST(B.EventDateTime AS DATE) AS EVENTDATE

INTO #T1

FROM CDWWORK.DIM.HealthFactorType AS A
INNER JOIN SRC.HF_HealthFactor AS B
ON A.HealthFactorTypeSID = B.HealthFactorTypeSID 
INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON B.PatientSID = C.PatientSID
	WHERE DATEDIFF(DAY, C.VISITDATE, CAST(B.EventDateTime AS DATE)) BETWEEN 0 AND 180
	AND 
	A.HealthFactorType LIKE '%CURRENT SMO%' OR
	A.HealthFactorType LIKE '%TOBACCO%'


-- GET THE SCRSSN FOR CURRENT SMOKING PATIENTS 

SELECT *
INTO DFLT.ALI_SMOKE
FROM #T1

SELECT COUNT(DISTINCT(SCRSSN))
FROM #T1

SELECT COUNT(DISTINCT(SCRSSN))
FROM DFLT.OUTPAT_ALI_BASECOHORT

-- need to IDENTIFY THOSE THAT HAD ACS WITHIN 1 YEAR OF VISIT DATE



SELECT A.ICD10Code, A.ICD10SID

INTO #ACSSID
FROM CDWWORK.DIM.ICD10 AS A 
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
ICD10Code like 'I21.A9%' 


/* for icd9 codes */

SELECT A.ICD9Code, A.ICD9SID
INTO #ACSICD9
FROM CDWWork.DIM.ICD9 AS A
	WHERE A.ICD9Code LIKE '410.%' OR
	A.ICD9Code LIKE '410%'



/*NOW TO IDENTIFY THOSE THAT HAD THESE DIAGNOSES AS DISCHARGE DIAGNOSES WITH ADMISSION
WITHIN 1 YEAR OF VISIT */


SELECT TOP 10*
FROM SRC.Inpat_InpatDischargeDiagnosis



SELECT A.PatientSID, C.scrssn, A.AdmitDateTime, C.visitdate
	
INTO #INPAT_ACS10

FROM SRC.Inpat_InpatDischargeDiagnosis AS A 
INNER JOIN #ACSSID AS B
ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE 
	C.visitdate > A.AdmitDateTime


-- INPATACS9



SELECT A.PatientSID, C.scrssn, A.AdmitDateTime, C.visitdate
	
INTO #INPAT_ACS9

FROM SRC.Inpat_InpatDischargeDiagnosis AS A 
INNER JOIN #ACSICD9 AS B
ON A.ICD9SID = B.ICD9SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE 
	C.visitdate > A.AdmitDateTime AND 
	DATEDIFF(DAY, AdmitDateTime, visitdate) BETWEEN 0 AND 365

--

SELECT DISTINCT SCRSSN 
INTO #INPAT_ACS_REC
from #INPAT_ACS10 
UNION ALL 
SELECT DISTINCT SCRSSN 
FROM #INPAT_ACS9


SELECT COUNT(DISTINCT(SCRSSN))
FROM #INPAT_ACS_REC




-- SEE IF PATIENTS HAD ACS AS PRIMARY DIAGNOSIS BEFORE VISIT DATE...



SELECT A.PatientSID, C.scrssn, A.VisitDateTime, C.visitdate
	
INTO #OUTPAT_ACS10

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #ACSSID AS B
ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE  
	C.visitdate > A.VisitDateTime

-- FOR ICD9 NOW 

SELECT A.PatientSID, C.scrssn, A.VisitDateTime, C.visitdate
	
INTO #OUTPAT_ACS9

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #ACSICD9 AS B
ON A.ICD9SID = B.ICD9SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE  
	C.visitdate > A.VisitDateTime AND 
	DATEDIFF(DAY, VISITDATETIME, VISITDATE) BETWEEN 0 AND 365


-- NOW TO JOIN ALL THE DATASETS TOGETHER 

SELECT DISTINCT SCRSSN 

INTO DFLT.ALI_ACS_RECENT

FROM #INPAT_ACS_REC
UNION ALL 

SELECT DISTINCT SCRSSN 
FROM #OUTPAT_ACS10 
UNION ALL 

SELECT DISTINCT SCRSSN 
FROM #OUTPAT_ACS9

-- ckd 

select A.ICD10Code, A.ICD10SID
INTO #CKDICD10
from CDWWORK.DIM.ICD10 AS A
	WHERE ICD10CODE LIKE 'N18.%' OR 
	ICD10CODE LIKE 'N18%' OR 
	ICD10Code LIKE 'Z94.0'


select A.ICD9Code, A.ICD9SID
INTO #CKDICD9
from CDWWORK.DIM.ICD9 AS A
	WHERE ICD9Code LIKE '585%' OR 
	ICD9Code LIKE '585.%' 

-- outpat ckd diagnosis 



SELECT distinct C.scrssn
	
INTO #OUTPAT_ckd10

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #CKDICD10 AS B
ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE  
	C.visitdate > A.VisitDateTime


-- outpat ckd9 


SELECT distinct C.scrssn
	
INTO #OUTPAT_ckd9

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #CKDICD9 AS B
ON A.ICD9SID = B.ICD9SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE  
	C.visitdate > A.VisitDateTime

select *
into dflt.ali_ckd
from #OUTPAT_ckd9 
union all 
select * 
from #OUTPAT_ckd9


-- familial hyperchol



select A.ICD10Code, A.ICD10SID
INTO #HCLICD10
from CDWWORK.DIM.ICD10 AS A
	WHERE ICD10CODE LIKE 'E78.01' 


DROP TABLE #HCLICD9

select A.ICD9Code, A.ICD9SID
INTO #HCLICD9
from CDWWORK.DIM.ICD9 AS A
	WHERE ICD9Code LIKE '272.0' 

-- FAM HCL COHORT 



SELECT distinct C.scrssn
	
-- INTO DFLT.ALI_HCL

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #HCLICD10 AS B
ON A.ICD10SID = B.ICD10SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE  
	C.visitdate > A.VisitDateTime

union all 
-- outpat ckd9 


SELECT distinct C.scrssn
	
-- INTO #OUTPAT_ckd9

FROM SRC.Outpat_VDiagnosis AS A
INNER JOIN #HCLICD9 AS B
ON A.ICD9SID = B.ICD9SID

INNER JOIN DFLT.OUTPAT_ALI_BASECOHORT AS C
ON A.PatientSID = C.PatientSID
	WHERE  
	C.visitdate > A.VisitDateTime

-- define ischemic stroke 

select ICD10Code, ICD10SID
into #stricd10
from CDWWork.dim.ICD10
where ICD10Code like 'Z86.73%' or
icd10code like 'I63.9%'




select distinct c.scrssn
into dflt.ali_stroke
from src.Outpat_VDiagnosis as a
inner join #stricd10 as b
on a.ICD10SID = b.ICD10SID
inner join dflt.OUTPAT_ALI_BASECOHORT as c
on a.PatientSID = c.PatientSID
	where a.visitdatetime < c.visitdate


