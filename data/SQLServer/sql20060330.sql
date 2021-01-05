alter table WorkflowReportShare add mutidepartmentid VARCHAR(1000) null
GO
alter table WorkflowReportShareDetail add mutidepartmentid VARCHAR(1000) null
GO

INSERT INTO HtmlLabelIndex values(18512,'同分部') 
GO
INSERT INTO HtmlLabelIndex values(18513,'同部门下级部门') 
GO
INSERT INTO HtmlLabelIndex values(18511,'同部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(18511,'同部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18511,'in the same department',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18512,'同分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18512,'in the same SubCompany',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18513,'同部门下级部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18513,'in the same Department of lower',8) 
GO
ALTER PROCEDURE WorkflowReportShare_Insert
(@reportid_1       int,
 @sharetype_1	int,
 @seclevel_1	tinyint,
 @rolelevel_1	tinyint,
 @sharelevel_1	tinyint,
 @userid_1	int,
 @subcompanyid_1	int,
 @departmentid_1	int,
 @roleid_1	int,
 @foralluser_1	tinyint,
 @crmid_1	int,
 @mutidepartmentid_1 varchar(1000),
 @flag	int output,
 @msg	varchar(80)	output)
as 
insert into WorkflowReportShare(reportid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,mutidepartmentid) 
values(@reportid_1,@sharetype_1,@seclevel_1,@rolelevel_1,@sharelevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@roleid_1,@foralluser_1,@crmid_1,@mutidepartmentid_1)

GO

alter PROCEDURE WkfReportShareDetail_Insert 
(@reportid_1 	int,
@userid_2 	int, 
@usertype_3 	int, 
@sharelevel_4 	int ,
@mutidepartmentid_5 varchar(1000), 
@flag int 	output, 
@msg 	varchar(80) output) 
AS 
INSERT INTO WorkflowReportShareDetail ( reportid, userid, usertype, sharelevel,mutidepartmentid)  
VALUES ( @reportid_1, @userid_2, @usertype_3, @sharelevel_4,@mutidepartmentid_5)
GO