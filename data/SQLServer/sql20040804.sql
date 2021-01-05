/*
BUG 87 学历维护的权限bug-王金永
*/
delete from SystemRightToGroup where rightid=382
GO
insert into SystemRightToGroup (groupid,rightid) values (3,382) 
GO
update SystemRightRoles set rolelevel='2' where rightid=382
GO 
delete from SystemRightToGroup where rightid=127
GO
insert into SystemRightToGroup (groupid,rightid) values (3,127) 
GO
delete from SystemRightRoles where rightid=127
GO 
insert into SystemRightRoles (rightid,roleid,rolelevel) values (127,4,'2') 
GO 

/**
*For bug 87,
*删除 工作简历维护，教育情况维护，家庭情况维护，成本中心维护权限
*
*/
/*工作简历*/
DELETE FROM SystemRights WHERE id=128 
GO
DELETE FROM SystemRightsLanguage WHERE id=128
GO
DELETE FROM SystemRightDetail WHERE rightid=128
GO
DELETE FROM systemrighttogroup WHERE Rightid=128
GO
DELETE FROM SystemRightRoles WHERE RightID =128  
GO

/*教育情况*/
DELETE FROM SystemRights WHERE id= 129
GO
DELETE FROM SystemRightsLanguage WHERE id=129
GO
DELETE FROM SystemRightDetail WHERE rightid=129
GO
DELETE FROM systemrighttogroup WHERE Rightid=129
GO
DELETE FROM SystemRightRoles WHERE RightID = 129 
GO

/*家庭情况*/
DELETE FROM SystemRights WHERE id= 130
GO
DELETE FROM SystemRightsLanguage WHERE id= 130
GO
DELETE FROM SystemRightDetail WHERE rightid= 130
GO 
DELETE FROM systemrighttogroup WHERE Rightid= 130
GO
DELETE FROM SystemRightRoles WHERE RightID =  130
GO

/*成本中心*/
DELETE FROM SystemRights WHERE id= 20
GO
DELETE FROM SystemRightsLanguage WHERE id=20
GO
DELETE FROM SystemRightDetail WHERE rightid=20
GO
DELETE FROM systemrighttogroup WHERE Rightid=20
GO
DELETE FROM SystemRightRoles WHERE RightID = 20 
GO
/*成本中心类别维护*/
DELETE FROM SystemRights WHERE id=21
GO
DELETE FROM SystemRightsLanguage WHERE id=21
GO
DELETE FROM SystemRightDetail WHERE rightid=21
GO
DELETE FROM systemrighttogroup WHERE Rightid=21
GO
DELETE FROM SystemRightRoles WHERE RightID =21
GO

/*
bug:93 显示栏目维护权限没有默认的角色设置 by 王金永 
*/
delete from SystemRights where id = 309
go
delete from SystemRightsLanguage where id = 309
go
delete from SystemRightDetail where id=2009
go 
insert into SystemRights (id,rightdesc,righttype) values (309,'显示栏目维护','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (309,7,'显示栏目维护','显示栏目维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (309,8,'ShowColumn','ShowColumn') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (2009,'显示栏目维护','ShowColumn:Operate',309) 
GO
delete from SystemRightToGroup where rightid=309
go
insert into SystemRightToGroup (groupid,rightid) values (3,309) 
GO
delete from SystemRightRoles where rightid=309
GO 
insert into SystemRightRoles (rightid,roleid,rolelevel) values (309,4,'2') 
GO

/**
*For Bug 99 ,图形编辑维护权限的默认角色设置为总部级别的人力资源管理员。
*/
insert into SystemRights (id,rightdesc,righttype) values (417,'组织架构图形编辑','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (417,8,'Organization Hiberarchy Chart','Organization Hiberarchy Chart') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (417,7,'组织架构图形编辑','组织架构图形编辑') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3107,'组织架构图形编辑','HrmDepartLayoutEdit:Edit',417) 
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,417)
go
DELETE FROM SystemRightRoles WHERE RightID = 417 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (417,4,2)
GO

/*For Bug 119， Modified by Charoes Huang On May 28,2004*/

ALTER   PROCEDURE Employee_SByStatus
	@flag		int	output, 
	@msg		varchar(80) output
as
declare
@hrmid_1 int,
@id_1 int,
@lastname_1 varchar(60),
@sex_1 char(1),
@startdate_1 char(10),
@departmentid_1 int,
@joblevel_1 tinyint,
@managerid_1 int

CREATE table #temp(id int, lastname  varchar(60) , sex  char(1), startdate	char(10), departmentid	int, joblevel	tinyint, managerid int )
  
declare employee_cursor cursor for 

/*此处被修改，必须要除去人力资源表中不存在的hrmid !! Modified Start*/
select distinct(hrmid) from HrmInfoStatus t1,HrmResource t2 where t1.status ='0' and t1.hrmid = t2.id
/*Modified END*/
open employee_cursor fetch next from employee_cursor into @hrmid_1
	while @@fetch_status=0  
	begin
	select 		 @id_1=id,@lastname_1=lastname,@sex_1=sex,@startdate_1=startdate,@departmentid_1=departmentid,@joblevel_1=joblevel,@managerid_1=managerid from HrmResource WHERE id=@hrmid_1
	insert INTO #temp(id,lastname,sex,startdate,departmentid,joblevel,managerid)
	values(@id_1,@lastname_1,@sex_1,@startdate_1,@departmentid_1,@joblevel_1,@managerid_1)
	fetch next from employee_cursor into @hrmid_1
	end
	close employee_cursor deallocate employee_cursor
	select * from #temp

GO

/* bug 183 Added BY Huang Yu,增加培训资源到日志条目基本表中*/
DELETE FROM SystemLogItem WHERE itemid = 68
GO
INSERT INTO SystemLogItem (itemid,lableid,itemdesc) VALUES (68,15879,'培训资源')
GO

/*合同种类维护 权限 BUG 208*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=383
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,383)
GO
DELETE FROM SystemRightRoles WHERE RightID = 383 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (383,4,2)
GO

/*Bug 216, 将“合同维护”权限归纳到“人力资源管理权限组”中*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=384
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,384)
GO
DELETE FROM SystemRightRoles WHERE RightID = 384 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (384,4,2)
GO

/* bug：226 Created By Charoes Huang On May 21,2004*/
INSERT INTO HtmlLabelIndex values(17411,'试用期结束日期必须在合同开始和结束日期之间') 
GO
INSERT INTO HtmlLabelInfo VALUES(17411,'试用期结束日期必须在合同开始和结束日期之间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17411,'The probation end date must be betwee the start date and end date of the contract!',8) 
GO

/**
*Create by Charoes Huang
*Date July 16 ,2004
*Description : For bug 229,设置 流程用工需求的 提交人默认为显示
*/

update workflow_nodeform set isview=1 where nodeid=233 and fieldid=412
GO
update workflow_nodeform set isview=1 where nodeid=234 and fieldid=412
GO
update workflow_nodeform set isview=1 where nodeid=235 and fieldid=412
GO
update workflow_nodeform set isview=1 where nodeid=236 and fieldid=412
GO
update workflow_nodeform set isview=1 where nodeid=237 and fieldid=412
GO

/*BUG270  hangyu */
DELETE FROM SystemRights WHERE id = 122
GO
DELETE FROM SystemRightsLanguage WHERE id = 122
GO
DELETE FROM SystemRightDetail WHERE rightid = 122
GO
insert into SystemRights (id,rightdesc,righttype) values (122,'培训种类维护','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (122,7,'培训种类维护','培训种类维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (122,8,'TrainTypeMaintenance','TrainTypeMaintenance') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (410,'培训种类添加','HrmTrainTypeAdd:Add',122) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (411,'培训种类编辑','HrmTrainTypeEdit:Edit',122) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (412,'培训种类删除','HrmTrainTypeEdit:Delete',122) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (413,'培训种类日志查看','HrmTrainType:Log',122) 
GO
/*更改默认为人力资源管理组的权限*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=122
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,122)
GO
DELETE FROM SystemRightRoles WHERE RightID = 122 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (122,4,2)
GO

/*Bug 274, 将“培训规划”权限归纳到“人力资源管理权限组”中*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=370
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,370)
GO
DELETE FROM SystemRightRoles WHERE RightID = 370 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (370,4,2)
GO

/*Bug 283, 将“培训资源”权限归纳到“人力资源管理权限组”中*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=372
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,372)
GO
DELETE FROM SystemRightRoles WHERE RightID = 372 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (372,4,2)
GO

/*BUG286 删除培训安排，培训活动的权限 */
/*培训安排*/
DELETE FROM SystemRights WHERE id = 371
GO
DELETE FROM SystemRightsLanguage WHERE id = 371
GO
DELETE FROM SystemRightDetail WHERE rightid = 371
GO
DELETE FROM SystemRightToGroup WHERE rightid=371
GO
DELETE FROM SystemRightRoles WHERE RightID = 371 
GO
/*培训活动*/
DELETE FROM SystemRights WHERE id = 373
GO
DELETE FROM SystemRightsLanguage WHERE id = 373
GO
DELETE FROM SystemRightDetail WHERE rightid = 373
GO
DELETE FROM SystemRightToGroup WHERE rightid=373
GO
DELETE FROM SystemRightRoles WHERE RightID = 373 
GO

/*更改'专业维护'权限 默认为人力资源管理组的权限*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=125
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,125)
GO
DELETE FROM SystemRightRoles WHERE RightID = 125 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (125,4,2)
GO

/*For Bug 290 with Modified By Charoes Huang ,May 31,2004*/
ALTER  procedure HrmTrain_Insert
(@name_1 varchar(60),
 @planid_2 int,
 @organizer_3 varchar(200),
 @startdate_4 char(10),
 @enddate_5 char(10),
 @content_6 text,
 @aim_7 text,
 @address_8 varchar(200),
 @resource_n_9 varchar(200), 
 @createrid_10 int,
 @testdate_11 char(10),
 @flag int output , @msg varchar(60) output)
as insert into HrmTrain
(name,
 planid,
 organizer,
 startdate,
 enddate,
 content,
 aim,
 address,
 resource_n, 
 createrid,
 testdate)
values
(@name_1,
 @planid_2,
 @organizer_3,
 @startdate_4,
 @enddate_5,
 @content_6,
 @aim_7,
 @address_8,
 @resource_n_9, 
 @createrid_10,
 @testdate_11)
 select max(id) from HrmTrain /* Modified From ' select max(id) from HrmTrainDay'*/
GO

/*for id=298 by 王金永*/
update workflow_base set isvalid='1' where id=26 and workflowname='培训申请'
GO


/*Created By Charoes Huang On May 19,2004 FOR BUG 301
 *奖惩类型维护 ->奖惩种类维护	
*/
DELETE SystemRights WHERE id = 123
GO
DELETE SystemRightsLanguage WHERE id = 123
GO
DELETE SystemRightDetail WHERE rightid = 123
GO
insert into SystemRights (id,rightdesc,righttype) values (123,'奖惩种类维护','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (123,7,'奖惩种类维护','奖惩种类维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (123,8,'Awards-Punishments Type Maintenance','Awards-Punishments Type Maintenance') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (414,'奖惩种类添加','HrmRewardsTypeAdd:Add',123) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (415,'奖惩种类编辑','HrmRewardsTypeEdit:Edit',123) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (416,'奖惩种类删除','HrmRewardsTypeEdit:Delete',123) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (417,'奖惩种类日志查看','HrmRewardsType:Log',123) 
GO
/*更改默认为人力资源管理组的权限*/
DELETE systemrighttogroup WHERE GroupID = 3 and rightid=123
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,123)
GO
DELETE SystemRightRoles WHERE RightID = 123 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (123,4,1)
GO

/*更改默认为人力资源管理组的权限*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=123
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,123)
GO
DELETE FROM SystemRightRoles WHERE RightID = 123 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (123,4,1)
GO

/*
* For Bug 304
* Created By Charoes Huang ,June 1,2004
*/
CREATE  PROCEDURE HrmTrainTest_Update
(@trainid_1 int,
 @resourceid_2 int,
 @testdate_3 char(10),
 @result_4 int,
 @explain_5 text,
 @testerid_6 int,
 @id_7 int,
 @flag int output, @msg varchar(60) output)
as 
   UPDATE HrmTrainTest
      SET resourceid = @resourceid_2,
	  testdate = @testdate_3,
	  result = @result_4,
          explain = @explain_5
      WHERE ID = @id_7
	
GO

/*
Created By Charoes Huang On May 30,2004
FOR BUG 313, 删除权限没有插入数据库*/
DELETE FROM SystemRights WHERE id = 387
GO
DELETE FROM SystemRightsLanguage WHERE id = 387
GO
DELETE FROM SystemRightDetail WHERE rightid = 387
GO
insert into SystemRights (id,rightdesc,righttype) values (387,'人力资源考核项目维护','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,7,'人力资源考核项目维护','人力资源考核项目新建，编辑和删除') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,8,'HRMTestItemMaintenance','New,Edit and Delete HRMTestItem') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,7,'人力资源考核项目维护','人力资源考核项目新建，编辑和删除') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,8,'HRMTestItemMaintenance','New,Edit and Delete HRMTestItem') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3054,'人力资源考核项目新建','HrmCheckItemAdd:Add',387) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3055,'人力资源考核项目编辑','HrmCheckItemEdit:Edit',387) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3128,'人力资源考核项目删除','HrmCheckItemEdit:Delete',387) 
GO
/*更改默认为人力资源管理组的权限*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=387
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,387)
GO
DELETE FROM SystemRightRoles WHERE RightID = 387 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (387,4,1) /*分部级别的权限*/
GO
/*
Created By Charoes Huang On May 19,2004
FOR BUG 414*/
INSERT INTO HtmlLabelIndex values(17408,'考核期必须大于零') 
GO
INSERT INTO HtmlLabelInfo VALUES(17408,'考核期必须大于零',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17409,'The test period must be larger than zero!',8) 
GO

/**
 *For Bug 426
 *Created by Charoes Huang, June 2,2004
 *
*/
INSERT INTO HtmlLabelIndex values(17425,'被考核岗位') 
GO
INSERT INTO HtmlLabelInfo VALUES(17425,'被考核岗位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17425,'Post Examined',8) 
GO

/*
 * Script Created ON : May 20,2004
 * Author : Charoes lu peng
*/
/*FOR BUG 436 修改了修改了存储过程FnaYearsPeriodsList_SByFnayear，增加对Periodsid排序*/
ALTER PROCEDURE FnaYearsPeriodsList_SByFnayear (
@id_1 	[int], @flag integer output , @msg varchar(80) output)
AS 
SELECT * FROM FnaYearsPeriodsList WHERE fnayearid = @id_1 ORDER BY Periodsid
GO

/*FOR BUG 449 修改了FnaLoanLog表的description字段长度为4000*/
ALTER TABLE FnaLoanLog alter column description varchar(4000)
go

/*FOR BUG 522,by 路鹏*/
DELETE SystemRightRoles WHERE rightid = 137 AND roleid = 2
go

/*FOR BUG 528 and 540,by 路鹏*/
insert into HtmlNoteIndex (id,indexdesc) values (56,'该资产组下已设置资产，不能再新建资产组。') 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (56, '该资产组下已设置资产，不能再新建资产组。', 7) 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (56, 'Can''t create a capital group under this group.', 8) 
GO


/*FOR BUG 538,by 路鹏*/
UPDATE SystemLogItem SET lableid=831, itemdesc='资产组' WHERE itemid=43
go


/*for:546 资产类型的日志显示的是文档编辑模板的日志 */
UPDATE SysMaintenanceLog SET operateitem = 44 WHERE operatedesc LIKE 'CptCapitalType%'
go

/*FOR BUG 547 被引用的资产类型，却能被删除,by 路鹏*/
ALTER PROCEDURE CptCapitalType_Delete (
@id_1 int,
@flag integer output,
@msg varchar(80) output)
AS
IF EXISTS (SELECT id FROM CptCapital WHERE capitaltypeid = @id_1)
BEGIN
SELECT -1 
RETURN
END
DELETE CptCapitalType WHERE [id] = @id_1
GO

/*FOR BUG 553 在新建时自动将数据库记录ID赋给“标识”字段。by 路鹏*/
ALTER PROCEDURE LgcAssetUnit_Insert (
@unitmark_1 	[varchar](60), 
@unitname_2 	[varchar](60), 
@unitdesc_3 	[varchar](200), 
@flag integer output , 
@msg varchar(80) output)  
AS 
DECLARE @unitId integer
INSERT INTO [LgcAssetUnit] 
( [unitmark], [unitname], [unitdesc])  
VALUES ( @unitmark_1, @unitname_2, @unitdesc_3)
select @unitId = max(id) from LgcAssetUnit
UPDATE LgcAssetUnit 
SET unitmark = CONVERT(varchar(60), @unitId) WHERE [id] = @unitId
GO
/* Create the set marks stored procedure */
CREATE PROCEDURE LgcAssetUnit_SetAllMarks 
AS
DECLARE @m_id int
DECLARE @m_mark varchar(60)
DECLARE all_cursor CURSOR FOR
SELECT id, unitmark FROM LgcAssetUnit
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_id, @m_mark
WHILE (@@FETCH_STATUS = 0)
BEGIN
IF (@m_mark IS NULL OR @m_mark = '')
UPDATE LgcAssetUnit SET unitmark = CONVERT(varchar(60), @m_id) WHERE [id] = @m_id
FETCH NEXT FROM all_cursor INTO @m_id, @m_mark
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO
/* end */


/* Invoke the above stored procedure */
EXEC LgcAssetUnit_SetAllMarks
DROP PROCEDURE LgcAssetUnit_SetAllMarks
GO
/* end */

/*FOR BUG 554 在计量单位删除的存储过程中增加了对资产资料引用的判断 by 路鹏*/
ALTER PROCEDURE LgcAssetUnit_Delete (
@id_1 	[int], @flag integer output , @msg varchar(80) output)
AS
DECLARE @count int  
SELECT @count = count(id) FROM LgcAsset WHERE assetunitid = @id_1
IF @count <> 0
BEGIN 
SELECT -1 RETURN
END
SELECT @count = count(id) FROM CptCapital WHERE unitid = @id_1 
IF @count <> 0 
BEGIN 
SELECT -1 RETURN 
END
DELETE [LgcAssetUnit] WHERE ( [id]	 = @id_1)
GO

/*td:555 */
UPDATE SystemRights SET rightdesc = '资产自定义的信息维护' WHERE id = 119
go
UPDATE SystemRightsLanguage SET rightname = '资产自定义信息维护', rightdesc='资产自定义信息维护' WHERE id = 119 AND languageid=7
go
UPDATE SystemRightDetail SET rightdetailname = '资产自定义信息维护' WHERE rightid = 119
go
/*FOR BUG 556 资产'自定义信息'列表和编辑页面的页头错误 by 路鹏*/
INSERT INTO HtmlLabelIndex values(17476,'资产自定义字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(17476,'资产自定义字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17476,'User Definition Field',8) 
GO
/*td:558 by lp */
insert into SystemRights (id,rightdesc,righttype) values (439,'资产资料维护','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (439,7,'资产资料维护','资产资料维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (439,8,'Capital Maintenance','Capital Maintenance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3130,'资产资料维护','Capital:Maintenance',439) 
GO
insert into SystemRightToGroup (groupid, rightid) values (9, 439)
GO
insert into SystemRightRoles (rightid, roleid, rolelevel) values (439, 7, '2')
GO

CREATE PROCEDURE CptCapital_ForcedDelete (
@id_1 [int], @flag integer output, @msg varchar(80) output)  
AS 
UPDATE CptCapitalAssortment SET capitalcount = capitalcount-1 
WHERE id IN (SELECT capitalgroupid FROM CptCapital WHERE id = @id_1)  
DELETE [CptCapital] WHERE [id] = @id_1 
GO
/*FOR BUG620 (3) ,专业设置的日志*/
DELETE FROM SystemLogItem WHERE ItemID = '63'
GO
INSERT INTO SystemLogItem(itemid,lableid,itemdesc) Values ('63',16463,'专业设置')
GO