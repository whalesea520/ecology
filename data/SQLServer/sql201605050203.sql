CREATE VIEW HrmResourceAllView
AS
SELECT id,loginid,workcode,lastname,sex,email,resourcetype,locationid,departmentid,subcompanyid1,
costcenterid,jobtitle,managerid,assistantid,joblevel,seclevel,status,account,mobile,password,systemLanguage,
telephone,managerstr,messagerurl,dsporder,accounttype,belongto FROM HrmResource 
UNION ALL
SELECT id,loginid,'' AS workcode,lastname,'' AS sex, '' AS email,'' AS resourcetype,0 AS locationid,0 AS departmentid,0 AS subcompanyid1,
0 AS costcenterid,0 AS jobtitle,0 AS managerid,0 AS assistantid,0 AS joblevel,seclevel,status,'' AS account,mobile,password,systemLanguage,
'' AS telephone,'' AS managerstr,'' AS messagerurl , id AS dsporder,0 AS accounttype, 0 AS belongto
FROM HrmResourceManager 
GO
