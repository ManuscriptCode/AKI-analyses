-- totalBal : doing

SELECT itemid,
SUBJECT_ID, 
ICUSTAY_ID, 
charttime,
CUMVOLUME 
FROM MIMIC2V26.TOTALBALEVENTS
WHERE itemid IN (1,3151)
AND ICUSTAY_ID IS NOT NULL
AND SUBJECT_ID IS NOT NULL
AND CUMVOLUME IS NOT NULL

ORDER BY itemid,
subject_id,
icustay_id,
charttime
         
		 
-- item id in = (1: 24 hour total in : majority ,	3151: 24 hour total in) 12: 12, 11: 11, 
-- seperately, then join

		 

-- Vasopressors: done
SELECT DISTINCT subject_id,
icustay_id,
charttime,
dose 

FROM MIMIC2V26.medevents

WHERE itemid  IN (42, 43, 44, 46, 47, 51, 119, 120, 125, 127, 128, 306, 307, 309)
AND dose    <>0
AND ICUSTAY_ID IS NOT NULL

ORDER BY subject_id,
 icustay_id,
 charttime		 

  
 -- MAP   456: non-invasive MAP, 52: invasive: more reliable
 
SELECT itemid,
subject_id,
icustay_id,
charttime,
value1num

FROM MIMIC2V26.CHARTEVENTS
WHERE ITEMID IN (52,456) -- Invasive (Arterial) Blood Pressure (IABP/IBP)  get noninvasive one also
AND icustay_id IS NOT NULL
AND value1num IS NOT NULL
ORDER BY itemid,subject_id,icustay_id,charttime

-- Height 

select subject_id,
icustay_id, height
from MIMIC2V26.icustay_detail
WHERE icustay_id IS NOT NULL
AND HEIGHT IS NOT NULL
ORDER BY subject_id,icustay_id





-- Height 2
select subject_id,
icustay_id, height_in_cm
from MIMIC2DEVEL.OBESITY_BMI
WHERE icustay_id IS NOT NULL
AND HEIGHT_IN_CM IS NOT NULL
ORDER BY subject_id,icustay_id  
  
  
-- Creatinine
Select subject_id,
icustay_id,
charttime,
valuenum
FROM MIMIC2V26.labevents
WHERE itemid   = 50090
AND icustay_id IS NOT NULL
AND valuenum IS NOT NULL
ORDER BY subject_id,icustay_id,charttime

-- ICUSTAYINTIME
select subject_id,
icustay_id,
ICUSTAY_INTIME
from MIMIC2V26.ICUSTAY_Detail
WHERE icustay_id IS NOT NULL
AND ICUSTAY_INTIME IS NOT NULL
ORDER BY subject_id,icustay_id

