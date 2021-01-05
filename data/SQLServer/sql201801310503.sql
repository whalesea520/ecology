begin
  declare @n int,@i int,@x int ;
  declare @tbstr varchar(500) ;
  declare @tb varchar(25) ;
  declare @colstr varchar(200);
  declare @col varchar(25) ;
  declare @tp varchar(25) ;
  declare @sql varchar(300);
  
  set @tbstr = 'HrmSubCompany,HrmDepartment,HrmJobTitles,HrmJobActivities,HrmJobGroups,HrmResource,HrmResourceManager,' ;
  
  while CHARINDEX(',',@tbstr) > 0
  begin 
     set @i=CHARINDEX(',',@tbstr) ;
		set @tb = SUBSTRING(@tbstr,0,@i) ;    
		set @tbstr=SUBSTRING(@tbstr,@i+1,len(@tbstr));	
	
		if COL_LENGTH(@tb, 'created') is null 
      BEGIN
         EXEC('ALTER TABLE '+@tb+' ADD created DATETIME');
      end ;
    if COL_LENGTH(@tb, 'creater') is null 
      BEGIN
         exec('ALTER TABLE '+@tb+' ADD creater INT') ;
      end ;
    if COL_LENGTH(@tb, 'modified') is null 
      BEGIN
         exec('ALTER TABLE '+@tb+' ADD modified DATETIME') ;
      end ;
		if COL_LENGTH(@tb, 'modifier') is null 
      BEGIN
         exec('ALTER TABLE '+@tb+' ADD modifier INT') ;
      end ;
  end ;
end ;
go
ALTER VIEW HrmResourceAllView AS SELECT id,loginid,workcode,lastname,pinyinlastname ,sex,email,resourcetype,locationid,departmentid,subcompanyid1, costcenterid,jobtitle,managerid,assistantid,joblevel,seclevel,status,account,mobile,password,systemLanguage, telephone,managerstr,messagerurl,dsporder,accounttype,belongto, mobileshowtype,creater,created,modified,modifier FROM HrmResource UNION ALL SELECT id,loginid,'' AS workcode,lastname,'' as pinyinlastname ,'' AS sex, '' AS email,'' AS resourcetype,0 AS locationid,0 AS departmentid,0 AS subcompanyid1, 0 AS costcenterid,0 AS jobtitle,0 AS managerid,0 AS assistantid,0 AS joblevel,seclevel,status,'' AS account,mobile,password,systemLanguage, '' AS telephone,'' AS managerstr,'' AS messagerurl , id AS dsporder,0 AS accounttype, 0 AS belongto, 0 as mobileshowtype,creater,created,modified,modifier FROM HrmResourceManager
GO
UPDATE HrmSubCompany SET created = GETDATE()
GO
UPDATE HrmSubCompany SET modified  = GETDATE()
GO
UPDATE HrmDepartment SET created  = GETDATE()
GO
UPDATE HrmDepartment SET modified  = GETDATE()
GO
UPDATE HrmJobTitles SET created  = GETDATE()
GO
UPDATE HrmJobTitles SET modified  = GETDATE()
GO
UPDATE HrmJobActivities SET created  = GETDATE()
GO
UPDATE HrmJobActivities SET modified  = GETDATE()
GO
UPDATE HrmJobGroups SET created  = GETDATE()
GO
UPDATE HrmJobGroups SET modified  = GETDATE()
GO
UPDATE HrmResource SET created  = GETDATE()
GO
UPDATE HrmResource SET modified  = GETDATE()
GO
UPDATE HrmResourceManager SET created  = GETDATE()
GO
UPDATE HrmResourceManager SET modified  = GETDATE()
GO