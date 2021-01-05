ALTER TABLE WorkPlanShareSet ADD seclevelMax INT
GO
ALTER TABLE WorkPlanShareSet ADD sseclevelMax INT
GO

UPDATE WorkPlanShareSet SET seclevelMax = 255 WHERE seclevelMax IS NULL
GO
UPDATE WorkPlanShareSet SET sseclevelMax = 255 WHERE sseclevelMax IS NULL
GO

ALTER TABLE WorkPlanShare ADD securityLevelMax INT
GO

UPDATE WorkPlanShare SET securityLevelMax = 255 WHERE securityLevelMax IS NULL
GO


create table workplan_disremindtime (
       userid integer,
       usertype integer,
       remindtime VARCHAR(19)
)
GO


ALTER PROCEDURE WorkPlanShare_Ins ( @workPlanId_1 int, @shareType_1 char(1), @userId_1 varchar(1600), @subCompanyID_1 varchar(1600), @deptId_1 varchar(1600), @roleId_1 varchar(1600), @forAll_1 char(1), @roleLevel_1 char(1), @securityLevel_1 tinyint, @shareLevel_1 char(1), @securityLevelMax_1 tinyint, @flag integer output , @msg varchar(80) output ) AS  INSERT INTO WorkPlanShare ( workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel, securityLevelMax ) VALUES ( @workPlanId_1, @shareType_1, @userId_1, @subCompanyID_1, @deptId_1, @roleId_1, @forAll_1, @roleLevel_1, @securityLevel_1, @shareLevel_1, @securityLevelMax_1 ) 
GO

ALTER  PROCEDURE WorkPlanShareSet_Insert 	
(@reportid_1       int, 	
@sharetype_1	int, 
@seclevel_1	int, 
@rolelevel_1	int, 
@sharelevel_1	int, 
@userid_1	varchar(8000), 
@subcompanyid_1	varchar(8000), 
@departmentid_1	varchar(8000), 
@roleid_1	int, 
@foralluser_1	int, 
@sharetype_2	int, 
@seclevel_2	int, 
@rolelevel_2	int, 
@userid_2	varchar(8000), 
@subcompanyid_2	varchar(8000), 
@departmentid_2	varchar(8000), 
@roleid_2	int, 
@foralluser_2	int, 
@settype_1	int, 
@seclevelMax_1	int, 
@sseclevelMax_1	int, 
@flag  	int output, 
@msg 	varchar output) 
as insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid, departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype,seclevelMax,sseclevelMax) values(@reportid_1,@sharetype_1,@seclevel_1,@rolelevel_1,@sharelevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@roleid_1,@foralluser_1,@sharetype_2, @seclevel_2,@rolelevel_2,@userid_2,@subcompanyid_2,@departmentid_2,@roleid_2,@foralluser_2,@settype_1,@seclevelMax_1,@sseclevelMax_1) 	
GO