create table HrmEducationLevel
(id int identity(1,1) not null,
 name varchar(60) null,
 description varchar(200) null)
go

insert into SystemRights (id, rightdesc,righttype) 
  values (381,'考勤维护维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(381,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3028,'考勤维护添加','HrmScheduleMaintanceAdd:Add',381)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3029,'考勤维护编辑','HrmScheduleMaintanceEdit:Edit',381)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3030,'考勤维护删除','HrmScheduleMaintanceDelete:Delete',381)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3031,'考勤维护日志','HrmScheduleMaintance:Log',381)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3032,'考勤维护查看','HrmScheduleMaintanceView:View',381)
go

insert into HrmEducationLevel (name,description)values('其他','其他')
go
insert into HrmEducationLevel (name,description)values('初中','初中')
go
insert into HrmEducationLevel (name,description)values('高中','高中')
go
insert into HrmEducationLevel (name,description)values('中技','中技')
go
insert into HrmEducationLevel (name,description)values('中专','中专')
go
insert into HrmEducationLevel (name,description)values('大专','大专')
go
insert into HrmEducationLevel (name,description)values('本科','本科')
go
insert into HrmEducationLevel (name,description)values('硕士研究生','硕士研究生')
go
insert into HrmEducationLevel (name,description)values('博士研究生','博士研究生')
go
insert into HrmEducationLevel (name,description)values('MBA','MBA')
go
insert into HrmEducationLevel (name,description)values('EMBA','EMBA')
go
insert into HrmEducationLevel (name,description)values('博士后','博士后')
go

CREATE PROCEDURE HrmEducationLevel_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmEducationLevel]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmEducationLevel_Insert 
 (@name_1 	[varchar](60), @description_2 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmEducationLevel] ( [name], [description])  VALUES ( @name_1, @description_2) 
GO

 CREATE PROCEDURE HrmEducationLevel_Select 
 @flag integer output , @msg varchar(80) output  AS select * from HrmEducationLevel set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmEducationLevel_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmEducationLevel where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmEducationLevel_Update 
 (@id_1 	[int], @name_2 	[varchar](60), @description_3 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmEducationLevel]  SET  [name]	 = @name_2, [description]	 = @description_3  WHERE ( [id]	 = @id_1) 
GO

insert into SystemLogItem (itemid,lableid,itemdesc) values(80,818,'学历')
go

insert into SystemRights (id, rightdesc,righttype) 
  values (382,'学历维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(382,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3033,'学历添加','HrmEducationLevelAdd:Add',382)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3034,'学历编辑','HrmEducationLevelEdit:Edit',382)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3035,'学历删除','HrmEducationLevelDelete:Delete',382)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3036,'学历日志','HrmEducationLevel:Log',382)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3037,'学历查看','HrmEducationLevelView:View',382)
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
   status = 0 and probationenddate < @today_1 
GO

alter procedure HrmResource_DepUpdate
(@id_1 int,
 @departmentid_2 int,
 @joblevel_3 int,
 @costcenterid_4 int,
 @jobtitle_5 int,
 @flag int output,@msg varchar(60) output)
as update HrmResource set
  departmentid = @departmentid_2,
  joblevel = @joblevel_3,
  costcenterid = @costcenterid_4,
  jobtitle = @jobtitle_5
where
  id = @id_1
go

alter PROCEDURE HrmDepartment_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmDepartment order by showorder set  @flag = 0 set  @msg = '操作成功完成' 

GO

delete from HrmListValidate
go
insert into HrmListValidate (id,name,validate_n) values(1,'组织结构','1')
go
insert into HrmListValidate (id,name,validate_n) values(2,'人事管理','1')
go
insert into HrmListValidate (id,name,validate_n) values(3,'基本设置','1')
go
insert into HrmListValidate (id,name,validate_n) values(4,'合同管理','1')
go
insert into HrmListValidate (id,name,validate_n) values(5,'考勤管理','1')
go
insert into HrmListValidate (id,name,validate_n) values(6,'财务管理','1')
go
insert into HrmListValidate (id,name,validate_n) values(7,'奖惩考核','1')
go
insert into HrmListValidate (id,name,validate_n) values(8,'培训管理','1')
go
insert into HrmListValidate (id,name,validate_n) values(9,'招聘管理','1')
go
insert into HrmListValidate (id,name,validate_n) values(10,'会议','1')
go
insert into HrmListValidate (id,name,validate_n) values(11,'个人信息','1')
go
insert into HrmListValidate (id,name,validate_n) values(12,'工作信息','1')
go
insert into HrmListValidate (id,name,validate_n) values(13,'财务信息','1')
go
insert into HrmListValidate (id,name,validate_n) values(14,'资产信息','1')
go
insert into HrmListValidate (id,name,validate_n) values(15,'系统信息','1')
go
insert into HrmListValidate (id,name,validate_n) values(16,'密码','1')
go
insert into HrmListValidate (id,name,validate_n) values(17,'工作流','1')
go
insert into HrmListValidate (id,name,validate_n) values(18,'计划','1')
go
insert into HrmListValidate (id,name,validate_n) values(19,'邮件发送','1')
go
insert into HrmListValidate (id,name,validate_n) values(20,'考勤','1')
go
insert into HrmListValidate (id,name,validate_n) values(21,'培训记录','1')
go
insert into HrmListValidate (id,name,validate_n) values(22,'奖惩记录','1')
go
insert into HrmListValidate (id,name,validate_n) values(23,'日志','1')
go
insert into HrmListValidate (id,name,validate_n) values(24,'统计','1')
go
insert into HrmListValidate (id,name,validate_n) values(25,'图片','1')
go
insert into HrmListValidate (id,name,validate_n) values(26,'角色，级别','1')
go
insert into HrmListValidate (id,name,validate_n) values(27,'正在参加的培训活动','1')
go
insert into HrmListValidate (id,name,validate_n) values(28,'可以参加的培训安排','1')
go

insert into HrmScheduleDiff (diffname, diffdesc,difftype,difftime, mindifftime, workflowid,salaryable,counttype,countnum,salaryitem,diffremark,color)
values('加班','加班',0,0,0,1,'',0,0,1,'','ff0033')
go

insert into HrmScheduleDiff (diffname, diffdesc,difftype,difftime, mindifftime, workflowid,salaryable,counttype,countnum,salaryitem,diffremark,color)
values('请假','请假',1,0,0,1,'',0,0,1,'','00ffff')
go

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3038,'应聘人添加','HrmCareerApplyAdd:Add',111)
go

insert into SystemRights (id, rightdesc,righttype) 
  values (383,'合同种类维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(383,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3039,'合同种类添加','HrmContractTypeAdd:Add',383)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3040,'合同种类编辑','HrmContractTypeEdit:Edit',383)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3041,'合同种类删除','HrmContractTypeDelete:Delete',383)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3042,'合同种类日志','HrmContractType:Log',383)
go

insert into HtmlLabelIndex (id,indexdesc) values (6158,'合同种类')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6158,'合同种类',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6158,'HrmContractType',8)
go

insert into SystemLogItem (itemid,lableid,itemdesc) values(81,6158,'合同种类')
go

insert into SystemRights (id, rightdesc,righttype) 
  values (384,'合同维护',3) 
go
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(384,4,1)
 go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3045,'合同添加','HrmContractAdd:Add',384)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3043,'合同编辑','HrmContractEdit:Edit',384)
go
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3044,'合同删除','HrmContractDelete:Delete',384)
go

insert into SystemLogItem (itemid,lableid,itemdesc) values(82,6156,'培训安排')
go

insert into SystemLogItem (itemid,lableid,itemdesc) values(83,6136,'培训活动')
go

alter table SystemSet add pop3server varchar(60)
GO

alter PROCEDURE SystemSet_Update 
 (@emailserver_1  varchar(60) , 
  @debugmode_2   char(1) , 
  @logleaveday_3  tinyint ,
  @defmailuser_4  varchar(60) ,
  @defmailpassword_5  varchar(60) ,
  @pop3server_6  varchar(60), 
  @flag int output, 
  @msg varchar(80) output) 
AS 
 update SystemSet set 
        emailserver=@emailserver_1 , 
        debugmode=@debugmode_2,
        logleaveday=@logleaveday_3 ,
        defmailuser=@defmailuser_4 , 
        defmailpassword=@defmailpassword_5 , 
        pop3server=@pop3server_6 
GO

alter table HrmCheckKind alter column checkstartdate char(10)
GO

alter table HrmCheckKind drop column checkenddate 
GO
/* 2003-05-6 建立考核种类表 */
DROP TABLE HrmCheckKind
GO
CREATE TABLE HrmCheckKind (
	id int IDENTITY (1, 1) NOT NULL PRIMARY KEY ,
	kindname varchar (60)  NULL ,
	checkcycle char (1)   NULL ,
        checkexpecd int NULL,
	checkstartdate char(10)  NULL 
) 
GO  

/* 2003-5-6 建立考核种类项目表 */
DROP TABLE HrmCheckKindItem
GO
CREATE TABLE HrmCheckKindItem (
	id int IDENTITY (1, 1) NOT NULL PRIMARY KEY  ,
	checktypeid int  NULL ,
	checkitemid int   NULL ,
	checkitemproportion int NULL 
) 
GO

/* 2003-5-6 建立考核岗位表 */
DROP TABLE HrmCheckPost
GO
CREATE TABLE HrmCheckPost (
	id int IDENTITY (1, 1) NOT NULL PRIMARY KEY ,
	checktypeid int  NULL ,
	jobid int   NULL 
	
) 
GO

/* 2003-5-6 建立考核参与人表 */
DROP TABLE HrmCheckActor
GO
CREATE TABLE HrmCheckActor (
	id int IDENTITY (1, 1) NOT NULL PRIMARY KEY ,
	checktypeid int  NULL ,
	typeid int   NULL ,
	resourceid int NULL,
	checkproportion int NULL
	
) 
GO
/* 2003-5-6 建立考核表 */
DROP TABLE HrmCheckList
GO
CREATE TABLE HrmCheckList (
	id int IDENTITY (1, 1) NOT NULL PRIMARY KEY ,
	checkname varchar (60) NULL,
	checktypeid int  NULL ,
	startdate char(10) NULL,/*开始日期*/
	enddate char(10) NULL, /*结束日期*/
	status int NULL/*状态*/
	
) 
GO
/* 2003-5-6 建立被考核人表 */
DROP TABLE HrmByCheckPeople
GO
CREATE TABLE HrmByCheckPeople (
	id int IDENTITY (1, 1) NOT NULL PRIMARY KEY ,
	checkid int  NULL ,/*考核id*/
	resourceid int NULL,/*被考核人ID*/
	checkercount int NULL,/*考核人ID*/
	proportion int  NULL ,/*权重*/
        checkresourcetype int NULL,/*类型*/
	result decimal (10,2) NULL,/*成绩*/
	lastmodifydate char(10) NULL/*最后修改的时间*/
	
) 
GO

/* 2003-5-6 建立考核成绩表 */
DROP TABLE HrmCheckGrade
GO
CREATE TABLE HrmCheckGrade (
	id int IDENTITY (1, 1) NOT NULL PRIMARY KEY ,
	checkpeopleid int  NULL ,/*考核id*/
	checkitemid int NULL,/*项目ID*/
	result int  NULL, /*成绩*/
	checkitemproportion int NULL/*权重*/
			
) 
GO

/*2003-4-28修改考核岗位存储过程*/
CREATE PROCEDURE HrmCheckPost_Update
(@id_1 int,
 @checktypeid_2 int,
 @jobid_3 int,
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmCheckPost set
checktypeid = @checktypeid_2,
jobid = @jobid_3
WHERE
 id = @id_1
GO

/*2003-4-28修改考核种类项目存储过程*/
CREATE PROCEDURE HrmCheckKindItem_Update
(@id_1 int,
 @checktypeid_2 int,
 @checkitemid_3 int,
 @checkitemproportion_4 int,
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmCheckKindItem set
checktypeid = @checktypeid_2,
checkitemid = @checkitemid_3,
checkitemproportion = @checkitemproportion_4
WHERE
 id = @id_1
GO

/*2003-4-28修改考核参与人存储过程*/
CREATE PROCEDURE HrmCheckActor_Update
(@id_1 int,
 @checktypeid_2 int,
 @typeid_3 int,
 @resourceid_4 int,
 @checkproportion_5 int,
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmCheckActor set
checktypeid = @checktypeid_2,
typeid = @typeid_3,
resourceid = @resourceid_4,
checkproportion = @checkproportion_5
WHERE
 id = @id_1
GO

 
 /* 2003-4-25建立考核人成绩储过程 */

CREATE PROCEDURE HrmCheckGrade_Insert
(@checkpeopleid_2 int,
 @checkitemid_3 int,
 @result_4 int,
 @checkitemproportion_5 int,
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmCheckGrade (checkpeopleid,checkitemid,result,checkitemproportion) values (@checkpeopleid_2,@checkitemid_3,
   @result_4,@checkitemproportion_5)
 GO

 /*2003-4-28修改考核人成绩存储过程*/

CREATE PROCEDURE HrmCheckGrade_Update
(@id_1 int,
 @checkpeopleid_2 int,
 @checkitemid_3 int,
 @result_4 int,
 @checkitemproportion_5 int,
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmCheckGrade set
checkpeopleid = @checkpeopleid_2,
checkitemid = @checkitemid_3,
result = @result_4,
checkitemproportion = @checkitemproportion_5
WHERE
 id = @id_1
GO

 /* 2003-5-6建立考核表储过程 */
CREATE PROCEDURE HrmCheckList_Insert
(@checkname_2 varchar (60),
 @checktypeid_3 int,
 @startdate_4 char(10),
 @enddate_5 char(10),
 @status_6 int,
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmCheckList (checkname,checktypeid,startdate,enddate,status) values (@checkname_2,@checktypeid_3,
   @startdate_4,@enddate_5,@status_6)
   select max(id) from HrmCheckList 
 GO

/* 2003-5-6建立考核种类存储过程 */
DROP PROCEDURE HrmCheckKind_Insert
GO
CREATE PROCEDURE HrmCheckKind_Insert
(@kindname_2 varchar(60),
 @checkcycle_3 char(1),
 @checkexpecd_4 int,
 @checkstartdate_5 char(10),
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmCheckKind (kindname,checkcycle,checkexpecd,checkstartdate) values (@kindname_2,@checkcycle_3,
   @checkexpecd_4, @checkstartdate_5)
 GO  
  
  /*2003-5-6修改考核种类存储过程*/
DROP PROCEDURE HrmCheckKind_Update
GO
CREATE PROCEDURE HrmCheckKind_Update
(@id_1 int,
 @kindname_2 varchar(60),
 @checkcycle_3 char(1),
 @checkexpecd_4 int,
 @checkstartdate_5 char(10),
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmCheckKind set
kindname = @kindname_2,
checkcycle = @checkcycle_3,
checkexpecd = @checkexpecd_4,
checkstartdate= @checkstartdate_5
WHERE
 id = @id_1
GO

/*2003-05-9建立被考核人表存储过程*/

CREATE PROCEDURE HrmByCheckPeople_Insert
(@checkid_2 int,
 @resourceid_3 int,
 @checkercount_4 int,
 @proportion_5 int,
 @checkresourcetype_6 int,
 @result_7 decimal (10,2),
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmByCheckPeople (checkid,resourceid,checkercount,proportion,checkresourcetype
   ,result) values (@checkid_2,@resourceid_3,@checkercount_4, @proportion_5,@checkresourcetype_6,
   @result_7)
   select max(id) from HrmByCheckPeople
GO  

 /* 2003-5-9建立考核参与人表的存储过程 */
alter PROCEDURE HrmCheckActor_Insert
(@checktypeid_2 int,
 @typeid_3 int,
 @resourceid_4 int,
 @checkproportion_5 int,
 @flag int output, @msg varchar(60) output)
 AS
   insert into HrmCheckActor (checktypeid,typeid,resourceid,checkproportion) values (@checktypeid_2,
   @typeid_3,@resourceid_4,@checkproportion_5)
 GO
 /*2003-5-10修改被考核人表的存储过程*/
CREATE PROCEDURE HrmByCheckPeople_Update
(@id_1 int,
 @result_2 decimal(10,2),
 @lastmodifydate_3 char(10),
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmByCheckPeople set
result = @result_2,
lastmodifydate= @lastmodifydate_3
WHERE
 id = @id_1
GO


insert into HtmlLabelInfo (indexid,labelname,languageid) values (7014,'考核实施',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7014,'',8)
GO



insert into HtmlLabelInfo (indexid,labelname,languageid) values (7015,'奖惩考核',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7015,'',8)
GO


CREATE TABLE CRM_PayInfo
(
id int IDENTITY(1,1) primary key,
payid int null,
factprice decimal(10,2) null,
factdate char(10) null,
creater int null
)
GO

CREATE  PROCEDURE CRM_PayInfo_Insert
	@id_1		int,
	@factprice_1	decimal(10,2),
	@factdate_1 char(10),
	@creater_1 int,
	@flag		int	output, 
	@msg		varchar(80) output
as
	insert into CRM_PayInfo
	(payid,factprice,factdate,creater)
	values
	(	@id_1,@factprice_1,	@factdate_1 ,@creater_1)
GO

CREATE  PROCEDURE CRM_PayInfo_SelectAll
	@id_1		int,
	@flag		int	output, 
	@msg		varchar(80) output
as
	select * from CRM_PayInfo WHERE payid=@id_1 order by factdate desc
GO


CREATE  PROCEDURE CRM_PayInfo_update
	@id_1		int,
	@factprice_1	decimal(10,2),
	@factdate_1 char(10),
	@creater_1 int,
	@flag		int	output, 
	@msg		varchar(80) output
as
	update  CRM_PayInfo set
	factprice=@factprice_1,
	factdate=@factdate_1,
	creater=@creater_1
	WHERE id=@id_1
GO

CREATE  PROCEDURE CRM_PayInfo_del
	@id_1		int,
	@flag		int	output, 
	@msg		varchar(80) output
as
	delete from CRM_PayInfo WHERE id =@id_1
GO



/*crm-proj-fna相结合*/
 alter table CRM_Contract add projid int null
 go



 ALTER PROCEDURE CRM_Contract_Insert 
	(@name_1  varchar (100)   ,
	 @typeId_1  int  ,	
	 @docId_1  varchar (100)   ,
	 @price_1  decimal(10, 2)  ,
	 @crmId_1  int  ,
	 @contacterId_1  int  ,
	 @startDate_1  char (10)   ,
	 @endDate_1  char (10)   ,
	 @manager_1  int  ,
	 @status_1  int  ,
	 @isRemind_1  int  ,
	 @remindDay_1  int  ,
	 @creater_1  int  ,
	 @createDate_1  char (10)   ,
	 @createTime_1  char (10)  ,
	 @prjid_1 int,
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO CRM_Contract 
	 (name , 
	 typeId , 
	 docId , price , crmId , contacterId , startDate , endDate , manager , status , isRemind , remindDay , creater , createDate , createTime,projid) 
 
VALUES 
	( @name_1,
	 @typeId_1,
	 @docId_1, @price_1 , @crmId_1 , @contacterId_1 , @startDate_1 , @endDate_1 , @manager_1 , @status_1 , @isRemind_1 , @remindDay_1 , @creater_1 , @createDate_1 , @createTime_1,@prjid_1)
select top 1 * from CRM_Contract order by id desc
GO


ALTER PROCEDURE CRM_Contract_Update 
	(@id_1 	int ,
	 @name_1  varchar (100)   ,
	 @typeId_1  int  ,	
	 @docId_1  varchar (100)   ,
	 @price_1  decimal(10, 2)  ,
	 @crmId_1  int  ,
	 @contacterId_1  int  ,
	 @startDate_1  char (10)   ,
	 @endDate_1  char (10)   ,
	 @manager_1  int  ,
	 @status_1  int  ,
	 @isRemind_1  int  ,
	 @remindDay_1  int  ,
	 @prjid_1 int,
	 @flag integer output,
	 @msg varchar(80) output)

AS
UPDATE CRM_Contract SET name = @name_1, typeId = @typeId_1 , docId = @docId_1 , price = @price_1 , crmId = @crmId_1 , contacterId = @contacterId_1 , startDate = @startDate_1 , endDate = @endDate_1 , manager = @manager_1 , status = @status_1 , isRemind = @isRemind_1 , remindDay = @remindDay_1 ,projid=@prjid_1  where id = @id_1
GO


alter table CRM_ContractPayMethod add feetypeid int null
go


alter PROCEDURE CRM_ContractPayMethod_Insert 
	(
	 @contractId_1  int  ,	
	 @prjName_1  varchar (100)   ,
	 @typeId_1  int  ,
	 @payPrice_1  decimal(10, 2)  ,
	 @payDate_1  char (10)   ,
	 @factPrice_1  decimal(10, 2)  ,
	 @factDate_1  char (10)  ,
	 @qualification_1 varchar (200) ,
	 @isFinish_1  int  ,
	 @isRemind_1  int  ,
	 @feetypeid_1 int,
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO CRM_ContractPayMethod 
	 (contractId , 
	 prjName , 
	 typeId , payPrice , payDate , factPrice , factDate , qualification , isFinish , isRemind,feetypeid ) 
 
VALUES 
	(@contractId_1,
	 @prjName_1,
	 @typeId_1, @payPrice_1 , @payDate_1 , @factPrice_1 , @factDate_1 , @qualification_1 , @isFinish_1 , @isRemind_1,@feetypeid_1)
GO


alter table FnaAccountLog add iscontractid char(1) default 0
go


alter PROCEDURE FnaAccountLog_Insert
(
@feetypeid_1 int,
@resourceid_2 int,
@departmentid_3 int,
@crmid_4 int,
@projectid_5 int,
@amount_6 decimal,
@description_7 varchar(250),
@occurdate_8 char(10),
@releatedid_9 char(10),
@releatedname_10 varchar(255),
@iscontractid_1 char(1),
@flag          integer output,
@msg           varchar(80) output)

AS INSERT INTO FnaAccountLog
( feetypeid,
resourceid,
departmentid,
crmid,
projectid,
amount,
description,
occurdate,
releatedid,
releatedname,
iscontractid
)

VALUES
(
@feetypeid_1,
@resourceid_2,
@departmentid_3,
@crmid_4,
@projectid_5,
@amount_6,
@description_7,
@occurdate_8,
@releatedid_9,
@releatedname_10,
@iscontractid_1
)
select max(id) from FnaAccountLog
GO

alter table CRM_ContractPayMethod add fnalogid int null
go



create PROCEDURE FnaAccountLog_Update
(
@fnalogid_1 int,
@amount_6 decimal,
@projectid_5 int,
@flag          integer output,
@msg           varchar(80) output)
AS Update FnaAccountLog set 
amount=@amount_6,
projectid = @projectid_5
WHERE id = @fnalogid_1
GO




create TRIGGER Tri_Update_HrmresourceShare ON Hrmresource WITH ENCRYPTION
FOR UPDATE
AS
Declare @resourceid_1 int,
        @subresourceid_1 int,
        @supresourceid_1 int,
        @olddepartmentid_1 int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @oldseclevel_1	 int,
	    @seclevel_1	 int,
        @docid_1	 int,
        @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,
        @sharelevel_1  int,
        @countrec      int,
        @countdelete   int,
        @oldmanagerstr_1    varchar(200),
        @managerstr_1    varchar(200)
        
/* 从刚修改的行中查找修改的resourceid 等 */
select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel , 
       @oldmanagerstr_1 = managerstr from deleted
select @resourceid_1 = id , @departmentid_1 = departmentid, @subcompanyid_1 = subcompanyid1 ,  
       @seclevel_1 = seclevel , @managerstr_1 = managerstr from inserted

/* 如果部门和安全级别信息被修改 */
if ( @departmentid_1 <>@olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 or @oldseclevel_1 is null )     
begin
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0


    /* 该人新建文档目录的列表 */
    exec DocUserCategory_InsertByUser @resourceid_1,'0','',''
    
    /* DOC 部分*/

    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevalue  table(docid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    declare docid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid = @resourceid_1 or ownerid = @resourceid_1 ) and usertype= '1'
    open docid_cursor 
    fetch next from docid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalue values(@docid_1, 2)
        fetch next from docid_cursor into @docid_1
    end
    close docid_cursor deallocate docid_cursor


    /* 自己下级的文档 */
    /* 查找下级 */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subdocid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) or ownerid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and usertype= '1'
    open subdocid_cursor 
    fetch next from subdocid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1
        if @countrec = 0  insert into @temptablevalue values(@docid_1, 1)
        fetch next from subdocid_cursor into @docid_1
    end
    close subdocid_cursor deallocate subdocid_cursor
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    declare sharedocid_cursor cursor for
    select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= @seclevel_1 )  or ( userid= @resourceid_1 ) or (departmentid= @departmentid_1 and seclevel<= @seclevel_1 )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor



    /* 将临时表中的数据写入共享表 */
    declare alldocid_cursor cursor for
    select * from @temptablevalue
    open alldocid_cursor 
    fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into docsharedetail values(@docid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    end
    close alldocid_cursor deallocate alldocid_cursor


    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* 作为crm管理员能看到的客户 */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* 由客户的共享获得的权利 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* 将临时表中的数据写入共享表 */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor



    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* 作为项目管理员能看到的项目4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* 由项目的共享获得的权利 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* 项目成员5 (内部用户) */
	declare @members_1 varchar(200)
	set @members_1 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 
    declare inuserprjid_cursor cursor for
    SELECT  id FROM Prj_ProjectInfo   WHERE  (','+members+','  LIKE  @members_1)  and isblock='1' 
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* 自己下级的资产1 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* 由资产的共享获得的权利 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcptid_cursor cursor for
    select * from @temptablevalueCpt
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor



end        /* 结束修改了部门和安全级别的情况 */
            

       
/* 对于修改了经理字段,新的所有上级增加对该下级的文档共享,共享级别为可读 */
if ( @countdelete > 0 and @managerstr_1 <> @oldmanagerstr_1 )  /* 新建人力资源时候对经理字段的改变不考虑 */
begin
    if ( @managerstr_1 is not null and len(@managerstr_1) > 1 )  /* 有上级经理 */
    begin

        set @managerstr_1 = ',' + @managerstr_1

	/* ------- DOC 部分 ------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, DocDetail t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and ( t2.doccreaterid = @resourceid_1 or t2.ownerid = @resourceid_1 ) and t2.usertype= '1' ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @docid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @docid_1
        end
        close supuserid_cursor deallocate supuserid_cursor
	
	/* ------- CRM 部分 ------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CRM_CustomerInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1,@supresourceid_1,1,3)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* ------- PROJ 部分 ------- */
	declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, Prj_ProjectInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @prjid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1,@supresourceid_1,1,3)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @prjid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* ------- CPT 部分 ------- */
	declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CptCapital t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.resourceid = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @cptid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @cptid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


    end             /* 有上级经理判定结束 */
end   /* 修改经理的判定结束 */

go

CREATE TABLE Bill_HrmAwardInfo (
	id int IDENTITY (1, 1) NOT NULL  ,
	rptitle varchar (60)  NULL ,
	resource_n int   NULL ,
	rpdate  char(10) NULL,
	rptypeid int NULL ,
	rpexplain varchar (200) NULL,
	rptransact varchar (200) NULL ,
	requestid  int
) 
GO

CREATE TABLE Bill_HrmRedeploy (
	id int IDENTITY (1, 1) NOT NULL  ,
	resource_n int   NULL ,
	redeploydate  char(10) NULL,
	oldjob int NULL ,
	newjob int NULL ,
	oldjoblevel int NULL ,
	newjoblevel int NULL ,
	redeployreason varchar (200) NULL,
	ischangesalary	int NULL ,
	requestid  int
) 
GO

CREATE TABLE Bill_HrmDismiss (
	id int IDENTITY (1, 1) NOT NULL  ,
	resource_n int   NULL ,
	dismissdate  char(10) NULL,
	docid int NULL ,
	dismissreason varchar (200) NULL,
	requestid  int
) 
GO

CREATE TABLE Bill_HrmHire (
	id int IDENTITY (1, 1) NOT NULL  ,
	resource_n int   NULL ,
	hiredate  char(10) NULL,
	hirereason varchar (200) NULL,
	requestid  int
) 
GO

CREATE TABLE Bill_HrmScheduleHoliday (
	id int IDENTITY (1, 1) NOT NULL  ,
	diffid  int   NULL ,
	resource_n int   NULL ,
	startdate  char(10) NULL,
	starttime  char(8) NULL,
	enddate  char(10) NULL,
	endtime  char(8) NULL,
	reason varchar (255) NULL,
	requestid  int
) 
GO

CREATE TABLE Bill_HrmScheduleOvertime (
	id int IDENTITY (1, 1) NOT NULL  ,
	diffid  int   NULL ,
	resource_n int   NULL ,
	startdate  char(10) NULL,
	starttime  char(8) NULL,
	enddate  char(10) NULL,
	endtime  char(8) NULL,
	reason varchar (255) NULL,
	requestid  int
) 
GO


CREATE TABLE Bill_HrmUseDemand (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resource_n] int   NULL ,
	[demandjobtitle] [int] NULL ,
	[demandnum] [int] NULL ,
	[demandkind] [int] NULL ,
	[leastedulevel] [int] NULL ,
	[demandregdate] [char] (10)  NULL ,
	[otherrequest] [text]  NULL ,
	[refermandid] [int] NULL ,
	[referdate] [char] (10)  NULL ,
	[status] [int] NULL ,
	[createkind] [int] NULL ,
	[demanddep] [int] NULL ,
	requestid  int
)
GO

CREATE TABLE Bill_HrmTrainplan (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resource_n] [int]   NULL ,
	[trainplanid] [int] NULL ,
	[reason] [text]  NULL ,
	[createdate] [char] (10)  NULL ,
	requestid  int
)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6107	,'奖励申请')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6107,'奖励申请',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6107,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6109	,'奖励种类')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6109,'奖励种类',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6109,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6110	,'职位调动')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6110,'职位调动',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6110,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6111	,'调动日期')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6111,'调动日期',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6111,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6112	,'原岗位')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6112,'原岗位',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6112,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6113	,'新岗位')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6113,'新岗位',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6113,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6114	,'原职级')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6114,'原职级',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6114,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6115	,'现职级')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6115,'现职级',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6115,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6116	,'调动原因')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6116,'调动原因',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6116,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6119	,'离职申请')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6119,'离职申请',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6119,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6120	,'离职合同')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6120,'离职合同',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6120,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6121	,'转正申请')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6121,'转正申请',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6121,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6122	,'转正日期')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6122,'转正日期',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6122,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6123	,'转正备注')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6123,'转正备注',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6123,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6150	,'奖惩申请')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6150,'奖惩申请',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6150,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6151	,'加班')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6151,'加班',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6151,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6152	,'性质')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6152,'性质',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6152,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6153	,'到位时间')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6153,'到位时间',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6153,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6155	,'培训申请')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6155,'培训申请',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6155,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6156	,'培训安排')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6156,'培训安排',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6156,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6157	,'是否重新设置基准工资')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6157,'是否重新设置基准工资',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6157,'',8)
GO

/*工作流浏览框*/
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 6099,'int','/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp?awardtype=0','HrmAwardType','name','id','/hrm/award/HrmAwardTypeEdit.jsp?id=')
GO
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 818,'int','/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp','HrmEducationLevel','name','id','/hrm/educationlevel/HrmEduLevelEdit.jsp?id=')
GO
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 804,'int','/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp','HrmUseKind','name','id','/hrm/usekind/HrmUseKindEdit.jsp?id=')
GO
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 6156,'int','/systeminfo/BrowserMain.jsp?url=/hrm/train/trainplan/HrmTrainPlanBroswer.jsp','HrmTrainPlan','planname','id','/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id=')
GO
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 6159,'int','/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp?difftype=0','HrmScheduleDiff','diffname','id','/hrm/schedule/HrmScheduleDiffEdit.jsp?id=')
GO
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 1881,'int','/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp?difftype=1','HrmScheduleDiff','diffname','id','/hrm/schedule/HrmScheduleDiffEdit.jsp?id=')
GO

/*奖惩申请*/
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(39,6150,'Bill_HrmAwardInfo','AddBillHrmAwardInfo.jsp','ManageBillHrmAwardInfo.jsp','','','') 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (39,'rptitle',344,'varchar(60)',1,1,3,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (39,'resource_n',368,'int',3,1,1,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (39,'rptypeid',6099,'int',3,29,4,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (39,'rpexplain',791,'varchar(200)',2,0,5,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (39,'rptransact',1008,'varchar(200)',2,0,6,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (39,'rpdate',855,'char(10)',3,2,2,0)
GO

/*职位调动*/
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(40,6110,'Bill_HrmRedeploy','BillHrmRedeployAdd.jsp','BillHrmRedeployManage.jsp','','','') 
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (40,'resource_n',368,'int',3,1,1,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (40,'redeploydate',6111,'char(10)',3,2,2,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (40,'oldjob',6112,'int',3,24,3,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (40,'newjob',6113,'int',3,24,4,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (40,'oldjoblevel',6114,'int',1,2,5,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (40,'newjoblevel',6115,'int',1,2,6,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (40,'redeployreason',6116,'varchar(200)',2,0,8,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (40,'ischangesalary',6157,'int',4,0,7,0) 
GO


/* 离职申请 */
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(41,6119,'Bill_HrmDismiss','BillHrmDismissAdd.jsp','BillHrmDismissManage.jsp','','','') 
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (41,'resource_n',368,'int',3,1,1,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (41,'dismissdate',898,'char(10)',3,2,2,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (41,'docid',6120,'int',3,9,3,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (41,'dismissreason',1978,'varchar(200)',2,0,4,0) 
GO

/* 转正申请 */
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(42,6121,'Bill_HrmHire','BillHrmHireAdd.jsp','BillHrmHireManage.jsp','','','') 
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (42,'resource_n',368,'int',3,1,1,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (42,'hiredate',6122,'char(10)',3,2,2,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (42,'hirereason',6123,'varchar(200)',2,0,3,0) 
GO
/* 加班 */
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(45,6151,'Bill_HrmScheduleOvertime','BillHrmScheduleOvertimeAdd.jsp','BillHrmScheduleOvertimeManage.jsp','','','') 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (45,'resource_n',368,'int',3,1,1,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (45,'startdate',740,'char(10)',3,2,3,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (45,'starttime',742,'char(8)',3,19,4,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (45,'enddate',741,'char(10)',3,2,5,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (45,'endtime',743,'char(8)',3,19,6,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (45,'reason',791,'varchar(255)',2,0,7,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (45,'diffid',6159,'int',3,33,2,0) 
GO

/* 请假 */
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(46,670,'Bill_HrmScheduleHoliday','BillHrmScheduleHolidayAdd.jsp','BillHrmScheduleHolidayManage.jsp','','','') 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'resource_n',368,'int',3,1,1,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'startdate',740,'char(10)',3,2,3,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'starttime',742,'char(8)',3,19,4,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'enddate',741,'char(10)',3,2,5,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'endtime',743,'char(8)',3,19,6,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'reason',791,'varchar(255)',2,0,7,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'diffid',1881,'int',3,34,2,0) 
GO
 


/* 用工需求 */

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(47,6131,'Bill_HrmUseDemand','BillHrmDemandAdd.jsp','BillHrmDemandManage.jsp','','','') 
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (47,'demandjobtitle',6086,'int',3,24,2,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (47,'demandnum',1859,'int',1,2,3,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (47,'demandkind',6152,'int',3,31,4,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (47,'leastedulevel',1860,'int',3,30,5,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (47,'demandregdate',6153,'char(10)',3,2,6,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (47,'otherrequest',1847,'text',2,0,7,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (47,'resource_n',368,'int',3,1,1,0) 
GO

/* 培训申请 */

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(48,6155,'Bill_HrmTrainplan','BillHrmTrainplanAdd.jsp','BillHrmTrainplanManage.jsp','','','') 
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (48,'resource_n',368,'int',3,1,1,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (48,'trainplanid',6156,'int',3,32,2,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (48,'reason',85,'text',2,0,3,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (48,'createdate',855,'char(10)',3,2,4,0) 
GO


insert into HtmlLabelIndex (id,indexdesc) values (6159	,'加班类型')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6159,'加班类型',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6159,'',8)
GO



