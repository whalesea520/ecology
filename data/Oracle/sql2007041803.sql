UPDATE WorkPlan SET endDate = createDate
WHERE ((beginDate = '' OR beginDate is null) AND (endDate = '' OR endDate is null))
/

UPDATE WorkPlan SET beginDate = createDate
WHERE (beginDate = '' OR beginDate is null)
/

UPDATE WorkPlan SET beginTime = '09:00' WHERE (beginDate <> '' AND beginDate IS NOT null) AND (beginTime = '' OR beginTime IS null)
/

UPDATE WorkPlan SET endTime = '17:00' WHERE (beginDate <> '' AND beginDate IS NOT null) AND (endDate <> '' AND endDate IS NOT null) AND (endTime = '' OR endTime IS null)
/