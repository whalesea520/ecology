create table HrmResource_Trigger
(id int not null,
 managerid int null,
 departmentid int null,
 subcompanyid1 int null,
 seclevel tinyint null,
 managerstr varchar(200) null)
go

alter procedure HrmTrain_Delete
(@id_1 int,
 @flag int output , @msg varchar(60) output)
as delete HrmTrain 
where
 id = @id_1
delete from HrmTrainActor
where 
  traindayid in (select id from HrmTrainDay where trainid = @id_1)
delete from HrmTrainDay
where
  trainid = @id_1
delete from HrmTrainAssess
where
  trainid = @id_1
delete from HrmTrainTest
where
  trainid = @id_1
GO

CREATE PROCEDURE HrmResource_Trigger_Insert
	(@id_1 	int,
	 @managerid_2 	int,
	 @departmentid_3 	int,
	 @subcompanyid1_4 	int,
	 @seclevel_5 	tinyint,
	 @managerstr_6 	varchar(200),
	 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmResource_Trigger 
	 ( id,
  	   managerid,
 	   departmentid,
	   subcompanyid1,
	   seclevel,
	   managerstr) 
 
VALUES 
	( @id_1,
	 @managerid_2,
	 @departmentid_3,
	 @subcompanyid1_4,
	 @seclevel_5,
	 @managerstr_6)
go

insert into HrmResource_Trigger(id,managerid,departmentid,subcompanyid1,seclevel,managerstr)values(1,1,1,1,30,'1,')
go
insert into HrmResource_Trigger(id,managerid,departmentid,subcompanyid1,seclevel,managerstr)values(2,1,1,1,30,'1,')
go

delete HrmJobActivities where jobgroupid not in (select id from HrmJobGroups)
go

delete HrmJobTitles where jobactivityid not in (select id from HrmJobActivities) or jobdepartmentid not in (select id from HrmDepartment)
go

delete HrmCostcenter where departmentid not in (select id from HrmDepartment)
go

alter table license add portal char
GO

update license set portal='n'
GO

DELETE FROM CRM_CustomizeOption WHERE (id IN (118, 122, 123, 204, 205, 213, 214))
go

UPDATE CRM_CustomizeOption SET labelname = '简称(英文)' WHERE (id = 103)
go

UPDATE CRM_CustomizeOption SET labelname = '代理' WHERE (id = 126)
go

UPDATE CRM_CustomizeOption SET labelname = '上级单位' WHERE (id = 127)
go

UPDATE CRM_CustomizeOption SET fieldname = 'firstname', labelname = '姓名' WHERE (id = 203)
go

DELETE FROM CRM_Customize
go

  alter PROCEDURE Prj_Member_SelectSumByMember (@id	 [varchar] (10), @flag	[int]	output, @msg	[varchar](80)	output) AS select count(id) from prj_projectinfo where  ( ','+members+','  like '%,'+@id+',%' and isblock=1 ) or manager=@id
GO

  alter PROCEDURE LgcAsset_Update (@id_1 	int, @assetcountryid_2 int, @barcode_3 	varchar(30), @seclevel_4 	tinyint, @assetimageid_5 	int, @assettypeid_6 	int, @assetunitid_7 	int, @replaceassetid_8 	int, @assetversion_9 	varchar(20), @assetattribute_10 	varchar(100), @counttypeid_11 	int, @assortmentid_12 	int, @assortmentstr_13 	varchar(200), @relatewfid    int, @assetname_2 	varchar(60), @assetcountyid_3 	int, @startdate_4 	char(10), @enddate_5 	char(10), @departmentid_6 	int, @resourceid_7 	int, @assetremark_8 	text, @currencyid_9 	int, @salesprice_10 	varchar(30), @costprice_11 	varchar(30), @datefield1_12 	char(10), @datefield2_13 	char(10), @datefield3_14 	char(10), @datefield4_15 	char(10), @datefield5_16 	char(10), @numberfield1_17 	float, @numberfield2_18 	float, @numberfield3_19 	float, @numberfield4_20 	float, @numberfield5_21 	float, @textfield1_22 	varchar(100), @textfield2_23 	varchar(100), @textfield3_24 	varchar(100), @textfield4_25 	varchar(100), @textfield5_26 	varchar(100), @tinyintfield1_27 	char(1), @tinyintfield2_28 	char(1), @tinyintfield3_29 	char(1), @tinyintfield4_30 	char(1), @tinyintfield5_31 	char(1), @lastmoderid_32 	int, @lastmoddate_33 	char(10), @isdefault_1 		char(1), @Flag	int	output, @msg	varchar(80)	output)
   AS 
   set @salesprice_10 = convert(decimal(18,3) , @salesprice_10) set @costprice_11 = convert(decimal(18,3) , @costprice_11)  
   UPDATE LgcAsset SET  	 relatewfid = @relatewfid , barcode	 = @barcode_3, seclevel	 = @seclevel_4, assetimageid	 = @assetimageid_5, assettypeid	 = @assettypeid_6, assetunitid	 = @assetunitid_7, replaceassetid	 = @replaceassetid_8, assetversion	 = @assetversion_9, assetattribute	 = @assetattribute_10, counttypeid	 = @counttypeid_11, assortmentid	 = @assortmentid_12, assortmentstr	 = @assortmentstr_13  WHERE ( id	 = @id_1)  
   if  @assetcountryid_2=-1 begin select @assetcountryid_2=assetcountyid from LgcAssetCountry where assetid=@id_1 and isdefault='1' end 
   if  @isdefault_1='1' begin update LgcAssetCountry set isdefault='0' where assetid=@id_1 end
   UPDATE LgcAssetCountry SET      assetname	 = @assetname_2, assetcountyid = @assetcountyid_3, startdate	 = @startdate_4, enddate	 = @enddate_5, departmentid	 = @departmentid_6, resourceid	 = @resourceid_7, assetremark	 = @assetremark_8, currencyid	 = @currencyid_9, salesprice	 = @salesprice_10, costprice	 = @costprice_11, datefield1	 = @datefield1_12, datefield2	 = @datefield2_13, datefield3	 = @datefield3_14, datefield4	 = @datefield4_15, datefield5	 = @datefield5_16, numberfield1	 = @numberfield1_17, numberfield2	 = @numberfield2_18, numberfield3	 = @numberfield3_19, numberfield4	 = @numberfield4_20, numberfield5	 = @numberfield5_21, textfield1	 = @textfield1_22, textfield2	 = @textfield2_23, textfield3	 = @textfield3_24, textfield4	 = @textfield4_25, textfield5	 = @textfield5_26, tinyintfield1 = @tinyintfield1_27, tinyintfield2 = @tinyintfield2_28, tinyintfield3 = @tinyintfield3_29, tinyintfield4 = @tinyintfield4_30, tinyintfield5 = @tinyintfield5_31, lastmoderid	 = @lastmoderid_32, lastmoddate	 = @lastmoddate_33 , isdefault	= @isdefault_1  WHERE ( (assetid = @id_1) and (assetcountyid =@assetcountryid_2)) 
GO


alter PROCEDURE workflow_currentoperator_SWft 
  @userid		int,
@usertype	int, 
   @complete	int, @flag integer output ,
    @msg varchar(80) output  
    as 
    if @complete=0 
    begin 
    select count(distinct t1.requestid) typecount,t1.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 where t1.userid=@userid  and t1.usertype=@usertype and t1.isremark in( '0','1') and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype<>'3' group by t1.workflowtype 
    end 
    if @complete=1 
    begin 
    select count(distinct t1.requestid) typecount,t1.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 where t1.userid=@userid and t1.usertype=@usertype and t1.isremark ='0' and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype='3' group by t1.workflowtype 
    end
GO


alter PROCEDURE workflow_currentoperator_SWf 
  @userid		int, 
@usertype	int, 
  @complete	int, 
  @flag integer output , 
  @msg varchar(80) output  
  as 
  if @complete=0 
  begin 
  select count( distinct t1.requestid) workflowcount,t1.workflowid from workflow_currentoperator t1,workflow_requestbase t2 where t1.isremark in( '0','1') and t1.userid=@userid and t1.usertype=@usertype and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype<>'3' group by t1.workflowid 
  end 
  if @complete=1 begin select count( distinct t1.requestid) workflowcount,t1.workflowid from workflow_currentoperator t1,workflow_requestbase t2 where t1.isremark ='0' and t1.userid=@userid and t1.usertype=@usertype and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype='3' group by t1.workflowid 
  end
GO

/*2003年5月22日 建立了一个新的标签*/

insert into HtmlLabelIndex (id,indexdesc) values (7172,'奖惩报告')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7172,'奖惩报告',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7172,'',8)
GO

/*2003年5月22日 建立了一个新的标签*/

insert into HtmlLabelIndex (id,indexdesc) values (7173,'奖惩人员统计')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7173,'奖惩人员统计',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7173,'',8)
GO

/*2003年5月23日 建立了一个新的标签*/

insert into HtmlLabelIndex (id,indexdesc) values (7174,'奖惩趋势图')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7174,'奖惩趋势图',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7174,'',8)
GO

CREATE TABLE [WorkPlan] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[type_n] [char] (1)  NULL ,
	[name] [varchar] (100)  NULL ,
	[resourceid] [varchar] (200)  NULL ,
	[begindate] [char] (10)  NULL ,
	[begintime] [char] (8)  NULL ,
	[enddate] [char] (10)  NULL ,
	[endtime] [char] (8)  NULL ,	
	[color] [char] (6)  NULL ,
	[description] [varchar] (255)  NULL ,
	[requestid] [varchar] (100)  NULL ,
	[projectid] [varchar] (100)  NULL ,
	[taskid] [int]  NULL ,
	[crmid] [varchar] (100)  NULL ,
	[docid] [varchar] (100)  NULL ,
	[meetingid] [varchar] (100)  NULL ,
	[status] [char] (1)  NULL ,
	[isremind] [int] NULL ,
	[waketime] [int]  NULL ,	
	[createrid] [int]  NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL 	,
	[deleted] [char] (1)  NULL 
) 
GO

CREATE TABLE [WorkPlanShareDetail] (
	[workid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [int] NULL ,
	[sharelevel] [int] NULL 
)
GO

CREATE PROCEDURE WorkPlan_Insert 
	(@type_n_1  [char] (1)   ,
	@name_1  [varchar] (100)   ,
	@resourceid_1  [varchar] (200)   ,
	@begindate_1  [char] (10)   ,
	@begintime_1  [char] (8)   ,
	@enddate_1  [char] (10)   ,
	@endtime_1  [char] (8)   ,	
	@color_1 [char] (6)  ,
	@description_1  [varchar] (255)   ,
	@requestid_1  [varchar] (100)   ,
	@projectid_1  [varchar] (100)   ,
	@crmid_1  [varchar] (100)   ,
	@docid_1  [varchar] (100)   ,
	@meetingid_1  [varchar] (100)   ,
	@status_1  [char] (1)   ,
	@isremind_1 [int]  ,
	@waketime_1 [int]   ,	
	@createrid_1 [int]   ,
	@createdate_1 [char] (10)   ,
	@createtime_1 [char] (8) ,
	@deleted_1 [char] (1)   ,
	@flag integer output,
	@msg varchar(80) output)

AS INSERT INTO [WorkPlan] 
	(type_n ,
	name  ,
	resourceid ,
	begindate ,
	begintime ,
	enddate ,
	endtime  ,
	color ,
	description ,
	requestid  ,
	projectid ,
	crmid  ,
	docid  ,
	meetingid ,
	status  ,
	isremind  ,
	waketime  ,	
	createrid  ,
	createdate  ,
	createtime ,
	deleted) 
 
VALUES 
	(@type_n_1 ,
	@name_1  ,
	@resourceid_1 ,
	@begindate_1 ,
	@begintime_1 ,
	@enddate_1 ,
	@endtime_1  ,
	@color_1 ,
	@description_1 ,
	@requestid_1  ,
	@projectid_1 ,
	@crmid_1  ,
	@docid_1  ,
	@meetingid_1 ,
	@status_1  ,
	@isremind_1  ,
	@waketime_1  ,	
	@createrid_1  ,
	@createdate_1  ,
	@createtime_1 ,
	@deleted_1 )
select top 1 * from WorkPlan order by id desc
GO

CREATE PROCEDURE WorkPlan_Update
	(
	@id_1 	[int] ,	
	@type_n_1  [char] (1)   ,
	@name_1  [varchar] (100)   ,
	@resourceid_1  [varchar] (200)   ,
	@begindate_1  [char] (10)   ,
	@begintime_1  [char] (8)   ,
	@enddate_1  [char] (10)   ,
	@endtime_1  [char] (8)   ,	
	@color_1 [char] (6)  ,
	@description_1  [varchar] (255)   ,
	@requestid_1  [varchar] (100)   ,
	@projectid_1  [varchar] (100)   ,
	@crmid_1  [varchar] (100)   ,
	@docid_1  [varchar] (100)   ,
	@meetingid_1  [varchar] (100)   ,
	@isremind_1 [int]  ,
	@waketime_1 [int]   ,	
	@flag integer output,
	@msg varchar(80) output)

AS UPDATE WorkPlan SET 
	 type_n = @type_n_1 , 
	 name = @name_1, 
	 resourceid = @resourceid_1,
	 begindate = @begindate_1, 
	 begintime = @begintime_1,
	 enddate = @enddate_1 , 
	 endtime = @endtime_1, 
	 color = @color_1 ,
	 description = @description_1 ,
	 requestid = @requestid_1 , 
	 projectid = @projectid_1 , 
	 crmid = @crmid_1 , 
	 docid = @docid_1 , 
	 meetingid = @meetingid_1 ,
	 isremind = @isremind_1 , 
	 waketime = @waketime_1 	 
	 where id = @id_1 
GO


CREATE PROCEDURE WorkPlanShare_Insert 
	(
	@workid_1 [int]  ,
	@userid_1 [int]   ,	
	@usertype_1 [int]   ,
	@sharelevel_1 [int]   ,
	@flag integer output,
	@msg varchar(80) output)

AS INSERT INTO [WorkPlanShareDetail] 
	(workid , userid , usertype , sharelevel)
	VALUES
	(@workid_1 , @userid_1 , @usertype_1 , @sharelevel_1)
GO

CREATE PROCEDURE WorkPlanShare_DelById
	(
	@workid_1 [int]  ,
	@flag integer output,
	@msg varchar(80) output)

AS
delete WorkPlanShareDetail where workid = @workid_1
GO