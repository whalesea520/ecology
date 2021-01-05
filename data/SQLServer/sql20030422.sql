alter table CRM_SellChance add sufactor int null
go
alter table CRM_SellChance add defactor int null
go



alter PROCEDURE CRM_SellChance_insert
(
	@creater_1 int ,
	@subject_1 varchar (50) ,
	@customerid_1 int ,
	@comefromid_1 int ,
	@sellstatusid_1 int ,
	@endtatusid_1 char(1) ,
	@predate_1 char(10) ,
	@preyield_1 decimal(18,2) ,
	@currencyid_1 int ,
	@probability_1 decimal(8,2) ,
	@createdate_1 char(10) ,
	@createtime_1 char(8) ,
	@content_1 text ,
	@sufactor_1 int,
	@defactor_1 int,
	@flag	int	output,
	@msg	varchar(80)	output)
as
insert INTO CRM_SellChance
(
	creater ,
	subject ,
	customerid ,
	comefromid ,
	sellstatusid ,
	endtatusid ,
	predate ,
	preyield ,
	currencyid ,
	probability ,
	createdate ,
	createtime ,
	content,
	sufactor,
	defactor)
	values
	(
	@creater_1  ,
	@subject_1  ,
	@customerid_1  ,
	@comefromid_1  ,
	@sellstatusid_1  ,
	@endtatusid_1  ,
	@predate_1  ,
	@preyield_1  ,
	@currencyid_1  ,
	@probability_1 ,
	@createdate_1  ,
	@createtime_1  ,
	@content_1 ,
	@sufactor_1,
	@defactor_1)
GO


alter PROCEDURE CRM_SellChance_Update
(
	@creater_1 int ,
	@subject_1 varchar (50) ,
	@customerid_1 int ,
	@comefromid_1 int ,
	@sellstatusid_1 int ,
	@endtatusid_1 char(1) ,
	@predate_1 char(10) ,
	@preyield_1 decimal(18,2) ,
	@currencyid_1 int ,
	@probability_1 decimal(8,2) ,
	@content_1 text ,
	@id_1 int,
	@sufactor_1 int,
	@defactor_1 int,
	@flag	int	output,
	@msg	varchar(80)	output)
as
update CRM_SellChance set

	creater = @creater_1,
	subject = @subject_1,
	customerid =@customerid_1,
	comefromid =@comefromid_1,
	sellstatusid=@sellstatusid_1 ,
	endtatusid =@endtatusid_1,
	predate=@predate_1 ,
	preyield =@preyield_1,
	currencyid =@currencyid_1,
	probability =@probability_1,
	content= @content_1,
	sufactor = @sufactor_1,
	defactor = @defactor_1
WHERE id=@id_1
GO

alter table Prj_ProjectInfo add contractids varchar(1000) null
go

create PROCEDURE Prj_ProjectInfo_UConids
(
	@prj_id int ,
	@contractids_1 varchar(1000) ,
	@flag	int	output,
	@msg	varchar(80)	output)
as
	update Prj_ProjectInfo set
	contractids = @contractids_1 WHERE id=@prj_id
go


alter table CRM_CreditInfo add highamount money null
go

 alter PROCEDURE CRM_CreditInfo_Insert 
 (
 @fullname_1 	varchar(50), 
 @creditamount_1 	varchar(50),
 @highamout_1  varchar(50),
 @flag	int	output,
 @msg	varchar(80)	output)
 AS 
 INSERT INTO  CRM_CreditInfo ( fullname, creditamount,highamount) 
 VALUES ( @fullname_1, convert(money,@creditamount_1),convert(money,@highamout_1))
GO


 alter PROCEDURE CRM_CreditInfo_Update 
 (
 @id_1 	int, 
 @fullname_1 	varchar(50),
 @creditamount_1 	varchar(50),
 @highamout_1  varchar(50),
 @flag	int	output, 
 @msg	varchar(80)	output) 
 AS 
 UPDATE CRM_CreditInfo  SET 
 fullname	 = @fullname_1,
 creditamount	 = convert(money,@creditamount_1 ) ,
 highamount	 = convert(money,@highamout_1 ) 
 WHERE ( id	 = @id_1)
GO


create table CRM_SelltimeSpan
( 
id int IDENTITY (1, 1) NOT NULL ,
timespan  int null,
spannum   int null
)
go

CREATE PROCEDURE CRM_SellTimespan_SelectAll
(
 @flag	int	output, 
 @msg	varchar(80)	output) 
 as
 select * from CRM_SelltimeSpan 
 go


 CREATE PROCEDURE CRM_SellTimespan_insert
(
 @time_1 int,
 @spannum_1 int,
 @flag	int	output, 
 @msg	varchar(80)	output) 
 as 
 insert INTO CRM_SelltimeSpan
 (timespan,spannum)values(@time_1,@spannum_1)
 go


 CREATE PROCEDURE CRM_SellTimespan_update
( 
 @time_1 int,
 @spannum_1 int,
 @flag	int	output, 
 @msg	varchar(80)	output) 
 as
 update CRM_SelltimeSpan set
 timespan = @time_1,
 spannum = @spannum_1
 go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2252,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2252,'成功关键因数',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2252,'成功关键因数')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2253,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2253,'失败关键因数',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2253,'失败关键因数')
go


/* 2003-04-22 建立考核种类表 */
CREATE TABLE HrmCheckKind (
	id int IDENTITY (1, 1) NOT NULL  ,
	checkname varchar (60)  NULL ,
	checkcycle char (1)   NULL ,
        checkexpecd int NULL,
	checkstartdate char  NULL ,
	checkenddate char  NULL 
) 
GO

/* 2003-04-22 建立考核种类项目表 */
CREATE TABLE HrmCheckKindItem (
	id int IDENTITY (1, 1) NOT NULL  ,
	checktypeid int  NULL ,
	checkitemid int   NULL ,
	checkitemproportion int NULL 
) 
GO

/* 2003-04-22 建立考核岗位表 */
CREATE TABLE HrmCheckPost (
	id int IDENTITY (1, 1) NOT NULL  ,
	checktypeid int  NULL ,
	jobid int   NULL 
	
) 
GO

/* 2003-04-22 建立考核参与人表 */
CREATE TABLE HrmCheckActor (
	id int IDENTITY (1, 1) NOT NULL  ,
	checktypeid int  NULL ,
	typeid int   NULL ,
	resourseid int NULL,
	checkproportion int NULL
	
) 
GO
/* 2003-04-28 建立被考核人表 */
CREATE TABLE HrmByCheckPeople (
	id int IDENTITY (1, 1) NOT NULL  ,
	checktypeid int  NULL ,/*考核id*/
	resourseid int NULL,/*员工ID*/
	checkcycle char (1)   NULL ,/*周期*/
	checkexpecd int NULL,/*考核期*/
	checkstartdate char  NULL ,/*开始日期*/
        checkenddate char  NULL ,
	result char (8) NULL/*成绩*/
	
) 
GO

/* 2003-04-28 建立考核表 */
CREATE TABLE HrmCheckList (
	id int IDENTITY (1, 1) NOT NULL  ,
	name varchar (60) NULL,
	checktypeid int  NULL ,/*考核id*/
	startdate char NULL,/*开始日期*/
	enddate char NULL ,/*结束日期*/
	status varchar (10) NULL/*考核状态*/
		
) 
GO

/* 2003-04-28 建立考核成绩表 */
CREATE TABLE HrmCheckGrade (
	id int IDENTITY (1, 1) NOT NULL  ,
	resourseid int NULL,/*员工ID*/
	checktypeid int  NULL ,/*考核id*/
	itemid int NULL,/*项目ID*/
	result float  NULL /*成绩*/
			
) 
GO



/* 2003-4-25建立考核种类存储过程 */
CREATE PROCEDURE HrmCheckKind_Insert
(@checkname_2 varchar(60),
 @checkcycle_3 char(1),
 @checkexpecd_4 int,
 @checkstartdate_5 char,
 @checkenddate_6 char,
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmCheckKind (checkname,checkcycle,checkexpecd,checkstartdate,checkenddate) values (@checkname_2,@checkcycle_3,
   @checkexpecd_4, @checkstartdate_5,@checkenddate_6)
 GO

 /* 2003-4-25建立针对的岗位存储过程 */
CREATE PROCEDURE HrmCheckPost_Insert
(@checktypeid_2 int,
 @jobid_3 int,
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmCheckPost (checktypeid,jobid) values (@checktypeid_2,@jobid_3)
 GO

 /* 2003-4-25建立考核项目存储过程 */
CREATE PROCEDURE HrmCheckKindItem_Insert
(@checktypeid_2 int,
 @checkitemid_3 int,
 @checkitemproportion_4 int,
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmCheckKindItem (checktypeid,checkitemid,checkitemproportion) values (@checktypeid_2,@checkitemid_3,
   @checkitemproportion_4)
 GO

  /* 2003-4-25建立考核参与人表的存储过程 */
CREATE PROCEDURE HrmCheckActor_Insert
(@checktypeid_2 int,
 @typeid_3 int,
 @resourseid_4 int,
 @checkproportion_5 int,
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmCheckActor (checktypeid,typeid,resourseid,checkproportion) values (@checktypeid_2,
   @typeid_3,@resourseid_4,@checkproportion_5)
 GO
/*2003-4-28显示考核种类的一条记录*/
CREATE PROCEDURE HrmCheckKind_SByid
(@id_1 int,
 @flag int output, @msg varchar(60) output)
AS
 select * from HrmCheckKind where id= @id_1
GO

/*2003-4-28显示针对的岗位的一条记录*/
CREATE PROCEDURE HrmCheckPost_SByid
(@id_1 int,
 @flag int output, @msg varchar(60) output)
AS
 select * from HrmCheckPost where id= @id_1
GO

 /*2003-4-17修改考核种类存储过程*/
CREATE PROCEDURE HrmCheckKind_Update
(@id_1 int,
 @checkname_2 varchar(60),
 @checkcycle_3 char(1),
 @checkexpecd_4 int,
 @checkstartdate_5 char,
 @checkenddate_6 char,
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmCheckKind set
checkname = @checkname_2,
checkcycle = @checkcycle_3,
checkexpecd = @checkexpecd_4,
checkstartdate= @checkstartdate_5,
checkenddate = @checkenddate_6
WHERE
 id = @id_1
GO

/*2003年4月22日 建立了一个新的标签*/
insert into HtmlLabelIndex (id,indexdesc) values (6124,'考核实施')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6124,'考核实施',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6124,'',8)
GO

/*2003年4月22日 建立了一个新的标签*/
insert into HtmlLabelIndex (id,indexdesc) values (6125,'考核报告')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6125,'考核报告',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6125,'',8)
GO


alter table HrmCareerInvite add 
  careerplanid int null
go

alter table HrmCareerInvite add 
  isweb int default(1)
  /*1:yes;2:no*/
go

create table HrmCareerInviteStep
(id int identity(1,1) not null,
 inviteid int null,
 name varchar(60) null,
 startdate char(10) null,
 enddate char(10) null,
 assessor int null,
 assessstartdate char(10) null,
 assessenddate char(10) null,
 informdate char(10) null
 )
go

alter table HrmTrainRecord drop
 column createid
 /*trainunit 记录 培训资源id，traintype 记录 培训活动id,trainour 记录 培训成绩，trainrecord 记录培训考评*/
go

alter table HrmTrainRecord drop
 column createdate
go

alter table HrmTrainRecord drop
 column createtime
go

alter table HrmTrainRecord drop
 column lastmoderid
go

alter table HrmTrainRecord drop
 column lastmoddate
go

alter table HrmTrainRecord drop
 column lastmodtime
go

alter table HrmCareerApply alter 
  column id int not null
go

alter table HrmCareerApply add
  careerinviteid int null
go

alter table HrmCareerApply add
  folk varchar(30) null
go

alter table HrmCareerApply add
  islabouunion char(1) null
go

alter table HrmCareerApply add
  weight int null
go

alter table HrmCareerApply add
  tempresidentnumber varchar(60) null
go

create table HrmInterview
(id int identity(1,1) not null,
 resourceid int null,
 stepid int null,
 date char(10) null,
 time char(8) null,
 address varchar(200) null,
 notice text null,
 status int default(0),
 /*0、未考核；1、通过；2、备份*/
 interviewer varchar(200) null)
go

alter table HrmCareerApply add
  nowstep int default(0)
go

alter table HrmCareerApply add
  isinform int default(0)
  /*0、未通知；1、已通知*/
go

create table HrmInterviewAssess
(id int identity(1,1) not null,
 resourceid int null,
 stepid int null,
 result int null,
 remark text null,
 assessor int null,
 assessdate char(10) null)
go

create table HrmInterviewResult
(id int identity(1,1) not null,
 resourceid int null,
 stepid int null,
 result int null,
 /*0、淘汰；1、通过；2、备案*/
 remark text null,
 tester int null,
 testdate char(10) null)
go

ALTER  procedure HrmResourceDateCheck
 (@today_1 char(10),
  @flag int output, @msg varchar(60) output)
 as update HrmResource set
   status = 7
 where
    (status = 0 or status = 1 or status = 2 or status = 3) and enddate < @today_1 and enddate <>''
 update HrmResource set
   status = 3
 where
   status = 0 and probationenddate < @today_1
 
GO

 alter PROCEDURE HrmCareerInvite_Insert 
 (@careername_1 	[varchar](80), 
  @careerpeople_2 	[char](4), 
  @careerage_3 	[varchar](60), 
  @careersex_4 	[char](1), 
  @careeredu_5 	[char](1), 
  @careermode_6 	[varchar](60), 
  @careeraddr_7 	[varchar](100), 
  @careerclass_8 	[varchar](60), 
  @careerdesc_9 	[text], 
  @careerrequest_10 	[text], 
  @careerremark_11 	[text], 
  @createrid_12 	[int], 
  @createdate_13 	[char](10), 
  @planid_14 	[char](10), 
  @isweb_15 	[char](10), 
  @flag integer output , @msg varchar(80) output)
AS INSERT INTO [HrmCareerInvite] 
( [careername], 
  [careerpeople], 
  [careerage], 
  [careersex], 
  [careeredu], 
  [careermode], 
  [careeraddr], 
  [careerclass], 
  [careerdesc], 
  [careerrequest], 
  [careerremark], 
  [createrid], 
  [createdate],
  careerplanid,
  isweb) 
VALUES 
( @careername_1, 
  @careerpeople_2, 
  @careerage_3, 
  @careersex_4, 
  @careeredu_5, 
  @careermode_6, 
  @careeraddr_7, 
  @careerclass_8, 
  @careerdesc_9, 
  @careerrequest_10, 
  @careerremark_11, 
  @createrid_12, 
  @createdate_13,
  @planid_14,
  @isweb_15)
select max(id) from HrmCareerInvite
GO

 alter PROCEDURE HrmCareerInvite_Update 
 (@id_1 	[int], 
  @careername_2 	[varchar](80), 
  @careerpeople_3 	[char](4),
  @careerage_4 	[varchar](60), 
  @careersex_5 	[char](1), 
  @careeredu_6 	[char](1), 
  @careermode_7 	[varchar](60), 
  @careeraddr_8 	[varchar](100),
  @careerclass_9 	[varchar](60),
  @careerdesc_10 	[text], 
  @careerrequest_11 	[text], 
  @careerremark_12 	[text],
  @lastmodid_13 	[int], 
  @lastmoddate_14 	[char](10),
  @planid_15 	[char](10), 
  @isweb_16 	[char](10),
  @flag integer output , @msg varchar(80) output)  
 AS UPDATE [HrmCareerInvite]  SET  
  [careername]	 = @careername_2, 
  [careerpeople]	 = @careerpeople_3, 
  [careerage]	 = @careerage_4, 
  [careersex]	 = @careersex_5, 
  [careeredu]	 = @careeredu_6, 
  [careermode]	 = @careermode_7, 
  [careeraddr]	 = @careeraddr_8, 
  [careerclass]	 = @careerclass_9, 
  [careerdesc]	 = @careerdesc_10, 
  [careerrequest]	 = @careerrequest_11, 
  [careerremark]	 = @careerremark_12, 
  [lastmodid]	 = @lastmodid_13, 
  [lastmoddate]	 = @lastmoddate_14,
  careerplanid = @planid_15,
  isweb = @isweb_16
WHERE ( [id]	 = @id_1) 
GO

CREATE PROCEDURE [HrmCareerInviteStep_Insert]
	(@inviteid_1 	[int],
	 @name_2 	[varchar](60),
	 @startdate_3 	[char](10),
	 @enddate_4 	[char](10),
	 @assessor_5 	[int],
	 @assessstartdate_6 	[char](10),
	 @assessenddate_7 	[char](10),
	 @informdate_8 	[char](10),
	 @flag integer output , @msg varchar(80) output)

AS INSERT INTO [HrmCareerInviteStep] 
	 ( [inviteid],
	 [name],
	 [startdate],
	 [enddate],
	 [assessor],
	 [assessstartdate],
	 [assessenddate],
	 [informdate]) 
 
VALUES 
	(@inviteid_1,
	 @name_2,
	 @startdate_3,
	 @enddate_4,
	 @assessor_5,
	 @assessstartdate_6,
	 @assessenddate_7,
	 @informdate_8)
go

 alter PROCEDURE HrmCareerInvite_Delete 
 (@id_1 	[int], 
  @flag integer output , @msg varchar(80) output)  
 AS DELETE [HrmCareerInvite]  
 WHERE  
  [id]	 = @id_1 
 delete HrmCareerInviteStep 
 where
  inviteid = @id_1
GO

 alter PROCEDURE HrmTrainRecord_Insert 
 (@resourceid_1 	[int], 
  @trainstartdate_2 	[char](10), 
  @trainenddate_3 	[char](10), 
  @traintype_4 	[int], 
  @trainrecord_5 	[text], 
  @trainhour_6		[decimal](18,3), 
  @trainunit_7		[varchar](100), 
  @flag integer output, @msg varchar(80) output)  
AS INSERT INTO  [HrmTrainRecord] 
( [resourceid], 
  [trainstartdate], 
  [trainenddate], 
  [traintype], 
  [trainrecord], 
  trainhour, 
  trainunit )  
VALUES 
( @resourceid_1, 
  @trainstartdate_2, 
  @trainenddate_3, 
  @traintype_4, 
  @trainrecord_5, 
  @trainhour_6, 
  @trainunit_7) 
GO

create procedure HrmCareerApply_InsertBasic
(@id_1 int,
 @lastname_2 varchar(60),
 @sex_3 char(1),
 @jobtitle_4 int,
 @homepage_5 varchar(60),
 @email_6 varchar(60),
 @homeaddress_7 varchar(100),
 @homepostcode_8 varchar(20),
 @homephone_9 varchar(60),
 @inviteid_10 int,
 @flag int output, @msg varchar(60) output)
as insert into HrmCareerApply
(id,
 lastname,
 sex,
 jobtitle,
 homepage,
 email,
 homeaddress,
 homepostcode,
 homephone,
 careerinviteid)
values
(@id_1,
 @lastname_2,
 @sex_3,
 @jobtitle_4,
 @homepage_5,
 @email_6, 
 @homeaddress_7,
 @homepostcode_8,
 @homephone_9,
 @inviteid_10)
go


CREATE PROCEDURE [HrmCareerApplyOtherIndo_In]
	(@applyid_2 	[int],
	 @category_3 	[char](1),
	 @contactor_4 	[varchar](30),
	 @salarynow_5 	[varchar](60),
	 @worktime_6 	[varchar](10),
	 @salaryneed_7 	[varchar](60),
	 @currencyid_8 	[int],
	 @reason_9 	[varchar](200),
	 @otherrequest_10 	[varchar](200),
	 @selfcomment_11 	[text],
        @flag int output, @msg varchar(60) output)
AS INSERT INTO [HrmCareerApplyOtherInfo] 
	 ([applyid],
	 [category],
	 [contactor],
	 [salarynow],
	 [worktime],
	 [salaryneed],
	 [currencyid],
	 [reason],
	 [otherrequest],
	 [selfcomment]) 
 
VALUES 
	(@applyid_2,
	 @category_3,
	 @contactor_4,
	 @salarynow_5,
	 @worktime_6,
	 @salaryneed_7,
	 @currencyid_8,
	 @reason_9,
	 @otherrequest_10,
	 @selfcomment_11)
go

CREATE PROCEDURE HrmCareerApply_InsertPer
( @id_1 int, 
  @birthday_2 char(10), 
  @folk_3 varchar(30), 
  @nativeplace_4 varchar(100), 
  @regresidentplace_5 varchar(60), 
  @maritalstatus_6 char(1), 
  @policy_7 varchar(30),
  @bememberdate_8 char(10), 
  @bepartydate_9 char(10), 
  @islabouunion_10 char(1),
  @educationlevel_11 char(1), 
  @degree_12 varchar(30), 
  @healthinfo_13  char(1), 
  @height_14 int,
  @weight_15 int, 
  @residentplace_16 varchar(60), 
  @tempresidentnumber_18 varchar(60), 
  @certificatenum_19 varchar(60),
  @flag int output, @msg varchar(60) output)
AS UPDATE HrmCareerApply SET 
  birthday = @birthday_2,
  folk = @folk_3,
  nativeplace = @nativeplace_4,
  regresidentplace = @regresidentplace_5,
  maritalstatus = @maritalstatus_6,
  policy = @policy_7,
  bememberdate = @bememberdate_8,
  bepartydate = @bepartydate_9,
  islabouunion = @islabouunion_10,
  educationlevel = @educationlevel_11,
  degree = @degree_12,
  healthinfo = @healthinfo_13,
  height = @height_14,
  weight = @weight_15,
  residentplace = @residentplace_16,
  tempresidentnumber = @tempresidentnumber_18,
  certificatenum = @certificatenum_19
WHERE
  id = @id_1
GO


CREATE PROCEDURE [HrmInterview_Insert]
	(@resourceid_1 	[int],
	 @stepid_2 	[int],
	 @date_3 	[char](10),
	 @time_4 	[char](8),
	 @address_5 	[varchar](200),
	 @notice_6 	[text],
	 @interviewer_8 	[varchar](200),
	 @flag int output, @msg varchar(60) output)
AS INSERT INTO [HrmInterview] 
	 ( [resourceid],
	 [stepid],
	 [date],
	 [time],
	 [address],
	 [notice],
	 [interviewer])  
VALUES 
	(@resourceid_1,
	 @stepid_2,
	 @date_3,
	 @time_4,
	 @address_5,
	 @notice_6,
	 @interviewer_8)
go


CREATE PROCEDURE [HrmInterview_Delete]
	(@id_1 	[int],
	 @stepid_2 int,
	 @flag int output, @msg varchar(60) output)

AS DELETE from [HrmInterview] 
WHERE 
	 [resourceid]	 = @id_1 
and 
         stepid = @stepid_2
go

CREATE PROCEDURE [HrmInterviewAssess_Delete]
	(@id_1 	[int],
	 @stepid_2 int,
	 @userid_3 int,
	 @flag int output, @msg varchar(60) output)

AS DELETE from [HrmInterviewAssess] 
WHERE 
	 [resourceid]	 = @id_1 
and 
         stepid = @stepid_2
and 
         assessor = @userid_3
go

CREATE PROCEDURE [HrmInterviewAssess_Insert]
	(@resourceid_1 	[int],
	 @stepid_2 	[int],
	 @result_3 	int,
	 @remark_4 	text,
	 @userid_5 	int,
	 @assessdate_6 	char(10),
	 @flag int output, @msg varchar(60) output)
AS INSERT INTO [HrmInterviewAssess] 
	 ([resourceid],
	 [stepid],
	 [result],
	 [remark],
	 [assessor],
	 [assessdate])
VALUES 
	(@resourceid_1,
	 @stepid_2,
	 @result_3,
	 @remark_4,
	 @userid_5,
	 @assessdate_6)
go

CREATE PROCEDURE [HrmCareerApply_Inform]
	(@id_1 	[int],	 
	 @flag int output, @msg varchar(60) output)

AS update [HrmCareerApply] set
  isinform = 1
WHERE 
	 id	 = @id_1 
go

CREATE PROCEDURE [HrmInterviewResult_Insert]
	(@resourceid_1 	[int],
	 @stepid_2 	[int],
	 @result_3 	int,
	 @remark_4 	text,
	 @userid_5 	int,
	 @testdate_6 	char(10),
	 @flag int output, @msg varchar(60) output)
AS INSERT INTO [HrmInterviewResult] 
	 ([resourceid],
	 [stepid],
	 [result],
	 [remark],
	 [tester],
	 [testdate])
VALUES 
	(@resourceid_1,
	 @stepid_2,
	 @result_3,
	 @remark_4,
	 @userid_5,
	 @testdate_6)
update HrmInterview set 
  status = 1
go

create procedure HrmCareerApply_Pass
(@resourceid_1 	[int],
 @stepid_2 	[int],
 @flag int output, @msg varchar(60) output)
as update HrmCareerApply set
 nowstep = @stepid_2,
 isinform = 0
where
 id = @resourceid_1
go

create procedure HrmCareerApply_Backup
(@resourceid_1 	[int], 
 @flag int output, @msg varchar(60) output)
as update HrmCareerApply set
 nowstep = 0,
 careerinviteid = 0
where
 id = @resourceid_1
go

alter procedure HrmCareerApply_Delete
(@resourceid_1 	[int], 
 @flag int output, @msg varchar(60) output)

as delete HrmCareerApply 
where
 id = @resourceid_1

delete HrmInterview
where 
 resourceid = @resourceid_1

delete HrmInterviewAssess
where
 resourceid = @resourceid_1

delete HrmInterviewResult
where
 resourceid = @resourceid_1

delete HrmCareerApplyOtherInfo
where 
  applyid = @resourceid_1

delete HrmEducationInfo
where
 resourceid = @resourceid_1

delete HrmFamilyInfo
where
 resourceid = @resourceid_1

delete HrmLanguageAbility
where
 resourceid = @resourceid_1

delete HrmWorkResume
where
 resourceid = @resourceid_1

delete HrmTrainBeforeWork
where
 resourceid = @resourceid_1

delete HrmRewardBeforeWork
where
 resourceid = @resourceid_1

delete HrmCertification
where
 resourceid = @resourceid_1

go

insert into SystemRights (id, rightdesc,righttype) 
  values (374,'用工需求维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(374,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3019,'用工需求添加','HrmUseDemandAdd:Add',374)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3020,'用工需求编辑','HrmUseDemandEdit:Edit',374)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3021,'用工需求删除','HrmUseDemandDelete:Delete',374)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3022,'用工需求日志','HrmUseDemand:Log',374)
go

insert into SystemRights (id, rightdesc,righttype) 
  values (375,'招聘计划维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(375,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3023,'招聘计划添加','HrmCareerPlanAdd:Add',375)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3024,'招聘计划编辑','HrmCareerPlanEdit:Edit',375)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3025,'招聘计划删除','HrmCareerPlanDelete:Delete',375)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3026,'招聘计划日志','HrmCareerPlan:Log',375)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3027,'招聘计划结束','HrmCareerPlanFinish:Finish',375)
go

create procedure HrmResource_UpdateSubCom
(@id_1 int,
 @subcompanyid1_2 int,
 @flag int output, @msg varchar(60) output)
as update HrmResource set
  subcompanyid1 = @subcompanyid1_2
where
  id = @id_1
go

insert into SystemLogItem (itemid,lableid,itemdesc) values(66,807,'培训类型')
go

insert into HtmlLabelIndex (id,indexdesc) values (6128,'培训规划')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6128,'培训规划',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6128,'TrainLayout',8)
go

insert into SystemLogItem (itemid,lableid,itemdesc) values(67,6128,'培训规划')
go

alter procedure HrmResourceDateCheck
 (@today_1 char(10),
  @flag int output, @msg varchar(60) output)
 as update HrmResource set
   status = 7
 where
    (status = 0 or status = 1 or status = 2 or status = 3) and enddate < @today_1 and enddate <>''
 update HrmResource set
   status = 3
 where
   status = 0 and probationenddate > @today_1
 go