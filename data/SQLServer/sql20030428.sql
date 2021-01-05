
delete HrmCompany where id >= 2 
go 

CREATE TABLE TB_SubDeptLineLocation  ( 
     lineid   int  IDENTITY (1, 1) NOT NULL , 
     fromdepartid   int  NOT NULL , 
     fromtype   tinyint  NOT NULL , 
     frompoint   tinyint  NOT NULL , 
     todepartid   int  NOT NULL , 
     totype   tinyint  NOT NULL , 
     topoint   tinyint  NOT NULL , 
     controlpoints   varchar  (200) COLLATE Chinese_PRC_CI_AS NULL )
GO 

ALTER TABLE TB_SubDeptLineLocation  WITH NOCHECK 
ADD CONSTRAINT  PK_TB_SubDeptLineLocation  
PRIMARY KEY CLUSTERED (  lineid  ) WITH FILLFACTOR = 90
GO 

CREATE TABLE TB_DepartLocation  (
     departid   int  NOT NULL , 
     departtype   tinyint  NOT NULL , 
     xpos   int  NULL , 
     ypos   int  NULL )
GO 

ALTER TABLE TB_DepartLocation  WITH NOCHECK 
ADD CONSTRAINT  PK_TB_DepartLocation  
PRIMARY KEY CLUSTERED (  departid ,  departtype  ) WITH FILLFACTOR = 90
GO 

ALTER TABLE TB_DepartLocation  
ADD CONSTRAINT  DF_TB_DepartLocation_x  DEFAULT ((-1)) FOR  xpos , 
    CONSTRAINT  DF_TB_DepartLocation_y  DEFAULT ((-1)) FOR  ypos  
GO

/*新增共享信息*/
CREATE PROCEDURE [CptAssortmentShareInfo_Insert]
(@relateditemid_1 [int],
@sharetype_2 [tinyint],
@seclevel_3 [tinyint],
@rolelevel_4 [tinyint],
@sharelevel_5 [tinyint],
@userid_6 [int],
@departmentid_7 [int],
@roleid_8 [int],
@foralluser_9 [tinyint],
@sharefrom_10 int ,
@flag integer output,
@msg varchar(80) output)

AS INSERT INTO [CptCapitalShareInfo]
( [relateditemid],
[sharetype],
[seclevel],
[rolelevel],
[sharelevel],
[userid],
[departmentid],
[roleid],
[foralluser],
sharefrom)

VALUES
( @relateditemid_1,
@sharetype_2,
@seclevel_3,
@rolelevel_4,
@sharelevel_5,
@userid_6,
@departmentid_7,
@roleid_8,
@foralluser_9,
@sharefrom_10)

select max(id)  id from CptCapitalShareInfo

GO

UPDATE HrmListValidate SET validate_n = 1
go

alter table workflow_bill add operationpage varchar(255)
go
alter table bill_HrmFinance alter column  resourceid int null
go

alter table Bill_ExpenseDetail add relatedcrm int
go

alter table Bill_ExpenseDetail add relatedproject int
go



CREATE TABLE FnaAccountLog (                    /* 收支日志表 */
	id int IDENTITY (1, 1) NOT NULL ,    
	feetypeid int NULL ,			            /* 收入支出类型 */
	resourceid int NULL ,
	departmentid int NULL ,
	crmid int NULL ,
	projectid int NULL ,
	amount decimal(10, 3) NULL ,
	description varchar (250)  NULL ,
	occurdate char (10)  NULL ,
    releatedid  int null,                       /* 相关id 比如报销请求的id ， 收款信息的id */
    releatedname   varchar(255)                 /* 相关的名称，如果请求的名称， 收款信息（合同）的名称 */         
) 
GO


CREATE TABLE FnaLoanLog (                       /* 借还款日志表 */
	id int IDENTITY (1, 1) NOT NULL ,    
	loantypeid int NULL ,			            /* 借还款类型 1:借款 2：还款 3：费用报销还款*/
	resourceid int NULL ,
	departmentid int NULL ,
	crmid int NULL ,
	projectid int NULL ,
	amount decimal(10, 3) NULL ,
	description varchar (250)  NULL ,
    credenceno  varchar(60) ,                   /* 凭证号 */
	occurdate char (10)  NULL , 
    returndate char (10)  NULL ,                /* 还款日期 */
    releatedid  int null,                       /* 相关id 比如报销请求的id ， 借款请求的id */
    releatedname   varchar(255),                /* 相关的名称，如果请求的名称 */
    dealuser  int                               /* 经办人*/
) 
GO

alter PROCEDURE WorkFlow_Bill_Insert
	(@id_1 	int, @namelabel_2 int, @tablename_3	varchar(60),	 @createpage_4 	varchar(255),
	 @managepage_5 	varchar(255),	 @viewpage_6 	varchar(255),	 @detailtablename_7 	varchar(60),
	 @detailkeyfield_8 	varchar(60), @operationpage_9 	varchar(255), @flag int output,	 @msg varchar(60)  output)
AS 
INSERT INTO workflow_bill 
( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) 
VALUES ( @id_1, @namelabel_2, @tablename_3, @createpage_4, @managepage_5, @viewpage_6,	 @detailtablename_7, @detailkeyfield_8,@operationpage_9)
GO


alter PROCEDURE WorkFlow_Bill_Update
	(@id_1 	int, @namelabel_2 int, @tablename_3	varchar(60), @createpage_4 varchar(255),
	 @managepage_5 	varchar(255),	 @viewpage_6 	varchar(255),	 @detailtablename_7 	varchar(60),
	 @detailkeyfield_8 	varchar(60), @operationpage_9 	varchar(255), @flag int output,	 @msg varchar(60) output )
AS UPDATE workflow_bill 
SET  namelabel = @namelabel_2, tablename = @tablename_3, createpage = @createpage_4, managepage = @managepage_5, 
     viewpage = @viewpage_6, detailtablename = @detailtablename_7, detailkeyfield	 = @detailkeyfield_8, operationpage= @operationpage_9 
WHERE 	( id	 = @id_1)
GO

alter PROCEDURE Bill_ExpenseDetail_Insert 
	@expenseid_1		int,
    @feetypeid_1		int,
	@detailremark_1	    varchar(250),
    @accessory_1		int,
    @relatedcrm_1       int,
    @relatedproject_1   int,
	@feesum_1			decimal(10,2),
    @realfeesum_1		decimal(10,2),
	@flag			int	output, 
	@msg			varchar(80) output
as
	insert into bill_expensedetail 
	(expenseid,feetypeid,detailremark,accessory,relatedcrm,relatedproject,feesum,realfeesum)
	values
	(@expenseid_1,@feetypeid_1,@detailremark_1,@accessory_1,@relatedcrm_1,@relatedproject_1,@feesum_1,@realfeesum_1)
GO




CREATE PROCEDURE FnaAccountLog_Insert
	(@feetypeid_1 	int,
	 @resourceid_2 	int,
	 @departmentid_3 	int,
	 @crmid_4 	int,
	 @projectid_5 	int,
	 @amount_6 	decimal,
	 @description_7 	varchar(250),
	 @occurdate_8 	char(10),
     @releatedid_9 	char(10),
     @releatedname_10 	varchar(255),
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
     releatedname) 
 
VALUES 
	( @feetypeid_1,
	 @resourceid_2,
	 @departmentid_3,
	 @crmid_4,
	 @projectid_5,
	 @amount_6,
	 @description_7,
	 @occurdate_8,
     @releatedid_9,
     @releatedname_10)
GO



CREATE PROCEDURE FnaLoanLog_Insert
	(@loantypeid_1 	int,
	 @resourceid_2 	int,
	 @departmentid_3 	int,
	 @crmid_4 	int,
	 @projectid_5 	int,
	 @amount_6 	decimal,
	 @description_7 	varchar(250),
	 @credenceno_8 	varchar(60),
	 @occurdate_9 	char(10),
	 @releatedid_10 	int,
	 @releatedname_11 	varchar(255),
     @returndate_12 	char(10),
     @dealuser_13   integer ,
     @flag          integer output, 
     @msg           varchar(80) output)

AS INSERT INTO FnaLoanLog 
	 ( loantypeid,
	 resourceid,
	 departmentid,
	 crmid,
	 projectid,
	 amount,
	 description,
	 credenceno,
	 occurdate,
	 releatedid,
	 releatedname,
     returndate,
     dealuser) 
 
VALUES 
	( @loantypeid_1,
	 @resourceid_2,
	 @departmentid_3,
	 @crmid_4,
	 @projectid_5,
	 @amount_6,
	 @description_7,
	 @credenceno_8,
	 @occurdate_9,
	 @releatedid_10,
	 @releatedname_11,
     @returndate_12,
     @dealuser_13)
GO


alter PROCEDURE bill_HrmFinance_SelectLoan 
  @resourceid	int, 
  @flag integer output , 
  @msg varchar(80) output 
AS 
  declare @tmpamount1   decimal(10,3),
          @tmpamount2   decimal(10,3)
  select @tmpamount1=sum(amount) from FnaLoanLog 
  where resourceid=@resourceid and loantypeid = 1
  
  select @tmpamount2=sum(amount) from FnaLoanLog
  where resourceid=@resourceid and loantypeid != 1
  
  if    @tmpamount1 is null
        set @tmpamount1=0
  if    @tmpamount2 is null
        set @tmpamount2=0
  if @tmpamount1>=@tmpamount2
    set @tmpamount1=@tmpamount1-@tmpamount2
  else
    set @tmpamount1=0
  select @tmpamount1 
GO

update workflow_browserurl  
set browserurl ='/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype=''1''',
tablename= 'FnaBudgetfeeType',linkurl = '' where id = 22
GO

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6126,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6126,'实报总金额',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (6126,'实报总金额')
go

delete workflow_billfield where billid=7 and fieldname = 'currencyid'
go

delete workflow_billfield where billid=7 and fieldname = 'exchangerate'
go

delete workflow_billfield where billid=7 and fieldname = 'creditledgeid'
go

delete workflow_billfield where billid=7 and fieldname = 'creditremark'
go

update workflow_billfield set fieldlabel = 6126,dsporder=5,fielddbtype='decimal(10,3)' where billid=7 and fieldname = 'realamount'
go

update workflow_billfield set dsporder = 4 where billid=7 and fieldname = 'amount'
go

update workflow_billfield set dsporder = 6 where billid=7 and fieldname = 'accessory'
go

update workflow_billfield set dsporder = 7 , fieldhtmltype = '5' where billid=7 and fieldname = 'debitledgeid'
go

update workflow_billfield set dsporder = 8 where billid=7 and fieldname = 'relatedrequestid'
go

update workflow_billfield set dsporder = 9 where billid=7 and fieldname = 'debitremark'
go

update workflow_billfield set viewtype = '1' , dsporder = 34 , fieldname = 'relatedcrm' where billid=7 and fieldname = 'crmid'
go

update workflow_billfield set viewtype = '1' , dsporder = 35 , fieldname = 'relatedproject' where billid=7 and fieldname = 'projectid'
go

update workflow_billfield set viewtype = '1' , fieldlabel = 534 , dsporder = 36 where billid=7 and fieldname = 'feesum'
go

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'feetypeid',1462,'int',3,22,31,1)
go

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'detailremark',85,'varchar(250)',1,1,32,1)
go

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'accessory',2002,'int',1,2,33,1)
go

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'realfeesum',6016,'decimal(10,2)',1,3,37,1)
GO 

update workflow_bill set operationpage='BillExpenseOperation.jsp' where id = 7
GO


insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,1,'现金') 
GO
insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,2,'支票') 
GO
insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,3,'汇票') 
GO
insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,4,'冲销借款') 
GO
insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,5,'其它') 
GO

update workflow_billfield set fieldname = 'description' where billid=13 and fieldname = 'remark'
GO



/* 加入一个部门主管的角色 */

insert into HrmRoles (rolesmark,rolesname,docid) values ('部门主管','部门主管','')
go
insert into SystemRightRoles (rightid,roleid,rolelevel) values (68,23,'0')
go
insert into SystemRightRoles (rightid,roleid,rolelevel) values (69,23,'0')
go

exec sp_rename 'HrmInterview.date','date_n','column'
GO

alter table HrmUseDemand add
  demanddep int null
go


alter table HrmScheduleDiff add
  salaryitem int null
go

alter table HrmScheduleDiff drop
  column currencyid
go

alter table HrmScheduleDiff drop
  column docid
go

alter table HrmStatusHistory add
  ischangesalary int default(0)
go

create table HrmScheduleMaintance
(id int identity(1,1) not null,
 diffid int null,
 resourceid int null,
 startdate char(10) null,
 starttime char(8) null,
 enddate char(10) null,
 endtime char(8) null,
 memo text null,
 createtype int default(0),
 /*0、工作流维护，不能删除修改；1、维护页面建立，可以删除修改*/
 createrid int null,
 createdate char(10))
go

alter table HrmScheduleDiff
  add color varchar(30) null
go

insert into HtmlLabelIndex (id,indexdesc) values (6130,'培训种类')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6130,'培训种类',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6130,'TrainType',8)
go


update SystemLogItem set lableid=6130,itemdesc='培训种类' where itemid = 66
go

update SystemLogItem set lableid=6129,itemdesc='培训资源' where itemid = 68
go

insert into HtmlLabelIndex (id,indexdesc) values (6131,'用工需求')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6131,'用工需求',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6131,'UseDemand',8)
go


insert into HtmlLabelIndex (id,indexdesc) values (6132,'招聘计划')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6132,'招聘计划',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6132,'CareerPlan',8)
go


insert into HtmlLabelIndex (id,indexdesc) values (6133,'招聘管理')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6133,'招聘管理',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6133,'CareerManage',8)
go


insert into HtmlLabelIndex (id,indexdesc) values (6134,'面试')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6134,'面试',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6134,'Interview',8)
go


alter PROCEDURE [HrmInterview_Insert]
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
	 [date_n],
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

insert into SystemLogItem (itemid,lableid,itemdesc) values(69,6131,'用工需求')
go

insert into SystemLogItem (itemid,lableid,itemdesc) values(70,6132,'招聘计划')
go

insert into HtmlLabelIndex (id,indexdesc) values (6135,'结束信息')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6135,'结束信息',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6135,'FinishInfo',8)
go


insert into HtmlLabelIndex (id,indexdesc) values (6136,'培训活动')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6136,'培训活动',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6136,'Train',8)
go


insert into HtmlLabelIndex (id,indexdesc) values (6137,'入职维护')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6137,'入职维护',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6137,'HrmInfoMaintenance',8)
go


alter procedure HrmUseDemand_Update
(@jobtitle_1 int,
 @status_2 int,
 @demandnum_3 int,
 @demandkind_4 int,
 @leaseedulevel_5 int,
 @date_6 char(10),
 @otherrequest_7 text,
 @id_8 int,
 @department_9 int,
 @flag int output, @msg varchar(60) output)
as update HrmUseDemand set
 demandjobtitle = @jobtitle_1,
 status = @status_2,
 demandnum = @demandnum_3,
 demandkind = @demandkind_4,
 leastedulevel = @leaseedulevel_5,
 demandregdate = @date_6,
 otherrequest = @otherrequest_7,
 demanddep = @department_9
where
 id = @id_8
go


alter PROCEDURE HrmUseDemand_Insert
	(@demandjobtitle_1 	[int],
	 @demandnum_2 	[int],
	 @demandkind_3 	[int],
	 @leastedulevel_4 	[int],
	 @demandregdate_5 	[char](10),
	 @otherrequest_6 	[text],
	 @refermandid_7 	[int],
	 @referdate_8 	[char](10),
	 @createkind_9 	[int],
	 @department_10 int,
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
	 [createkind],
	 demanddep) 
VALUES 
	(@demandjobtitle_1,
	 @demandnum_2,
	 @demandkind_3,
	 @leastedulevel_4,
	 @demandregdate_5,
	 @otherrequest_6,
	 @refermandid_7,
	 @referdate_8,
	 @createkind_9,
	 @department_10)
go

alter PROCEDURE HrmScheduleDiff_Insert 
 (@diffname_1 	[varchar](60), 
  @diffdesc_2 	[varchar](200), 
  @difftype_3 	[char](1), 
  @difftime_4 	[char](1), 
  @mindifftime_5 	[smallint], 
  @workflowid_6 	[int], 
  @salaryable_7 	[char](1), 
  @counttype_8 	[char](1), 
  @countnum_9 	[int],  
  @salaryitem_11 	[int], 
  @diffremark_12 	[text],
  @color_13 varchar(30),
  @flag integer output,   @msg  varchar(80) output)  
AS INSERT INTO [HrmScheduleDiff] 
( [diffname], 
  [diffdesc], 
  [difftype], 
  [difftime], 
  [mindifftime], 
  [workflowid], 
  [salaryable], 
  [counttype], 
  [countnum],  
  [salaryitem], 
  [diffremark],
  color)  
VALUES 
( @diffname_1, 
  @diffdesc_2, 
  @difftype_3, 
  @difftime_4, 
  @mindifftime_5, 
  @workflowid_6, 
  @salaryable_7, 
  @counttype_8, 
  @countnum_9,   
  @salaryitem_11, 
  @diffremark_12,
  @color_13) 
select max(id) from [HrmScheduleDiff] 
GO

alter PROCEDURE HrmScheduleDiff_Update 
 (@id_1 	[int], 
  @diffname_2 	[varchar](60), 
  @diffdesc_3 	[varchar](200), 
  @difftype_4 	[char](1), 
  @difftime_5 	[char](1), 
  @mindifftime_6 	[smallint], 
  @workflowid_7 	[int], 
  @salaryable_8 	[char](1), 
  @counttype_9 	[char](1), 
  @countnum      [varchar](10), 
  @salaryitem_12 	[int], 
  @diffremark_13 	[text], 
  @color_14 varchar(30),
  @flag integer output, @msg varchar(80) output) 
AS declare  @countnum_10 decimal(10,3) if @countnum <>'' set @countnum_10 = convert(decimal(10,3),@countnum) 
  else set  @countnum_10 = 0  
UPDATE [HrmScheduleDiff]  SET  
  [diffname]	 = @diffname_2, 
  [diffdesc]	 = @diffdesc_3, 
  [difftype]	 = @difftype_4, 
  [difftime]	 = @difftime_5, 
  [mindifftime]	 = @mindifftime_6, 
  [workflowid]	 = @workflowid_7, 
  [salaryable]	 = @salaryable_8, 
  [counttype]	 = @counttype_9, 
  [countnum]	 = @countnum_10, 
  [salaryitem]	 = @salaryitem_12, 
  [diffremark]	 = @diffremark_13,
  color = @color_14
WHERE 
( [id]	 = @id_1)  
if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 create PROCEDURE HrmScheduleDiff_Select_All 
 ( @flag integer output , @msg varchar(80) output )
 AS select id, diffname from HrmScheduleDiff 
 order by id 
 set  @flag = 0 set  @msg = '操作成功完成'
GO

alter PROCEDURE HrmScheduleDiff_Select_ByID 
 @id int , 
 @flag integer output , @msg varchar(80) output 
AS select * from HrmScheduleDiff 
where 
 id = (@id) 
set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

alter PROCEDURE HrmResource_Redeploy 
(@id_1 int, 
 @changedate_2 char(10), 
 @changereason_4 char(10), 
 @oldjobtitleid_7 int, 
 @oldjoblevel_8 int, 
 @newjobtitleid_9 int, 
 @newjoblevel_10 int, 
 @infoman_6 varchar(255), 
 @type_n_11 int, 
 @ischangesalary_12 int,
 @flag int output, @msg varchar(60) output) 
AS INSERT INTO HrmStatusHistory 
(resourceid, 
 changedate, 
 changereason, 
 oldjobtitleid, 
 oldjoblevel, 
 newjobtitleid, 
 newjoblevel, 
 infoman, 
 type_n,
 ischangesalary) 
VALUES 
(@id_1, 
 @changedate_2, 
 @changereason_4, 
 @oldjobtitleid_7, 
 @oldjoblevel_8, 
 @newjobtitleid_9, 
 @newjoblevel_10, 
 @infoman_6, 
 @type_n_11,
 @ischangesalary_12)
GO
 
create procedure HrmResource_UpdateByDep
(@id_1 int,
 @subcompanyid1_2 int,
 @flag int output, @msg varchar(60) output)
as update HrmResource set
 subcompanyid1 = @subcompanyid1_2
where
 departmentid = @id_1 
go


CREATE PROCEDURE [HrmScheduleMain_Update]
	(@id_1 	[int],
	 @diffid_2 	[int],
	 @resourceid_3 	[int],
	 @startdate_4 	[char](10),
	 @starttime_5 	[char](8),
	 @enddate_6 	[char](10),
	 @endtime_7 	[char](8),
	 @memo_8 	[text],
	 @flag int output, @msg varchar(60) output)
AS UPDATE [HrmScheduleMaintance] SET  
         [diffid]	 = @diffid_2,
	 [resourceid]	 = @resourceid_3,
	 [startdate]	 = @startdate_4,
	 [starttime]	 = @starttime_5,
	 [enddate]	 = @enddate_6,
	 [endtime]	 = @endtime_7,
	 [memo]	         = @memo_8 

WHERE 
	( [id]	 = @id_1)
go


CREATE PROCEDURE HrmScheduleMain_Insert
	(@diffid_1 	[int],
	 @resourceid_2 	[int],
	 @startdate_3 	[char](10),
	 @starttime_4 	[char](8),
	 @enddate_5 	[char](10),
	 @endtime_6 	[char](8),
	 @memo_7 	[text],
	 @createtype_8 	[int],
	 @createrid_9 	[int],
	 @createdate_10 	[char](10),
	 @flag int output, @msg varchar(60) output)

AS INSERT INTO HrmScheduleMaintance 
	 ( [diffid],
	 [resourceid],
	 [startdate],
	 [starttime],
	 [enddate],
	 [endtime],
	 [memo],
	 [createtype],
	 [createrid],
	 [createdate]) 
 
VALUES 
	( @diffid_1,
	 @resourceid_2,
	 @startdate_3,
	 @starttime_4,
	 @enddate_5,
	 @endtime_6,
	 @memo_7,
	 @createtype_8,
	 @createrid_9,
	 @createdate_10)
go	

CREATE PROCEDURE [HrmScheduleMain_Delete]
	(@id_1 	[int],
	 @flag int output, @msg varchar(60) output)
AS delete from [HrmScheduleMaintance] 
WHERE 
	( [id]	 = @id_1)
go

insert into SystemLogItem (itemid,lableid,itemdesc) values(79,6138,'考勤维护')
go

insert into HtmlLabelIndex (id,indexdesc) values (6138,'考勤维护')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6138,'考勤维护',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6138,'ScheduleMaintance',8)
go


insert into HtmlLabelIndex (id,indexdesc) values (6139,'考勤种类')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6139,'考勤种类',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6139,'ScheduleDiffType',8)
go


update SystemLogItem set lableid=6139,itemdesc='考勤种类' where itemid = 17
go

 CREATE PROCEDURE HrmSchedule_Select_DepTotal
 (@id_1 int,
 @flag integer output, @msg varchar(80) output ) 
 AS select totaltime from HrmSchedule 
 where 
   scheduletype ='1' 
 and 
   relatedid = @id_1
GO

insert into HtmlLabelIndex (id,indexdesc) values (6140,'人力资源考勤')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6140,'人力资源考勤',7)
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6140,'HrmResourceSchedule',8)
go
