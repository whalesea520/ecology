
/*以下是谭小鹏第二次补充的《ecology产品开发目录权限补充功能提交测试报告 V1.0》的新增他的table_2003-6-20.sql脚本。*/


ALTER TABLE DocSecCategoryShare Alter column
    sharetype int NULL
go


/*以下是关于陈英杰Ecology产品开发--列表页面分页提交测试报告的脚本*/


alter table HrmResource 
  alter column educationlevel int
go

alter table HrmCareerApply
  alter column educationlevel int
go

alter table HrmEducationInfo
  alter column educationlevel int
go

alter table HrmCareerApplyOtherInfo
  alter column salarynow int
go


/*以下是关于任舸的邮件模板的提交测试报告*/


/*调查项目表*/

create table T_SurveyItem (
inprepid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
mailid int ,
inprepname    varchar(200) ,
inpreptablename       varchar(60) 
)
GO

/*建立存放字段的表*/

CREATE TABLE T_fieldItem (
	 itemid   int  IDENTITY (1, 1) NOT NULL ,
	 inprepid   int  NULL ,
	 itemdspname   varchar  (60)  NULL ,
	 itemfieldname   varchar  (60)  NULL ,
	 itemfieldtype   char  (1)  NULL ,
	 itemfieldscale   int  NULL ,
	 itemfieldunit   varchar  (60)  NULL ,
)
GO


/*可选项的值表*/

create table T_fieldItemDetail (
inprepitemdetailid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
itemid       int ,
itemdsp      varchar(100) ,
itemvalue    varchar(100)
)
GO

/*建立退订表*/


create table T_FadeBespeak (
id int IDENTITY(1,1) NOT NULL ,
crmid int NULL ,/*客户ID*/
inprepid int NULL ,/*调查种类的ID*/
contacterid int NULL ,/*退订人的ID*/
inputid int NULL ,/*调查ID*/
referdate char(10) NULL /*提交日期*/
)
GO

/*建立总表*/

create table T_InceptForm  (
id int IDENTITY(1,1) NOT NULL ,
inputid int NULL ,/*调查ID*/
crmid int NULL ,/*客户ID*/
contacterid int NULL ,/*联系人的ID*/
email varchar  (60)  NULL ,/*客户的email地址*/
state char(10) NULL /*状态*/
)
GO

/*调查表*/

create table T_ResearchTable (
inputid int IDENTITY(1,1) NOT NULL ,
inprepid int NULL,/*调查种类的ID*/
rsearchname varchar  (60)  NULL ,/*调查名称*/
rsearchdate char(10) NULL ,/*调查发布日期*/
countfrom int NULL ,/*应提交的总客户*/
countemial int NULL,/*邮件发送成功的总客户*/
fromcount int NULL,/*实际提交的总客户*/
countfade int NULL, /*退订的总客户*/
state int NULL/*有无联系人*/
)
GO



/*显示*/

CREATE PROCEDURE T_SurveyItem_SelectAll
	(@flag	 int 	output, 
	@msg	 varchar (80)	output) 

AS 
select * from T_SurveyItem
GO
/*建立调查项目*/

CREATE PROCEDURE T_SurveyItem_Insert 
	(@mailid_2 int ,
	 @inprepname_3	 varchar (200),
	 @inpreptablename_4 	 varchar (60),
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output)

AS INSERT INTO  T_SurveyItem  
	 (mailid,
	  inprepname ,
	  inpreptablename)
 
VALUES 
	(@mailid_2 ,
	 @inprepname_3 ,
	 @inpreptablename_4)
GO
/*显示字段表*/

CREATE PROCEDURE T_fieldItem_SelectByItemtypeid
	(@inprepid_1  int ,
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output) 

AS 
select * from T_fieldItem where inprepid = @inprepid_1 order by itemid 
GO
/*显示调查项目*/

CREATE PROCEDURE T_SurveyItem_SelectByInprepid
	(@inprepid_1  int ,
	@flag	 int 	output, 
	@msg	 varchar (80)	output) 

AS 
select * from T_SurveyItem where inprepid = @inprepid_1
GO
/*显示*/

CREATE PROCEDURE T_fieldItem_SelectByItemid
	(@itemid_1  int ,
	@flag	 int 	output, 
	@msg	 varchar (80)	output) 

AS
select * from T_fieldItem where itemid = @itemid_1
GO
/*建立字段表存储过程*/

CREATE PROCEDURE  T_fieldItem_Insert 
	(@inprepid_2   int ,
	 @itemdspname_3   varchar  (60) ,
	 @itemfieldname_4   varchar  (60)   ,
	 @itemfieldtype_5   char  (1)  ,
	 @itemfieldscale_6   int   ,
	 @itemfieldunit_7  varchar  (60)  ,
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output) 

AS INSERT INTO  T_fieldItem  
	( inprepid ,
	  itemdspname ,
	  itemfieldname ,
	  itemfieldtype ,
	  itemfieldscale ,
	  itemfieldunit
	 ) 
 
VALUES 
	(@inprepid_2,
	 @itemdspname_3,
	 @itemfieldname_4,
	 @itemfieldtype_5,
	 @itemfieldscale_6,
	 @itemfieldunit_7
	 )
GO
/*显示*/

CREATE PROCEDURE T_fieldItemDetail_SelectByItemid
	(@itemid_1  int ,
	@flag	 int 	output, 
	@msg	 varchar (80)	output) 

AS 
select * from T_fieldItemDetail where itemid = @itemid_1
GO

/*修改字段表*/

CREATE PROCEDURE  T_fieldItem_Update 
	(@itemid_1 	 int ,
	 @inprepid_2   int ,
	 @itemdspname_3   varchar  (60) ,
	 @itemfieldname_4   varchar  (60)   ,
	 @itemfieldtype_5   char  (1)  ,
	 @itemfieldscale_6   int   ,
	 @itemfieldunit_7 varchar  (60)  ,
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output) 

AS UPDATE  T_fieldItem  
SET       inprepid = @inprepid_2 ,  
          itemdspname  = @itemdspname_3 ,
	  itemfieldname = @itemfieldname_4 ,
	  itemfieldtype = @itemfieldtype_5 ,
	  itemfieldscale = @itemfieldscale_6 ,
          itemfieldunit  = @itemfieldunit_7 
WHERE 
	(  itemid = @itemid_1)
GO
/*删除*/

CREATE PROCEDURE  T_fieldItemDetail_Delete 
	(@itemid_1 	 int  ,
	@flag	 int 	output, 
	@msg	 varchar (80)	output)

AS DELETE  T_fieldItemDetail  

WHERE 
	(  itemid 	 = @itemid_1)
GO
/*添加*/

CREATE PROCEDURE  T_fieldItemDetail_Insert 
	(@itemid_1 	 int ,
	 @itemdsp_2 	 varchar (100),
	 @itemvalue_3 	 varchar (100) ,
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output) 

AS INSERT INTO  T_fieldItemDetail  
	 (itemid ,
	  itemdsp ,
	  itemvalue ) 
 
VALUES 
	(@itemid_1,
	 @itemdsp_2,
	 @itemvalue_3)
GO

/*删除*/

CREATE PROCEDURE  T_fieldItem_Delete 
	(@itemid_1 	 int  ,
	@flag	 int 	output, 
	@msg	 varchar (80)	output) 

AS DELETE T_fieldItem  
WHERE 
	(  itemid 	 = @itemid_1)
GO
/*修改调查项目表*/

CREATE PROCEDURE  T_SurveyItem_Update 
	(@inprepid_1 	 int ,
	 @mailid_2 int,
	 @inprepname_3 	 varchar (200),
	 @inpreptablename_4 	 varchar (60),
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output)

AS UPDATE  T_SurveyItem  

SET       
	  mailid    =   @mailid_2 ,
          inprepname 	 = @inprepname_3 ,
	  inpreptablename 	 = @inpreptablename_4
WHERE 
	(  inprepid 	 = @inprepid_1)
GO
/*显示*/

CREATE PROCEDURE T_fieldItem_SelectByInprepid
	(@inprepid_1  int ,
	@flag	 int 	output, 
	@msg	 varchar (80)	output) 

AS 
select * from T_fieldItem where inprepid = @inprepid_1
GO
/*删除*/

CREATE PROCEDURE  T_SurveyItem_Delete 
	(@inprepid_1 	 int ,
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output)

AS DELETE  T_SurveyItem  

WHERE 
	(  inprepid 	 = @inprepid_1)
GO

/*建立退订的存储过程*/



CREATE PROCEDURE T_FadeBespeak_Insert 
	(@crmid_2 int ,
	 @inprepid_3 int,
	 @contacterid_4	 int ,
	 @inputid_5 int ,
	 @date_6 char(10),
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output)

AS INSERT INTO  T_FadeBespeak  
	 (crmid,
	  inprepid,
	  contacterid ,
	  inputid ,
	  referdate)
VALUES 
	(@crmid_2 ,
	 @inprepid_3 ,
	 @contacterid_4 ,
	 @inputid_5 ,
	 @date_6 )
GO

update CRM_CustomizeOption set fieldname='fullname' where id=203
GO
INSERT INTO CRM_CustomizeOption (id,tabledesc,fieldname,labelid,labelname) values (213,2,'customerid',144,'客户名称')
GO


/*以下是陈英杰招聘管理中学历以及应聘人员搜索修改提交测试报告的脚本*/


alter table HrmResource 
  alter column educationlevel int
go

alter table HrmCareerApply
  alter column educationlevel int
go

alter table HrmEducationInfo
  alter column educationlevel int
go

alter table HrmCareerApplyOtherInfo
  alter column salarynow int
go




alter PROCEDURE HrmResourcePersonalInfo_Insert 
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
  @educationlevel_11 int, 
  @degree_12 varchar(30), 
  @healthinfo_13  char(1), 
  @height_14 int, 
  @weight_15 int, 
  @residentplace_16 varchar(60), 
  @homeaddress_17 varchar(100), 
  @tempresidentnumber_18 varchar(60), 
  @certificatenum_19 varchar(60), 
  @flag int output, @msg varchar(60) output) 
AS UPDATE HrmResource SET 
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
  homeaddress = @homeaddress_17, 
  tempresidentnumber = @tempresidentnumber_18, 
  certificatenum = @certificatenum_19 
WHERE 
  id = @id_1
GO

alter PROCEDURE HrmCareerApply_InsertPer
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
  @educationlevel_11 int, 
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

alter  PROCEDURE HrmEducationInfo_Insert
(@resourceid_1 	int, 
 @startdate_2 	char(10), 
 @enddate_3 	char(10), 
 @school_4 	varchar(100), 
 @speciality_5 	varchar(60) , 
 @educationlevel_6 	int, 
 @studydesc_7 	text, 
 @flag integer output, @msg varchar(80) output) 
AS INSERT INTO HrmEducationInfo 
( resourceid, 
  startdate, 
  enddate, 
  school, 
  speciality, 
  educationlevel, 
  studydesc) 
VALUES 
( @resourceid_1, 
  @startdate_2, 
  @enddate_3, 
  @school_4, 
  @speciality_5, 
  @educationlevel_6 , 
  @studydesc_7) 
GO




/*关于任舸2003-06-30的《e-cology项目邮件模板定义及群发提交测试报告V1.0 》提交测试报告的脚本*/

alter table T_SurveyItem add urlname   varchar(200)

GO


alter PROCEDURE T_SurveyItem_Insert 
	(@mailid_2 int ,
	 @inprepname_3	 varchar (200),
	 @inpreptablename_4 	 varchar (60),
	 @urlname_5    varchar(200),
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output)

AS INSERT INTO  T_SurveyItem  
	 (mailid,
	  inprepname ,
	  inpreptablename,
	  urlname)
 
VALUES 
	(@mailid_2 ,
	 @inprepname_3 ,
	 @inpreptablename_4,
	 @urlname_5)
GO

alter PROCEDURE  T_SurveyItem_Update 
	(@inprepid_1 	 int ,
	 @mailid_2 int,
	 @inprepname_3 	 varchar (200),
	 @inpreptablename_4 	 varchar (60),
	 @urlname_5    varchar(200),
	 @flag	 int 	output, 
	 @msg	 varchar (80)	output)

AS UPDATE  T_SurveyItem  

SET       
	  mailid    =   @mailid_2 ,
          inprepname 	 = @inprepname_3 ,
	  inpreptablename 	 = @inpreptablename_4,
	  urlname    =    @urlname_5
WHERE 
	(  inprepid 	 = @inprepid_1)
GO



/*关于刘煜2003-06-30的《Ecology产品开发-系统工作流优化V1.0提交测试报告》的脚本*/

create NONCLUSTERED INDEX wrkcuoper_requestid_in on workflow_currentoperator(requestid) 
GO
create NONCLUSTERED INDEX wrkcuoper_user_in on workflow_currentoperator(userid,usertype) 
GO
create NONCLUSTERED INDEX wrkreqlog_request_in on workflow_requestLog(requestid,logtype) 
GO
create NONCLUSTERED INDEX wrkreqview_request_in on workflow_requestViewLog(id,currentnodeid) 
GO
create NONCLUSTERED INDEX wrkreqbase_request_in on workflow_requestbase(workflowid,requestid) 
GO
create NONCLUSTERED INDEX wrkform_request_in on workflow_form(requestid,billid) 
GO
create NONCLUSTERED INDEX wrkfieldlable_form_in on workflow_fieldlable(formid,fieldid) 
GO