
CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Delete
(id_1 integer,
flag out integer,
msg  out  varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
delete from fnaBudgetfeetype where id= id_1;
 end;
/

delete HrmCompany where id >= 2 
/

CREATE TABLE TB_SubDeptLineLocation
( 
     lineid   integer   NOT NULL , 
     fromdepartid   integer  NOT NULL , 
     fromtype   smallint  NOT NULL , 
     frompoint   smallint  NOT NULL , 
     todepartid   integer  NOT NULL , 
     totype   smallint  NOT NULL , 
     topoint   smallint  NOT NULL , 
     controlpoints   varchar2(200) NULL )
/
create sequence TB_SubDeptLineLocation_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger TB_SubDeptLineLocation_Tri     
before insert on TB_SubDeptLineLocation                        
for each row                                               
begin                                                      
select TB_SubDeptLineLocation_id.nextval INTO :new.lineid from dual;
end;                                                       
/ 


ALTER TABLE TB_SubDeptLineLocation  ADD 
CONSTRAINT  PK_TB_SubDeptLineLocation  PRIMARY KEY 
(  lineid  ) 
/

CREATE TABLE TB_DepartLocation  (
     departid   integer  NOT NULL , 
     departtype   smallint  NOT NULL , 
     xpos   integer  default -1 , 
     ypos   integer  default -1 )
/ 

ALTER TABLE TB_DepartLocation ADD 
CONSTRAINT  PK_TB_DepartLocation  PRIMARY KEY  
(  departid ,  departtype  ) 
/


/*新增共享信息*/
CREATE or REPLACE PROCEDURE CptAssortmentShareInfo_Insert
(
relateditemid_1 integer,
sharetype_2 smallint,
seclevel_3 smallint,
rolelevel_4 smallint,
sharelevel_5 smallint,
userid_6 integer,
departmentid_7 integer,
roleid_8 integer,
foralluser_9 smallint,
sharefrom_10 integer ,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)

AS 
begin
INSERT INTO CptCapitalShareInfo
( relateditemid,
sharetype,
seclevel,
rolelevel,
sharelevel,
userid,
departmentid,
roleid,
foralluser,
sharefrom)

VALUES
( relateditemid_1,
sharetype_2,
seclevel_3,
rolelevel_4,
sharelevel_5,
userid_6,
departmentid_7,
roleid_8,
foralluser_9,
sharefrom_10);
open thecursor for
select max(id)  id from CptCapitalShareInfo;
end;
/


UPDATE HrmListValidate SET validate_n = 1
/

alter table workflow_bill add operationpage varchar2(255)
/
alter table bill_HrmFinance modify(resourceid integer )
/

alter table Bill_ExpenseDetail add relatedcrm integer
/

alter table Bill_ExpenseDetail add relatedproject integer
/



CREATE TABLE FnaAccountLog (                    /* 收支日志表 */
	id integer  NOT NULL ,    
	feetypeid integer NULL ,			            /* 收入支出类型 */
	resourceid integer NULL ,
	departmentid integer NULL ,
	crmid integer NULL ,
	projectid integer NULL ,
	amount number(10, 3) NULL ,
	description varchar2(250)  NULL ,
	occurdate char (10)  NULL ,
    releatedid  integer null,                       /* 相关id 比如报销请求的id ， 收款信息的id */
    releatedname   varchar2(255)                 /* 相关的名称，如果请求的名称， 收款信息（合同）的名称 */         
) 
/
create sequence FnaAccountLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaAccountLog_Trigger
before insert on FnaAccountLog
for each row
begin
select FnaAccountLog_id.nextval into :new.id from dual;
end ;
/



CREATE TABLE FnaLoanLog (                       /* 借还款日志表 */
	id integer  NOT NULL ,    
	loantypeid integer NULL ,			            /* 借还款类型 1:借款 2：还款 3：费用报销还款*/
	resourceid integer NULL ,
	departmentid integer NULL ,
	crmid integer NULL ,
	projectid integer NULL ,
	amount number(10, 3) NULL ,
	description varchar2(250)  NULL ,
    credenceno  varchar2(60) ,                   /* 凭证号 */
	occurdate char (10)  NULL , 
    returndate char (10)  NULL ,                /* 还款日期 */
    releatedid  integer null,                       /* 相关id 比如报销请求的id ， 借款请求的id */
    releatedname   varchar2(255),                /* 相关的名称，如果请求的名称 */
    dealuser  integer                               /* 经办人*/
) 
/
create sequence FnaLoanLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaLoanLog_Trigger
before insert on FnaLoanLog
for each row
begin
select FnaLoanLog_id.nextval into :new.id from dual;
end ;
/

CREATE or REPLACE PROCEDURE WorkFlow_Bill_Insert
	(
	id_1 	integer,
	namelabel_2 integer,
	tablename_3	varchar2,
	createpage_4 	varchar2,
	managepage_5 	varchar2,
	viewpage_6 	varchar2,	
	detailtablename_7 	varchar2,
	detailkeyfield_8 	varchar2,
	operationpage_9 	varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
begin
INSERT INTO workflow_bill 
( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) 
VALUES 
( id_1, namelabel_2, tablename_3, createpage_4, managepage_5, viewpage_6,	 detailtablename_7, detailkeyfield_8,operationpage_9);
end;
/


CREATE or REPLACE PROCEDURE WorkFlow_Bill_Update
	(
	id_1 	integer,
	namelabel_2 integer,
	tablename_3	varchar2,
	createpage_4 varchar2,
	managepage_5 	varchar2,
	viewpage_6 	varchar2,
	detailtablename_7 	varchar2,
	detailkeyfield_8 	varchar2, 
	operationpage_9 	varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
begin
UPDATE workflow_bill 
SET 
namelabel = namelabel_2,
tablename = tablename_3,
createpage = createpage_4, 
managepage = managepage_5, 
viewpage = viewpage_6,
detailtablename = detailtablename_7,
detailkeyfield	 = detailkeyfield_8,
operationpage= operationpage_9 
WHERE 	( id	 = id_1);
end;
/


CREATE or REPLACE PROCEDURE Bill_ExpenseDetail_Insert 
(
	expenseid_1		integer,
    feetypeid_1		integer,
	detailremark_1	    varchar2,
    accessory_1		integer,
    relatedcrm_1       integer,
    relatedproject_1   integer,
	feesum_1			number,
    realfeesum_1		number,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
	insert into bill_expensedetail 
	(expenseid,feetypeid,detailremark,accessory,relatedcrm,relatedproject,feesum,realfeesum)
	values
	(expenseid_1,feetypeid_1,detailremark_1,accessory_1,relatedcrm_1,relatedproject_1,feesum_1,realfeesum_1);
end;
/





CREATE or REPLACE PROCEDURE FnaAccountLog_Insert
	(
	feetypeid_1 	integer,
	resourceid_2 	integer,
	departmentid_3 	integer,
	crmid_4 	integer,
	projectid_5 	integer,
	amount_6 	number,
	description_7 	varchar2,
	occurdate_8 	char,
	releatedid_9 	char,
	releatedname_10 	varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)

AS
begin
INSERT INTO FnaAccountLog 
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
	( feetypeid_1,
	 resourceid_2,
	 departmentid_3,
	 crmid_4,
	 projectid_5,
	 amount_6,
	 description_7,
	 occurdate_8,
     releatedid_9,
     releatedname_10);
end;
/




CREATE or REPLACE PROCEDURE FnaLoanLog_Insert
	(
	loantypeid_1 	integer,
	resourceid_2 	integer,
	departmentid_3 	integer,
	crmid_4 	integer,
	projectid_5 	integer,
	amount_6 	number,
	description_7 	varchar2,
	credenceno_8 	varchar2,
	occurdate_9 	char,
	releatedid_10 	integer,
	releatedname_11 	varchar2,
	returndate_12 	char,
	dealuser_13   integer ,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)

AS
begin
INSERT INTO FnaLoanLog 
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
	( loantypeid_1,
	 resourceid_2,
	 departmentid_3,
	 crmid_4,
	 projectid_5,
	 amount_6,
	 description_7,
	 credenceno_8,
	 occurdate_9,
	 releatedid_10,
	 releatedname_11,
     returndate_12,
     dealuser_13);
end;
/



CREATE or REPLACE PROCEDURE bill_HrmFinance_SelectLoan 
(
	resourceid_1	integer, 
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
    tmpamount1   number(10,3);
    tmpamount2   number(10,3);
begin
  select sum(amount) INTO tmpamount1 from FnaLoanLog 
  where resourceid= resourceid_1 and loantypeid = 1;
  
  select sum(amount) INTO tmpamount2 from FnaLoanLog
  where resourceid= resourceid_1 and loantypeid != 1;
  
  if    tmpamount1 is null then
         tmpamount1 :=0;
		 end if;
  if    tmpamount2 is null then
         tmpamount2 := 0;
		 end if;
  if tmpamount1 >= tmpamount2 then
		 tmpamount1 := tmpamount1-tmpamount2 ;
  else
     tmpamount1 :=0;
  end if;
	open thecursor for
	select tmpamount1 from dual; 
end;
/

update workflow_browserurl  
set browserurl ='/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype=''1''',
tablename= 'FnaBudgetfeeType',linkurl = '' where id = 22 
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6126,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6126,'实报总金额',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (6126,'实报总金额')
/

delete workflow_billfield where billid=7 and fieldname = 'currencyid'
/

delete workflow_billfield where billid=7 and fieldname = 'exchangerate'
/

delete workflow_billfield where billid=7 and fieldname = 'creditledgeid'
/

delete workflow_billfield where billid=7 and fieldname = 'creditremark'
/

update workflow_billfield set fieldlabel = 6126,dsporder=5,fielddbtype='number(10,3)' where billid=7 and fieldname = 'realamount'
/

update workflow_billfield set dsporder = 4 where billid=7 and fieldname = 'amount'
/

update workflow_billfield set dsporder = 6 where billid=7 and fieldname = 'accessory'
/

update workflow_billfield set dsporder = 7 , fieldhtmltype = '5' where billid=7 and fieldname = 'debitledgeid'
/

update workflow_billfield set dsporder = 8 where billid=7 and fieldname = 'relatedrequestid'
/

update workflow_billfield set dsporder = 9 where billid=7 and fieldname = 'debitremark'
/

update workflow_billfield set viewtype = '1' , dsporder = 34 , fieldname = 'relatedcrm' where billid=7 and fieldname = 'crmid'
/

update workflow_billfield set viewtype = '1' , dsporder = 35 , fieldname = 'relatedproject' where billid=7 and fieldname = 'projectid'
/

update workflow_billfield set viewtype = '1' , fieldlabel = 534 , dsporder = 36 where billid=7 and fieldname = 'feesum'
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'feetypeid',1462,'integer',3,22,31,1)
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'detailremark',85,'varchar2(250)',1,1,32,1)
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'accessory',2002,'integer',1,2,33,1)
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'realfeesum',6016,'number(10,2)',1,3,37,1)
/

update workflow_bill set operationpage='BillExpenseOperation.jsp' where id = 7
/


insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,1,'现金') 
/
insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,2,'支票') 
/
insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,3,'汇票') 
/
insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,4,'冲销借款') 
/
insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)values(74,1,5,'其它') 
/



update workflow_billfield set fieldname = 'description' where billid=13 and fieldname = 'remark'
/



/* 加入一个部门主管的角色 */

insert into HrmRoles (rolesmark,rolesname,docid) values ('部门主管','部门主管','')
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (68,23,'0')
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (69,23,'0')
/



alter table HrmUseDemand add
  demanddep integer null
/

alter table HrmScheduleDiff add
  salaryitem integer null
/

alter table HrmScheduleDiff drop
  column currencyid
/

alter table HrmScheduleDiff drop
  column docid
/

alter table HrmStatusHistory add
  ischangesalary integer default(0)
/

create table HrmScheduleMaintance
(id integer  not null,
 diffid integer null,
 resourceid integer null,
 startdate char(10) null,
 starttime char(8) null,
 enddate char(10) null,
 endtime char(8) null,
 memo varchar2(4000) null,
 createtype integer default(0),
 /*0、工作流维护，不能删除修改；1、维护页面建立，可以删除修改*/
 createrid integer null,
 createdate char(10))
/
create sequence HrmScheduleMaintance_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmScheduleMaintance_Trigger
before insert on HrmScheduleMaintance
for each row
begin
select HrmScheduleMaintance_id.nextval into :new.id from dual;
end ;
/

alter table HrmScheduleDiff
  add color varchar2(30) null
/


insert into HtmlLabelIndex (id,indexdesc) values (6130,'培训种类')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6130,'培训种类',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6130,'TrainType',8)
/


update SystemLogItem set lableid=6130,itemdesc='培训种类' where itemid = 66
/

update SystemLogItem set lableid=6129,itemdesc='培训资源' where itemid = 68
/

insert into HtmlLabelIndex (id,indexdesc) values (6131,'用工需求')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6131,'用工需求',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6131,'UseDemand',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6132,'招聘计划')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6132,'招聘计划',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6132,'CareerPlan',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6133,'招聘管理')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6133,'招聘管理',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6133,'CareerManage',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6134,'面试')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6134,'面试',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6134,'Interview',8)
/


CREATE or REPLACE PROCEDURE HrmInterview_Insert
	(
	 resourceid_1 	integer,
	 stepid_2 	integer,
	 date_3 	char,
	 time_4 	char,
	 address_5 	varchar2,
	 notice_6 	varchar2,
	 interviewer_8 	varchar2,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO HrmInterview 
	 ( resourceid,
	 stepid,
	 date_n,
	 time,
	 address,
	 notice,
	 interviewer)  
VALUES 
	(resourceid_1,
	 stepid_2,
	 date_3,
	 time_4,
	 address_5,
	 notice_6,
	 interviewer_8);
end;
/


insert into SystemLogItem (itemid,lableid,itemdesc) values(69,6131,'用工需求')
/

insert into SystemLogItem (itemid,lableid,itemdesc) values(70,6132,'招聘计划')
/

insert into HtmlLabelIndex (id,indexdesc) values (6135,'结束信息')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6135,'结束信息',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6135,'FinishInfo',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6136,'培训活动')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6136,'培训活动',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6136,'Train',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6137,'入职维护')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6137,'入职维护',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6137,'HrmInfoMaintenance',8)
/


CREATE or REPLACE PROCEDURE HrmUseDemand_Update
(
	jobtitle_1 integer,
	status_2 integer,
	demandnum_3 integer,
	demandkind_4 integer,
	leaseedulevel_5 integer,
	date_6 char,
	otherrequest_7 varchar2,
	id_8 integer,
	department_9 integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

as
begin
update HrmUseDemand set
 demandjobtitle = jobtitle_1,
 status = status_2,
 demandnum = demandnum_3,
 demandkind = demandkind_4,
 leastedulevel = leaseedulevel_5,
 demandregdate = date_6,
 otherrequest = otherrequest_7,
 demanddep = department_9
where
 id = id_8;
end;
/



CREATE or REPLACE PROCEDURE HrmUseDemand_Insert
	(demandjobtitle_1 	integer,
	 demandnum_2 	integer,
	 demandkind_3 	integer,
	 leastedulevel_4 	integer,
	 demandregdate_5 	char,
	 otherrequest_6 	varchar2,
	 refermandid_7 	integer,
	 referdate_8 	char,
	 createkind_9 	integer,
	 department_10 integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO HrmUseDemand
	 (demandjobtitle,
	 demandnum,
	 demandkind,
	 leastedulevel,
	 demandregdate,
	 otherrequest,
	 refermandid,
	 referdate,
	 createkind,
	 demanddep) 
VALUES 
	(demandjobtitle_1,
	 demandnum_2,
	 demandkind_3,
	 leastedulevel_4,
	 demandregdate_5,
	 otherrequest_6,
	 refermandid_7,
	 referdate_8,
	 createkind_9,
	 department_10);
end;
/

CREATE or REPLACE PROCEDURE HrmScheduleDiff_Insert 
 (diffname_1 	varchar2, 
  diffdesc_2 	varchar2, 
  difftype_3 	char, 
  difftime_4 	char, 
  mindifftime_5 	smallint, 
  workflowid_6 	integer, 
  salaryable_7 	char, 
  counttype_8 	char, 
  countnum_9 	integer,  
  salaryitem_11 	integer, 
  diffremark_12 	varchar2,
  color_13 varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
INSERT INTO HrmScheduleDiff 
( diffname, 
  diffdesc, 
  difftype, 
  difftime, 
  mindifftime, 
  workflowid, 
  salaryable, 
  counttype, 
  countnum,  
  salaryitem, 
  diffremark,
  color)  
VALUES 
( diffname_1, 
  diffdesc_2, 
  difftype_3, 
  difftime_4, 
  mindifftime_5, 
  workflowid_6, 
  salaryable_7, 
  counttype_8, 
  countnum_9,   
  salaryitem_11, 
  diffremark_12,
  color_13);
 open thecursor for 
select max(id) from HrmScheduleDiff ;
end;
/

CREATE or REPLACE PROCEDURE HrmScheduleDiff_Update 
 (id_1 	integer, 
  diffname_2 	varchar2, 
  diffdesc_3 	varchar2, 
  difftype_4 	char, 
  difftime_5 	char, 
  mindifftime_6 	smallint, 
  workflowid_7 	integer, 
  salaryable_8 	char, 
  counttype_9 	char, 
  countnum_1      varchar2, 
  salaryitem_12 	integer, 
  diffremark_13 	varchar2, 
  color_14 varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
  countnum_10 number(10,3);
  begin 
  if countnum_1 <>'' then
   countnum_10 := to_number(countnum_1); 
  else
    countnum_10 := 0 ;
	end if;	
UPDATE HrmScheduleDiff  SET  
  diffname	 = diffname_2, 
  diffdesc	 = diffdesc_3, 
  difftype	 = difftype_4, 
  difftime	 = difftime_5, 
  mindifftime	 = mindifftime_6, 
  workflowid	 = workflowid_7, 
  salaryable	 = salaryable_8, 
  counttype	 = counttype_9, 
  countnum	 = countnum_10, 
  salaryitem	 = salaryitem_12, 
  diffremark	 = diffremark_13,
  color = color_14
WHERE 
( id	 = id_1)  ;
end;
/

CREATE or REPLACE PROCEDURE HrmScheduleDiff_Select_All 
 ( 	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 open thecursor for
 select id, diffname from HrmScheduleDiff 
 order by id ;
end;
/


CREATE or REPLACE PROCEDURE HrmScheduleDiff_Select_ByID 
(
 id integer , 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
 open thecursor for
select * from HrmScheduleDiff 
where 
 id = (id) ;
end;
/

CREATE or REPLACE PROCEDURE HrmResource_Redeploy 
(id_1 integer, 
 changedate_2 char, 
 changereason_4 char, 
 oldjobtitleid_7 integer, 
 oldjoblevel_8 integer, 
 newjobtitleid_9 integer, 
 newjoblevel_10 integer, 
 infoman_6 varchar2, 
 type_n_11 integer, 
 ischangesalary_12 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
INSERT INTO HrmStatusHistory 
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
(id_1, 
 changedate_2, 
 changereason_4, 
 oldjobtitleid_7, 
 oldjoblevel_8, 
 newjobtitleid_9, 
 newjoblevel_10, 
 infoman_6, 
 type_n_11,
 ischangesalary_12);
end;
/

 
CREATE or REPLACE PROCEDURE HrmResource_UpdateByDep
(id_1 integer,
 subcompanyid1_2 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
update HrmResource set
 subcompanyid1 = subcompanyid1_2
where
 departmentid = id_1 ;
end;
/


CREATE or REPLACE PROCEDURE HrmScheduleMain_Update
	(id_1 	integer,
	 diffid_2 	integer,
	 resourceid_3 	integer,
	 startdate_4 	char,
	 starttime_5 	char,
	 enddate_6 	char,
	 endtime_7 	char,
	 memo_8 	varchar2,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
UPDATE HrmScheduleMaintance SET  
         diffid	 = diffid_2,
	 resourceid	 = resourceid_3,
	 startdate	 = startdate_4,
	 starttime	 = starttime_5,
	 enddate	 = enddate_6,
	 endtime	 = endtime_7,
	 memo	         = memo_8 

WHERE 
	( id	 = id_1);
end;
/


CREATE or REPLACE PROCEDURE HrmScheduleMain_Insert
	(diffid_1 	integer,
	 resourceid_2 	integer,
	 startdate_3 	char,
	 starttime_4 	char,
	 enddate_5 	char,
	 endtime_6 	char,
	 memo_7 	varchar2,
	 createtype_8 	integer,
	 createrid_9 	integer,
	 createdate_10 	char,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 

AS
begin 
INSERT INTO HrmScheduleMaintance 
	 ( diffid,
	 resourceid,
	 startdate,
	 starttime,
	 enddate,
	 endtime,
	 memo,
	 createtype,
	 createrid,
	 createdate) 
 
VALUES 
	( diffid_1,
	 resourceid_2,
	 startdate_3,
	 starttime_4,
	 enddate_5,
	 endtime_6,
	 memo_7,
	 createtype_8,
	 createrid_9,
	 createdate_10);
end;
/


CREATE or REPLACE PROCEDURE HrmScheduleMain_Delete
	(id_1 	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
delete from HrmScheduleMaintance 
WHERE 
	( id	 = id_1);
end;
/


insert into SystemLogItem (itemid,lableid,itemdesc) values(79,6138,'考勤维护')
/

insert into HtmlLabelIndex (id,indexdesc) values (6138,'考勤维护')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6138,'考勤维护',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6138,'ScheduleMaintance',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6139,'考勤种类')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6139,'考勤种类',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6139,'ScheduleDiffType',8)
/


update SystemLogItem set lableid=6139,itemdesc='考勤种类' where itemid = 17
/

CREATE or REPLACE PROCEDURE HrmSchedule_Select_DepTotal
 (id_1 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin 
open thecursor for
select totaltime from HrmSchedule 
 where 
   scheduletype ='1' 
 and 
   relatedid = id_1;
end;
/

insert into HtmlLabelIndex (id,indexdesc) values (6140,'人力资源考勤')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6140,'人力资源考勤',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6140,'HrmResourceSchedule',8)
/
