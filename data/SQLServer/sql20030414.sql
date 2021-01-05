/*改动说明：@contactinfo text,*/
  alter PROCEDURE CRM_ContactLog_Update (@id 	[int], @contacterid 	[int], @resourceid 	[int], @agentid 	[int],  @contactway 	[int], @ispassive 	[tinyint], @subject 	[varchar](100), @contacttype 	[int], @contactdate 	[varchar](10), @contacttime 	[varchar](8), @enddate 	[varchar](10), @endtime 	[varchar](8), @contactinfo text, @documentid 	[int], @isfinished [tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [CRM_ContactLog]  SET  	 [contacterid]	 = @contacterid, [resourceid]	 = @resourceid,  [agentid]	 = @agentid, [contactway]	 = @contactway, [ispassive]	 = @ispassive, [subject]	 = @subject, [contacttype]	 = @contacttype, [contactdate]	 = @contactdate, [contacttime]	 = @contacttime, [enddate]	 = @enddate, [endtime]	 = @endtime, [contactinfo]	 = @contactinfo, [documentid]	 = @documentid, [isfinished]	 = @isfinished  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

alter table CRM_Contract alter column docId  varchar(100)
GO

ALTER PROCEDURE CRM_Contract_Insert 
	(@name_1  [varchar] (100)   ,
	 @typeId_1  [int]  ,	
	 @docId_1  [varchar] (100)   ,
	 @price_1  [decimal](10, 2)  ,
	 @crmId_1  [int]  ,
	 @contacterId_1  [int]  ,
	 @startDate_1  [char] (10)   ,
	 @endDate_1  [char] (10)   ,
	 @manager_1  [int]  ,
	 @status_1  [int]  ,
	 @isRemind_1  [int]  ,
	 @remindDay_1  [int]  ,
	 @creater_1  [int]  ,
	 @createDate_1  [char] (10)   ,
	 @createTime_1  [char] (10)  ,
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CRM_Contract] 
	 (name , 
	 typeId , 
	 docId , price , crmId , contacterId , startDate , endDate , manager , status , isRemind , remindDay , creater , createDate , createTime) 
 
VALUES 
	( @name_1,
	 @typeId_1,
	 @docId_1, @price_1 , @crmId_1 , @contacterId_1 , @startDate_1 , @endDate_1 , @manager_1 , @status_1 , @isRemind_1 , @remindDay_1 , @creater_1 , @createDate_1 , @createTime_1)
select top 1 * from CRM_Contract order by id desc
GO


ALTER PROCEDURE CRM_Contract_Update 
	(@id_1 	[int] ,
	 @name_1  [varchar] (100)   ,
	 @typeId_1  [int]  ,	
	 @docId_1  [varchar] (100)   ,
	 @price_1  [decimal](10, 2)  ,
	 @crmId_1  [int]  ,
	 @contacterId_1  [int]  ,
	 @startDate_1  [char] (10)   ,
	 @endDate_1  [char] (10)   ,
	 @manager_1  [int]  ,
	 @status_1  [int]  ,
	 @isRemind_1  [int]  ,
	 @remindDay_1  [int]  ,
	 @flag integer output,
	 @msg varchar(80) output)

AS
UPDATE CRM_Contract SET name = @name_1, typeId = @typeId_1 , docId = @docId_1 , price = @price_1 , crmId = @crmId_1 , contacterId = @contacterId_1 , startDate = @startDate_1 , endDate = @endDate_1 , manager = @manager_1 , status = @status_1 , isRemind = @isRemind_1 , remindDay = @remindDay_1  where id = @id_1
GO


ALTER PROCEDURE CptCapital_Duplicate 
	(@capitalid 	int,
	@flag integer output,
	 @msg varchar(80) output)

AS 
declare @maxid int
INSERT INTO [CptCapital] 
(mark,
name,
barcode,
startdate,
enddate,
seclevel,
departmentid,
costcenterid,
resourceid,
crmid,
sptcount,
currencyid ,
capitalcost,
startprice,
depreendprice,
capitalspec,
capitallevel,
manufacturer,
manudate,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
currentnum,
replacecapitalid,
version,
itemid,
remark,
capitalimageid,
depremethod1,
depremethod2,
deprestartdate,
depreenddate,
customerid,
attribute,
stateid,
location,
usedhours,
datefield1,
datefield2,
datefield3,
datefield4,
datefield5,
numberfield1,
numberfield2,
numberfield3,
numberfield4,
numberfield5,
textfield1,
textfield2,
textfield3,
textfield4,
textfield5,
tinyintfield1,
tinyintfield2,
tinyintfield3,
tinyintfield4,
tinyintfield5,
createrid,
createdate,
createtime,
lastmoderid,
lastmoddate,
lastmodtime,
isdata,
datatype,
relatewfid)
select 
mark,
name,
barcode,
startdate,
enddate	,
seclevel,
departmentid,
costcenterid,
resourceid,
crmid,
sptcount,
currencyid ,
capitalcost,
startprice,
depreendprice,
capitalspec,
capitallevel,
manufacturer,
manudate,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
currentnum,
replacecapitalid,
version,
itemid,
remark,
capitalimageid,
depremethod1,
depremethod2,
deprestartdate,
depreenddate,
customerid,
attribute,
stateid,
location,
usedhours,
datefield1,
datefield2,
datefield3,
datefield4,
datefield5,
numberfield1,
numberfield2,
numberfield3,
numberfield4,
numberfield5,
textfield1,
textfield2,
textfield3,
textfield4,
textfield5,
tinyintfield1,
tinyintfield2,
tinyintfield3,
tinyintfield4,
tinyintfield5,
createrid,
createdate,
createtime,
lastmoderid,
lastmoddate,
lastmodtime,
isdata,
datatype,
relatewfid
 from CptCapital
where id = @capitalid

select @maxid = max(id)  from CptCapital
update CptCapital set capitalnum = 0 where id = @maxid
select @maxid
GO




CREATE TABLE Exchange_Info (
	id int IDENTITY (1, 1) NOT NULL ,
	sortid int NULL ,
	name varchar (200)  NULL ,
	remark text  NULL ,
	creater int NULL ,
	createDate char (10)  NULL ,
	createTime char (10)  NULL,
	type_n  char(2) null,
	docids varchar(600) null
)
GO

/***
*销售机会相关交流 type_n=CS 
*客户相关交流    type_n=CC
*客户联系相关交流 type_n=CT
*合同的相关交流	type_n=CH
*项目的相关交流   type_n=PP
*任务的相关交流	type_n=PT
*
*
*/

CREATE PROCEDURE ExchangeInfo_Insert 
	(@sortid_1 int  ,
	 @name_1  varchar (200)   ,
	 @remark_1 text  ,
	 @creater_1  int  ,
	 @createDate_1  char (10)   ,
	 @createTime_1  char (10)  ,
	 @type_n_1 char(2),
	 @docids_1 varchar(600),
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO Exchange_Info 
	 (sortid ,
	 name , 
	 remark , 
	 creater , createDate , createTime,type_n,docids) 
 
VALUES 
	(@sortid_1 ,
	 @name_1,
	 @remark_1,
	 @creater_1 , @createDate_1 , @createTime_1,@type_n_1,@docids_1)
GO

CREATE PROCEDURE ExchangeInfo_SelectBID
	(@sortid_1 int ,
	 @type_n_1 char(2),
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS
SELECT * FROM Exchange_Info where sortid = @sortid_1 AND type_n=@type_n_1 order by id desc
GO


/*成功、失败关键因数*/
CREATE TABLE CRM_Successfactor (
	id int IDENTITY (1, 1) NOT NULL ,
	fullname varchar (50)  NULL ,
	description varchar (150)  NULL 
)
GO

 CREATE PROCEDURE CRM_Successfactor_SelectAll 
 (@flag	int	output,
 @msg	varchar(80)	output)
 AS
 SELECT * FROM CRM_Successfactor
GO

 CREATE PROCEDURE CRM_Successfactor_Insert 
 (@fullname 	varchar(50), 
 @description 	varchar(150), 
 @flag	int	output, 
 @msg	varchar(80)	output)  
 AS 
 INSERT INTO 
 CRM_Successfactor 
 ( fullname, description) 
 VALUES ( @fullname, @description) 
GO


 CREATE PROCEDURE CRM_Successfactor_SelectByID 
 (@id 	int, 
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS 
 SELECT * FROM CRM_Successfactor
 WHERE ( id	 = @id)  
GO


 CREATE PROCEDURE CRM_Successfactor_Update 
 (@id	 	int, 
 @fullname 	varchar(50),
 @description 	varchar(150),  
@flag	int	output, @msg	varchar(80)	output) 
AS 
UPDATE CRM_Successfactor  
SET  fullname	 = @fullname,
description	 = @description
WHERE ( id	 = @id)   
GO




 CREATE PROCEDURE CRM_Successfactor_Delete 
 (@id 	int,
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS DELETE CRM_Successfactor  WHERE ( id	 = @id) 
 GO

/*====*/

CREATE TABLE CRM_Failfactor (
	id int IDENTITY (1, 1) NOT NULL ,
	fullname varchar (50)  NULL ,
	description varchar (150)  NULL 
)
GO


 CREATE PROCEDURE CRM_Failfactor_SelectAll 
 (@flag	int	output,
 @msg	varchar(80)	output)
 AS
 SELECT * FROM CRM_Failfactor
GO


 CREATE PROCEDURE CRM_Failfactor_Insert 
 (@fullname 	varchar(50), 
 @description 	varchar(150), 
 @flag	int	output, 
 @msg	varchar(80)	output)  
 AS 
 INSERT INTO 
 CRM_Failfactor 
 ( fullname, description) 
 VALUES ( @fullname, @description) 
GO


 CREATE PROCEDURE CRM_Failfactor_SelectByID 
 (@id 	int, 
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS 
 SELECT * FROM CRM_Failfactor
 WHERE ( id	 = @id)  
GO

 CREATE PROCEDURE CRM_Failfactor_Update 
 (@id	 	int, 
 @fullname 	varchar(50),
 @description 	varchar(150),  
@flag	int	output, @msg	varchar(80)	output) 
AS 
UPDATE CRM_Failfactor  
SET  fullname	 = @fullname,
description	 = @description
WHERE ( id	 = @id)   
GO




 CREATE PROCEDURE CRM_Failfactor_Delete 
 (@id 	int,
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS DELETE CRM_Failfactor  WHERE ( id	 = @id) 
 GO
 /*成功、失败关键因数==end*/


 insert into HtmlLabelInfo (indexid,labelname,languageid) values (2228,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2228,'项目状态：正常',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2228,'项目状态：正常')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2229,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2229,'项目状态：延期',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2229,'项目状态：延期')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2230,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2230,'项目状态：完成',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2230,'项目状态：完成')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2231,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2231,'项目状态：冻结',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2231,'项目状态：冻结')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2232,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2232,'里程碑任务',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2232,'里程碑任务')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2233,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2233,'前置任务',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2233,'前置任务')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2234,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2234,'进度审批状态',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2234,'进度审批状态')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2235,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2235,'未批准',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2235,'未批准')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2236,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2236,'已经审批',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2236,'已经审批')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2237,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2237,'进度图表',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2237,'进度图表')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2238,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2238,'工作流/文档',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2238,'工作流/文档')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2239,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2239,'监控类型',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2239,'监控类型')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2240,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2240,'任务说明',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2240,'任务说明')
go


insert into HtmlLabelInfo (indexid,labelname,languageid) values (2241,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2241,'全部选中',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2241,'全部选中')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2242,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2242,'待审批',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2242,'待审批')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2243,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2243,'立项批准',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2243,'立项批准')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2244,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2244,'延期',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2244,'延期')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2245,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2245,'无效',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2245,'无效') 
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2246,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2246,'有效',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2246,'有效')
go


insert into HtmlLabelInfo (indexid,labelname,languageid) values (2247,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2247,'销售预期',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2247,'销售预期')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2248,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2248,'预期收益',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2248,'预期收益')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2249,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2249,'可能性',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2249,'可能性')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2250,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2250,'销售状态',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2250,'销售状态')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2251,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2251,'查看：相关交流',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2251,'查看：相关交流')
go

alter table HrmStatusHistory add 
  isdispose int default(0)
go

create table HrmTrainResource 
(id int identity(1,1) not null,
 name varchar(60) null,
 type_n int null,
 /*1、外部；0、内部 */
 fare varchar(200) null,
 time varchar(200) null,
 memo text null)
go

create table HrmTrainDay
(id int identity(1,1) not null,
 trainid int null,
 traindate char(10) null,
 daytraincontent text null,
 daytrainaim text null,
 daytraineffect text null,
 daytrainplain text null)
go

create table HrmTrainActor
(id int identity(1,1) not null,
 resourceid int null,
 traindayid int null,
 isattend int default(0)
 /*1、参加；0、未参加*/)
go

create table HrmTrainTest
(id int identity(1,1) not null,
 trainid int null,
 resourceid int null,
 testdate char(10) null,
 result int null,
 /*0、不及格；1、及格；2、良好；3、优秀*/
 explain text null,
 testerid int null)
go

create table HrmTrainAssess
(id int identity(1,1) not null,
 trainid int null,
 resourceid int null,
 assessdate char(10) null,
 implement int null,
 /*0、极差；1、差；2、一般；3、好；4、很好*/
 explain text null)
go

create table HrmTrainPlanRange
(id int identity(1,1) not null,
 planid int null,
 type_n int null,
 /*0、所有人；1、部门；2、职务；3、岗位；4、人力资源*/
 resourceid int)
go

create table HrmUseDemand
(id int identity(1,1) not null,
 demandjobtitle int null,
 demandnum int null,
 demandkind int null,
 leastedulevel int null,
 demandregdate char(10) null,
 otherrequest text null,
 refermandid int null,
 referdate char(10) null,
 status int default(0),
 /*0：尚未满足；1：正在招聘；2：已经满足；3：无用;4:失效*/
 createkind int default(0)
 /*0：工作流；1：页面维护*/)
go

create table HrmCareerPlan
(id int identity(1,1) not null,
topic varchar(200) null,
principalid int null,
informmanid int null,
emailmould int null,
startdate char(10) null,
budget float null,
budgettype int null,
memo text null,
enddate char(10) null,
fare float null,
faretype int null,
advice text null)
go

create table HrmCareerPlanStep
(id int identity(1,1) not null,
 planid int null,
 stepname varchar(200) null,
 stepstartdate char(10) null,
 stependdate char(10) null)
go

alter procedure HrmResource_DepUpdate
(@id_1 int,
 @departmentid_2 int,
 @joblevel_3 int,
 @costcenterid_4 int,
 @flag int output,@msg varchar(60) output)
as update HrmResource set
  departmentid = @departmentid_2,
  joblevel = @joblevel_3,
  costcenterid = @costcenterid_4
where
  id = @id_1
go

ALTER PROCEDURE HrmTrainType_Insert
(@name_2 varchar(60),
 @description_3 varchar(60),
 @typecontent_4 text ,
 @typeaim_5 text ,
 @typedocurl_6 varchar(200) ,
 @typetesturl_7 varchar(200) ,
 @typeoperator_8 varchar(200) ,
 @flag int output, @msg varchar(60) output)
AS INSERT into HrmTrainType
( name,
  description ,
  typecontent ,
  typeaim ,
  typedocurl ,
  typetesturl,
  typeoperator)
VALUES
( @name_2,
  @description_3,
  @typecontent_4,
  @typeaim_5,
  @typedocurl_6,
  @typetesturl_7,
  @typeoperator_8)
GO

alter procedure HrmTrainLayout_Insert
(@layoutname_1 varchar(60),
 @typeid_2 int,
 @layoutstartdate_3 char(10),
 @layoutenddate_4 char(10),
 @layoutcontent_5 text,
 @layoutaim_6 text,
 @layouttestdate_7 char(10),
 @layoutassessor_8 varchar(200),
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainLayout
 (layoutname ,
 typeid ,
 layoutstartdate ,
 layoutenddate,
 layoutcontent,
 layoutaim,
 layouttestdate,
 layoutassessor
)
values
(@layoutname_1 ,
 @typeid_2 ,
 @layoutstartdate_3 ,
 @layoutenddate_4 ,
 @layoutcontent_5 ,
 @layoutaim_6 ,
 @layouttestdate_7 ,
 @layoutassessor_8 
 )
go

alter procedure TrainLayoutAssess_Insert
(@layoutid_1 int,
 @assessorid_2 int,
 @assessdate_3 char(10),
 @implement_4 char(1),
 @explain_5 text,
 @advice_6 text,
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainLayoutAssess
(layoutid,
 assessorid,
 assessdate,
 implement,
 explain,
 advice)
values
(@layoutid_1,
 @assessorid_2,
 @assessdate_3,
 @implement_4,
 @explain_5,
 @advice_6)
go

alter procedure HrmTrainPlan_Insert
(@planname_1 varchar(60),
 @layoutid_2 int,
 @planorganizer_3 varchar(200),
 @planstartdate_4 char(10),
 @planenddate_5 char(10),
 @plancontent_6 text,
 @planaim_7 text,
 @planaddress_8 varchar(200),
 @planresource_9 varchar(200),
 @planactor_10 text,
 @planbudget_11 float,
 @planbudgettype_12 char(1),
 @openrange_13 varchar(200),
 @createrid_14 int,
 @createdate_15 char(10),
 @flag int output , @msg varchar(60) output)
as insert into HrmTrainPlan 
 (planname,
 layoutid ,
 planorganizer,
 planstartdate,
 planenddate,
 plancontent,
 planaim,
 planaddress,
 planresource,
 planactor,
 planbudget,
 planbudgettype,
 openrange,
 createrid,
 createdate)
values
(@planname_1,
 @layoutid_2,
 @planorganizer_3,
 @planstartdate_4,
 @planenddate_5,
 @plancontent_6,
 @planaim_7,
 @planaddress_8,
 @planresource_9,
 @planactor_10,
 @planbudget_11,
 @planbudgettype_12,
 @openrange_13,
 @createrid_14,
 @createdate_15)
go

create procedure HrmTrainRes_Insert
(@name_1 varchar(60) ,
 @type_2 int,
 @fare_3 varchar(200),
 @time_4 varchar(200),
 @memo_5 text,
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainResource 
(name,
 type_n,
 fare,
 time,
 memo)
values
(@name_1,
 @type_2,
 @fare_3,
 @time_4,
 @memo_5)
go

create procedure HrmTrainRes_Update
(@name_1 varchar(60) ,
 @type_2 int,
 @fare_3 varchar(200),
 @time_4 varchar(200),
 @memo_5 text,
 @id_6 int,
 @flag int output, @msg varchar(60) output)
as update HrmTrainResource set
name = @name_1,
 type_n = @type_2,
 fare = @fare_3,
 time = @time_4,
 memo = @memo_5
 where 
 id = @id_6
go

create procedure HrmTrainRes_Delete
(@id_1 int,
 @flag int output, @msg varchar(60) output)
as delete HrmTrainResource 
where 
 id = @id_1
go

create procedure HrmTrain_Insert
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
 select max(id) from HrmTrainDay
go

create procedure HrmTrain_Update
(@name_1 varchar(60),
 @planid_2 int,
 @organizer_3 varchar(200),
 @startdate_4 char(10),
 @enddate_5 char(10),
 @content_6 text,
 @aim_7 text,
 @address_8 varchar(200),
 @resource_n_9 varchar(200), 
 @testdate_10 char(10),
 @id_11 int,
 @flag int output , @msg varchar(60) output)
as update HrmTrain set
 name      = @name_1,
 planid    = @planid_2,
 organizer = @organizer_3,
 startdate = @startdate_4,
 enddate   = @enddate_5,
 content   = @content_6,
 aim       = @aim_7,
 address   = @address_8,
 resource_n= @resource_n_9, 
 testdate  = @testdate_10
where
 id = @id_11
go

create procedure HrmTrain_Delete
(@id_1 int,
 @flag int output , @msg varchar(60) output)
as delete HrmTrain 
where
 id = @id_1
go

create procedure HrmTrainDay_Insert
(@trainid_1 int,
 @day_2 char(10),
 @content_3 text,
 @aim_4 text,
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainDay
(trainid,
 traindate,
 daytraincontent,
 daytrainaim)
values
(@trainid_1,
 @day_2,
 @content_3,
 @aim_4)
select max(id) from HrmTrainDay
go

create procedure HrmTrainActor_Insert
(@traindayid_1 int,
 @resourceid_2 int,
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainActor
(traindayid,
 resourceid)
values
(@traindayid_1,
 @resourceid_2)
go

create procedure HrmTrainDay_Update
(@day_1 char(10),
 @content_2 text,
 @aim_3 text,
 @effect_4 text,
 @plain_5 text,
 @id_6 int,
 @flag int output, @msg varchar(60) output)
as update HrmTrainDay set
 traindate = @day_1,
 daytraincontent =@content_2 ,
 daytrainaim = @aim_3,
 daytraineffect = @effect_4,
 daytrainplain = @plain_5
where
 id = @id_6
go

create procedure HrmTrainActor_Update
(@traindayid_1 int,
 @resourceid_2 int,
 @flag int output, @msg varchar(60) output)
as update HrmTrainActor 
set
 isattend = 1
where
 traindayid = @traindayid_1 and resourceid = @resourceid_2
go

create procedure HrmTrainActor_UpdateReset
(@traindayid_1 int, 
 @flag int output, @msg varchar(60) output)
as update HrmTrainActor 
set
 isattend = 0
where
 traindayid = @traindayid_1
go

create procedure HrmTrainDay_Delete
(@id_1 int, 
 @flag int output, @msg varchar(60) output)
as delete HrmTrainDay 
where
 id = @id_1
delete HrmTrainActor
where
 traindayid = @id_1
go

create procedure HrmTrainTest_Insert
(@trainid_1 int,
 @resourceid_2 int,
 @testdate_3 char(10),
 @result_4 int,
 @explain_5 text,
 @testerid_6 int,
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainTest
(trainid,
 resourceid,
 testdate,
 result,
 explain,
 testerid)
values
(@trainid_1 ,
 @resourceid_2,
 @testdate_3,
 @result_4 ,
 @explain_5,
 @testerid_6)
go

create procedure HrmTrainAssess_Insert
(@trainid_1 int,
 @resourceid_2 int,
 @testdate_3 char(10),
 @result_4 int,
 @explain_5 text, 
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainAssess
(trainid,
 resourceid,
 assessdate,
 implement,
 explain)
values
(@trainid_1 ,
 @resourceid_2,
 @testdate_3,
 @result_4 ,
 @explain_5)
go

create procedure HrmTrainAssess_Update
(@trainid_1 int,
 @resourceid_2 int,
 @testdate_3 char(10),
 @result_4 int,
 @explain_5 text,
 @id_6 int,
 @flag int output, @msg varchar(60) output)
as update HrmTrainAssess set
 trainid    = @trainid_1,
 resourceid = @resourceid_2,
 assessdate = @testdate_3,
 implement  = @result_4,
 explain    = @explain_5
where
 id = @id_6
go

create procedure HrmTrain_Finish
(@id_1 int,
 @summarizer_2 int,
 @summarizedate_3 char(10),
 @fare_4 float,
 @faretype_5 int,
 @advice_6 text,
 @flag int output, @msg varchar(60) output)
as update HrmTrain set
 summarizer = @summarizer_2,
 summarizedate = @summarizedate_3,
 fare = @fare_4,
 faretype = @faretype_5,
 advice = @advice_6
where
 id = @id_1
go

create procedure HrmTrainPlanRange_Insert
(@planid_1 int,
 @type_2 int,
 @resourceid_3 int,
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainPlanRange
(planid,
 type_n,
 resourceid)
values
(@planid_1,
 @type_2,
 @resourceid_3)
update HrmTrainPlan set openrange = 1 
where 
 id = @planid_1
go

create procedure HrmTrainPlanRange_Delete
(@id_1 int,
 @flag int output, @msg varchar(60) output)
as delete from HrmTrainPlanRange
where 
 id = @id_1
go

insert into SystemRights (id, rightdesc,righttype) 
  values (370,'培训规划维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(370,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3000,'培训规划添加','HrmTrainLayoutAdd:Add',370)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3001,'培训规划编辑','HrmTrainLayoutEdit:Edit',370)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3002,'培训规划删除','HrmTrainLayoutDelete:Delete',370)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3003,'培训规划日志','HrmTrainLayout:Log',370)
go

insert into SystemRights (id, rightdesc,righttype) 
  values (371,'培训安排维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(371,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3004,'培训安排添加','HrmTrainPlanAdd:Add',371)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3005,'培训安排编辑','HrmTrainPlanEdit:Edit',371)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3006,'培训安排删除','HrmTrainPlanDelete:Delete',371)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3007,'培训安排日志','HrmTrainPlan:Log',371)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3018,'培训安排查看','HrmTrainPlan:View',371)
go

insert into SystemRights (id, rightdesc,righttype) 
  values (372,'培训资源维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(372,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3008,'培训资源添加','HrmTrainResourceAdd:Add',372)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3009,'培训资源编辑','HrmTrainResourceEdit:Edit',372)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3010,'培训资源删除','HrmTrainResourceDelete:Delete',372)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3011,'培训资源日志','HrmTrainResource:Log',372)
go

insert into SystemRights (id, rightdesc,righttype) 
  values (373,'培训活动维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(373,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3013,'培训活动添加','HrmTrainAdd:Add',373)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3014,'培训活动编辑','HrmTrainEdit:Edit',373)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3015,'培训活动删除','HrmTrainDelete:Delete',373)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3016,'培训活动日志','HrmTrain:Log',373)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3017,'培训活动查看','HrmTrain:View',373)
go

insert into HtmlLabelIndex (id,indexdesc) values (6101,'规划')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6101,'规划',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6101,'Layout',8)
go

insert into HtmlLabelIndex (id,indexdesc) values (6102,'考评')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6102,'考评',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6102,'Assess',8)
go

insert into HtmlLabelIndex (id,indexdesc) values (6103,'安排')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6103,'安排',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6103,'Plan',8)
go

insert into HtmlLabelIndex (id,indexdesc) values (6104,'公开范围')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6104,'公开范围',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6104,'OpenRange',8)
go

insert into HtmlLabelIndex (id,indexdesc) values (6105,'资源')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6105,'资源',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6105,'Resource',8)
go

insert into HtmlLabelIndex (id,indexdesc) values (6106,'考核')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6106,'考核',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6106,'Test',8)
go

create procedure HrmUseDemand_Update
(@jobtitle_1 int,
 @status_2 int,
 @demandnum_3 int,
 @demandkind_4 int,
 @leaseedulevel_5 int,
 @date_6 char(10),
 @otherrequest_7 text,
 @id_8 int,
 @flag int output, @msg varchar(60) output)
as update HrmUseDemand set
 demandjobtitle = @jobtitle_1,
 status = @status_2,
 demandnum = @demandnum_3,
 demandkind = @demandkind_4,
 leastedulevel = @leaseedulevel_5,
 demandregdate = @date_6,
 otherrequest = @otherrequest_7
where
 id = @id_8
go


CREATE PROCEDURE HrmUseDemand_Insert
	(@demandjobtitle_1 	[int],
	 @demandnum_2 	[int],
	 @demandkind_3 	[int],
	 @leastedulevel_4 	[int],
	 @demandregdate_5 	[char](10),
	 @otherrequest_6 	[text],
	 @refermandid_7 	[int],
	 @referdate_8 	[char](10),
	 @createkind_9 	[int],
	 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmUseDemand
	 ([demandjobtitle],
	 [demandnum],
	 [demandkind],
	 [leastedulevel],
	 [demandregdate],
	 [otherrequest],
	 [refermandid],
	 [referdate],
	 [createkind]) 
VALUES 
	(@demandjobtitle_1,
	 @demandnum_2,
	 @demandkind_3,
	 @leastedulevel_4,
	 @demandregdate_5,
	 @otherrequest_6,
	 @refermandid_7,
	 @referdate_8,
	 @createkind_9)
go

create procedure HrmUseDemand_Delete
(@id_1 int,
 @flag int output, @msg varchar(60) output)
as delete HrmUseDemand 
where
 id = @id_1
go

create procedure HrmUseDemand_Close
(@id_1 int,
 @flag int output, @msg varchar(60) output)
as update HrmUseDemand set
  status = 4
where
 id = @id_1
go


CREATE PROCEDURE [HrmCareerPlan_Update]
	(@id_1 	[int],
	 @topic_2 	[varchar](200),
	 @principalid_3 	[int],
	 @informmanid_4 	[int],
	 @emailmould_5 	[int],
	 @startdate_6 	[char](10),
	 @budget_7 	[float],
	 @budgettype_8 	[int],
	 @memo_9 	[text],
	 @flag int output, @msg varchar(60) output)

AS UPDATE [HrmCareerPlan] 

SET      [topic]	 = @topic_2,
	 [principalid]	 = @principalid_3,
	 [informmanid]	 = @informmanid_4,
	 [emailmould]	 = @emailmould_5,
	 [startdate]	 = @startdate_6,
	 [budget]	 = @budget_7,
	 [budgettype]	 = @budgettype_8,
	 [memo]	 = @memo_9 

WHERE 
	( [id]	 = @id_1)
go


CREATE PROCEDURE [HrmCareerPlan_Insert]
	(@topic_1 	[varchar](200),
	 @principalid_2 	[int],
	 @informmanid_3 	[int],
	 @emailmould_4 	[int],
	 @startdate_5 	[char](10),
	 @budget_6 	[float],
	 @budgettype_7 	[int],
	 @memo_8 	[text],
	 @flag int output, @msg varchar(60) output)
AS INSERT INTO [HrmCareerPlan] 
	 ( [topic],
	 [principalid],
	 [informmanid],
	 [emailmould],
	 [startdate],
	 [budget],
	 [budgettype],
	 [memo]) 
 
VALUES 
	(@topic_1,
	 @principalid_2,
	 @informmanid_3,
	 @emailmould_4,
	 @startdate_5,
	 @budget_6,
	 @budgettype_7,
	 @memo_8)
select max(id) from HrmCareerPlan	
go




CREATE PROCEDURE [HrmCareerPlan_Delete]
	(@id_1 	[int],
	@flag int output, @msg varchar(60) output)

AS DELETE [HrmCareerPlan] 

WHERE 
	( [id]	 = @id_1)
delete HrmCareerPlanStep 
where 
  planid = @id_1
go


CREATE PROCEDURE [HrmCareerPlanStep_Insert]
	(@planid_1 	[int],
	 @stepname_2 	[varchar](200),
	 @stepstartdate_3 	[char](10),
	 @stependdate_4 	[char](10),
	 @flag int output, @msg varchar(60) output)

AS INSERT INTO [HrmCareerPlanStep] 
	 ([planid],
	 [stepname],
	 [stepstartdate],
	 [stependdate]) 
 
VALUES 
	( @planid_1,
	 @stepname_2,
	 @stepstartdate_3,
	 @stependdate_4)
go


CREATE PROCEDURE [HrmCareerPlan_Finish]
	(@id_1 	[int],
	 @enddate_2 	[char](10),
	 @fare_3 	[float],
	 @faretype_4 	[int],
	 @advice_5 	[text],
	 @flag int output, @msg varchar(60) output)

AS UPDATE [HrmCareerPlan] 

SET      [enddate]	 = @enddate_2,
	 [fare]	         = @fare_3,
	 [faretype]	 = @faretype_4,
	 [advice]	 = @advice_5 

WHERE 
	( [id]	 = @id_1)
go

alter table FnaBudgetfeeType add
  feeperiod  int ,      /* 预算的周期 1: 每月 2: 每季 3: 每半年 4: 每年 */
  feetype int,			/* 1: 支出 2: 收入 3:成本*/
  agreegap int          /* 允许的偏差 */
GO


create table FnaBudgetInfo (
id  int  IDENTITY(1,1) primary key CLUSTERED,			/*id*/
budgetyears          char(4),					        /*预算年度*/
budgetdepartmentid     int ,	                        /*所属部门id*/
budgetstatus           int ,
/*预算处理状态
0:打开
1:批准
*/
createrid            int ,					/*生成者id*/
createdate           char(10) ,					/*生成日期*/
approverid           int ,					/*批准者id*/
approverdate         char(10)					/*批准日期*/
)
GO

create table FnaBudgetInfoDetail (
id  int  IDENTITY(1,1) primary key CLUSTERED,			/*id*/
budgetinfoid           int,                         /*预算id*/
budgetperiods          int,					        /*预算期间数*/
budgetstartdate   char(10) ,                        /*预算开始日期*/
budgetenddate     char(10) ,                        /*预算结束日期*/
budgettypeid          int  ,				        /*预算类型id*/
budgetresourceid       int  ,				        /*对应人力资源id*/
budgetcrmid	           int  ,			            /*对应CRM id*/
budgetprojectid	       int  ,				        /*对应项目id*/
budgetaccount     decimal(18,2) ,			        /*金额*/
budgetremark           varchar(250) 		        /*备注*/
)
GO

create NONCLUSTERED INDEX FnaBID_budgetinfoid_in on FnaBudgetInfoDetail(budgetinfoid)
GO


create table FnaBudgetCheckDetail (
id  int  IDENTITY(1,1) primary key CLUSTERED,			/*id*/
budgetinfoid           int,                         /*预算id*/
budgetperiods          int,					        /*预算期间数*/
budgetstartdate   char(10) ,                        /*预算开始日期*/
budgetenddate     char(10) ,                        /*预算结束日期*/
budgettypeid          int  ,				        /*预算类型id*/
budgetaccount     decimal(18,2) ,			        /*金额*/
budgetremark           varchar(250) 		        /*备注*/
)
GO

create NONCLUSTERED INDEX FnaBID_budgetcheckid_in on FnaBudgetCheckDetail(budgetinfoid)
GO

alter PROCEDURE DocUserCategory_InsertByUser 
	@userid	int, 
	@usertype char(1),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	declare	@mainid	int,
			@subid	int,
			@secid	int,
			@seclevel	tinyint,
			@crmtype	int,
			@all_cursor cursor

	delete from DocUserCategory where userid=@userid and usertype=@usertype
			
	if @usertype='0'
		begin
			SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
			select distinct t1.id from docseccategory t1,hrmresource t2,hrmrolemembers t5
			where t1.cusertype='0' and t2.id=@userid 
			and(( t2.seclevel>=t1.cuserseclevel) 
			or( t2.seclevel >= t1.cdepseclevel1 and t2.departmentid=t1.cdepartmentid1) 
			or( t2.seclevel >= t1.cdepseclevel2 and t2.departmentid=t1.cdepartmentid2) 
			or( t5.roleid=t1.croleid1 and t5.rolelevel=t1.crolelevel1 and t2.id=t5.resourceid )
			or( t5.roleid=t1.croleid2 and t5.rolelevel=t1.crolelevel2 and t2.id=t5.resourceid )
			or( t5.roleid=t1.croleid3 and t5.rolelevel=t1.crolelevel3 and t2.id=t5.resourceid ))
			OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @secid  
			WHILE @@FETCH_STATUS = 0 
				begin
					select @subid=subcategoryid from docseccategory where id=@secid
					select @mainid=maincategoryid from docsubcategory where id=@subid
					insert into  docusercategory (secid,mainid,subid,userid,usertype)
					values (@secid,@mainid,@subid,@userid,@usertype)
					FETCH NEXT FROM @all_cursor INTO @secid 
				end 
			CLOSE @all_cursor DEALLOCATE @all_cursor
		end
	else
		begin
			select @crmtype=type,@seclevel=seclevel from crm_customerinfo where id=@userid
			SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
			select id from DocSecCategory 
			where cusertype=@crmtype and cuserseclevel<=@seclevel 
			OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @secid  
			WHILE @@FETCH_STATUS = 0 
				begin
					select @subid=subcategoryid from docseccategory where id=@secid
					select @mainid=maincategoryid from docsubcategory where id=@subid
					insert into  docusercategory (secid,mainid,subid,userid,usertype)
					values (@secid,@mainid,@subid,@userid,@usertype)
					FETCH NEXT FROM @all_cursor INTO @secid 
				end 
			CLOSE @all_cursor DEALLOCATE @all_cursor
		end
GO

alter PROCEDURE HrmDepartment_Select 
@flag integer output , @msg varchar(80) output AS select * from HrmDepartment set @flag = 0 set @msg = '操作成功完成' 

GO 


ALTER PROCEDURE FnaBudgetfeeType_Insert 
	@name_1	varchar(50),
    @feeperiod_1	int,
    @feetype_1	int,
    @agreegap_1	int,
	@description_1	varchar(255),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	insert into fnaBudgetfeetype (name,feeperiod,feetype,agreegap,description) 
    values (@name_1,@feeperiod_1,@feetype_1,@agreegap_1,@description_1)
GO

ALTER PROCEDURE FnaBudgetfeeType_Update 
	@id_1		int,
	@name_1	varchar(50),
    @feeperiod_1	int,
    @feetype_1	int,
    @agreegap_1	int,
	@description_1	varchar(250),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	update fnaBudgetfeetype set name=@name_1,feeperiod=@feeperiod_1,feetype=@feetype_1
    ,agreegap=@agreegap_1,description=@description_1 where id=@id_1
GO

CREATE PROCEDURE FnaBudgetInfo_Insert
	(@budgetyears_1 	char(4),
	 @budgetdepartmentid_2 	int,
	 @budgetstatus_3 	int,
	 @createrid_4 	int,
	 @createdate_5 	char(10),
	@flag	int	output, 
	@msg	varchar(80) output)

AS INSERT INTO FnaBudgetInfo 
	 ( budgetyears,
	 budgetdepartmentid,
	 budgetstatus,
	 createrid,
	 createdate) 
 
VALUES 
	( @budgetyears_1,
	 @budgetdepartmentid_2,
	 @budgetstatus_3,
	 @createrid_4,
	 @createdate_5)
select max(id) from FnaBudgetInfo
GO

CREATE PROCEDURE FnaBudgetInfo_Update
	(@id_1 	int,
	 @approverid_2 	int,
	 @approverdate_3 	char(10),
	@flag	int	output, 
	@msg	varchar(80) output)

AS UPDATE FnaBudgetInfo 

SET  budgetstatus = '1' ,
     approverid	 = @approverid_2,
	 approverdate	 = @approverdate_3 

WHERE 
	( id	 = @id_1)
GO


CREATE PROCEDURE FnaBudgetInfoDetail_Insert
	(@budgetinfoid_1 	int,
	 @budgetperiods_2 	int,
	 @budgetstartdate_3 	char(10),
	 @budgetenddate_4 	char(10),
	 @budgettypeid_5 	int,
	 @budgetresourceid_6 	int,
	 @budgetcrmid_7 	int,
	 @budgetprojectid_8 	int,
	 @budgetaccount_9 	decimal(18,2),
	 @budgetremark_10 	varchar(250),
	@flag	int	output, 
	@msg	varchar(80) output)

AS INSERT INTO FnaBudgetInfoDetail 
	 ( budgetinfoid,
	 budgetperiods,
	 budgetstartdate,
	 budgetenddate,
	 budgettypeid,
	 budgetresourceid,
	 budgetcrmid,
	 budgetprojectid,
	 budgetaccount,
	 budgetremark) 
 
VALUES 
	( @budgetinfoid_1,
	 @budgetperiods_2,
	 @budgetstartdate_3,
	 @budgetenddate_4,
	 @budgettypeid_5,
	 @budgetresourceid_6,
	 @budgetcrmid_7,
	 @budgetprojectid_8,
	 @budgetaccount_9,
	 @budgetremark_10)
GO

CREATE PROCEDURE FnaBudgetInfoDetail_Delete
	(@budgetinfoid_1 	int,
    @budgettypeid_2 	int,
	@flag	int	output, 
	@msg	varchar(80) output)

AS DELETE FnaBudgetInfoDetail 

WHERE 
	( budgetinfoid	 = @budgetinfoid_1 and budgettypeid = @budgettypeid_2)
GO

CREATE PROCEDURE FnaBudgetCheckDetail_Delete
	(@budgetinfoid_1 	int,
	@flag	int	output, 
	@msg	varchar(80) output)

AS DELETE FnaBudgetCheckDetail 

WHERE 
	( budgetinfoid	 = @budgetinfoid_1)
GO

CREATE PROCEDURE FnaBudgetCheckDetail_Insert
	(@budgetinfoid_1 	int,
	 @budgetperiods_2 	int,
	 @budgetstartdate_3 	char(10),
	 @budgetenddate_4 	char(10),
	 @budgettypeid_5 	int,
	 @budgetaccount_9 	decimal(18,2),
	 @budgetremark_10 	varchar(250),
	@flag	int	output, 
	@msg	varchar(80) output)

AS INSERT INTO FnaBudgetCheckDetail 
	 ( budgetinfoid,
	 budgetperiods,
	 budgetstartdate,
	 budgetenddate,
	 budgettypeid,
	 budgetaccount,
	 budgetremark) 
 
VALUES 
	( @budgetinfoid_1,
	 @budgetperiods_2,
	 @budgetstartdate_3,
	 @budgetenddate_4,
	 @budgettypeid_5,
	 @budgetaccount_9,
	 @budgetremark_10)
GO



alter TRIGGER [Tri_U_workflow_createlist] on [HrmResource] WITH ENCRYPTION
FOR UPDATE
AS
Declare @workflowid int,
	@type int,
 	@objid int,
	@level_n int,
	@userid int,
    @olddepartmentid_1 int,
    @departmentid_1 int,
    @oldseclevel_1	 int,
    @seclevel_1	 int,
    @countdelete   int,
	@all_cursor cursor,
	@detail_cursor cursor

select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel from deleted
select @departmentid_1 = departmentid, @seclevel_1 = seclevel from inserted

/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
if ( @departmentid_1 <>@olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 or @oldseclevel_1 is null)     
begin

    delete from workflow_createrlist

    SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    select workflowid,type,objid,level_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

    OPEN @all_cursor 
    FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
    WHILE @@FETCH_STATUS = 0 
    begin 
        if @type=1 
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            select id from HrmResource where departmentid = @objid and seclevel >= @level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=2
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            SELECT resourceid as id FROM HrmRoleMembers where roleid =  @objid and rolelevel >=@level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=3
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@objid,'0')
        end
        else if @type=4
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-1',@level_n) 
        end
        else if @type=20
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and type = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=21
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and status = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=22
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and department = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=25
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-2',@level_n) 
        end
        else if @type=30
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            select id from HrmResource where subcompanyid1 = @objid and seclevel >= @level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor
        end
        FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
    end 
    CLOSE @all_cursor 
    DEALLOCATE @all_cursor  
end
go

/* 2003-04-15 建立奖惩种类表 */

CREATE TABLE HrmAwardType (
	id int IDENTITY (1, 1) NOT NULL ,
	name varchar (60)  NULL ,
	awardtype char (1)  NULL ,
	description varchar (200) NULL ,
	transact varchar (200) 
) 
GO

/* 2003-04-16 建立奖惩记录表 */
CREATE TABLE HrmAwardInfo (
	id int IDENTITY (1, 1) NOT NULL  ,
	rptitle varchar (60)  NULL ,
	resourseid int   NULL ,
	rptypeid int NULL ,
	rpdate char(10)  NULL ,
	rpexplain varchar (200) NULL,
	rptransact varchar (200) NULL
) 
GO

/* 2003-4-16建立奖惩种类存储过程 */
CREATE PROCEDURE HrmAwardType_Insert
(@name_2 varchar(60),
 @awardtype_3 char(1),
 @description_4 varchar(200),
 @transact_5 varchar(200),
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmAwardType (name,awardtype,description,transact) values (@name_2,@awardtype_3,
   @description_4, @transact_5)
 GO

/* 2003-4-16建立奖惩管理存储过程 */
CREATE PROCEDURE HrmAwardInfo_Insert
(@rptitle_2 varchar(60),
 @resourseid_3 int,
 @rptypeid_4 int,
 @rpdate_5 char(10),
 @rpexplain_6 varchar(200),
 @rptransact_7 varchar(200),
 @flag int output, @msg varchar(60) output)
 AS
    insert into HrmAwardInfo (rptitle,resourseid,rptypeid,rpdate,rpexplain,rptransact) values (@rptitle_2,@resourseid_3,@rptypeid_4,@rpdate_5,@rpexplain_6,@rptransact_7)
 GO

 /*2003-4-17*/
  CREATE PROCEDURE HrmAwardType_SByid
(@id_1 int,
 @flag int output, @msg varchar(60) output)
 as
 select * from HrmAwardType where id= @id_1
 go



 /*2003-4-17修改奖惩种类存储过程*/
CREATE PROCEDURE HrmAwardType_Update
(@id_1 int,
 @name_2 varchar(60),
 @awardtype_3 char(1),
 @description_4 varchar(200),
 @transact_5 varchar(200),
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmAwardType set
name = @name_2,
awardtype = @awardtype_3,
description = @description_4,
transact= @transact_5
WHERE
 id = @id_1
GO

/*2003-4-17删除一条奖惩种类*/
CREATE PROCEDURE HrmAwardType_Delete
(@id_1 int,
 @flag int output, @msg varchar(60) output)
 as
 delete HrmAwardType where id = @id_1
 go

  /*2003-4-18*/
CREATE PROCEDURE HrmAwardInfo_SByid
(@id_1 int,
 @flag int output, @msg varchar(60) output)
AS
 select * from HrmAwardInfo where id= @id_1
GO

/*2003-4-18修改奖惩管理存储过程*/
CREATE PROCEDURE HrmAwardInfo_Update
(@id_1 int,
 @rptitle_2 varchar(60),
 @resourseid_3 int,
 @rptypeid_4 int,
 @rpdate_5 char(10),
 @rpexplain_6 varchar(200),
 @rptransact_7 varchar(200),
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmAwardInfo set
rptitle = @rptitle_2,
resourseid = @resourseid_3,
rptypeid = @rptypeid_4,
rpdate = @rpdate_5,
rpexplain = @rpexplain_6,
rptransact = @rptransact_7
WHERE
 id = @id_1
GO

/*2003-4-18删除一条奖惩管理*/
CREATE PROCEDURE HrmAwardInfo_Delete
(@id_1 int,
@flag int output, @msg varchar(60) output)
AS
DELETE HrmAwardInfo WHERE id = @id_1
GO

/*2003年4月15日 建立了一个新的标签*/
insert into HtmlLabelIndex (id,indexdesc) values (6099,'奖惩种类')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6099,'奖惩种类',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6099,'',8)
GO

/*2003年4月16日 建立了一个新的标签*/

insert into HtmlLabelIndex (id,indexdesc) values (6100,'奖惩管理')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6100,'奖惩管理',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6100,'',8)
GO