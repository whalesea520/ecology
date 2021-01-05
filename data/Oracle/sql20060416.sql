INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 134,386,'integer','/systeminfo/BrowserMain.jsp?url=/fna/budget/BudgetBrowser.jsp','FnaBudgetInfo','remark','id','/fna/budget/FnaBudgetView.jsp?isrequest=1&fnabudgetinfoid=')
/
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(154,18432,'bill_FnaBudget','','','','','','BillBudgetOperation.jsp')
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (154,'budgetdetail',18433,'integer',3,134,0,0)
/
CREATE TABLE bill_FnaBudget (
    id integer ,
    budgetdetail integer,
    requestid integer)
/
create sequence bill_FnaBudget_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger bill_FnaBudget_Trigger
before insert on bill_FnaBudget
for each row
begin
select bill_FnaBudget_id.nextval into :new.id from dual;
end;
/
delete from  HtmlLabelIndex where id=18436
/
delete from  HtmlLabelInfo where indexId=18436
/




INSERT INTO HtmlLabelIndex values(18436,'审批设置')
/
INSERT INTO HtmlLabelInfo VALUES(18436,'审批设置',7)
/
INSERT INTO HtmlLabelInfo VALUES(18436,'audit setting',8)
/

call MMConfig_U_ByInfoInsert (165,3)
/
call MMInfo_Insert (470,18436,'','/fna/budget/AuditSetting.jsp','mainFrame',165,2,3,0,'',0,'',0,'','',0,'','',6)
/

create table BudgetAuditMapping
(subcompanyid integer ,
 workflowid integer)
/

create table FnaExpenseInfo 
	(id integer ,
	organizationid integer,
	organizationtype integer,
	occurdate char(10),
	amount number(15,3),
	subject integer,
	status integer,
	type integer,
	relatedprj integer,
	relatedcrm integer,
	debitremark varchar2(50),
	description varchar2(250),
	requestid integer
	)
/
create sequence FnaExpenseInfo_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaExpenseInfo_Trigger
before insert on FnaExpenseInfo
for each row
begin
select FnaExpenseInfo_id.nextval into :new.id from dual;
end;
/

INSERT INTO HtmlLabelIndex values(18432,'预算审批流转单')
/
INSERT INTO HtmlLabelIndex values(18433,'预算明细表')
/
INSERT INTO HtmlLabelInfo VALUES(18432,'预算审批流转单',7)
/
INSERT INTO HtmlLabelInfo VALUES(18433,'预算明细表',7)
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(157,18520,'Bill_FnaLoanApply','AddFnaLoanApply.jsp','ManageFnaLoanApply.jsp','ViewFnaLoanApply.jsp','Bill_FnaLoanApplyDetail','','FnaLoanApplyOperation.jsp')
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'applicant',368,'integer',3,1,0,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'deptid',17895,'integer',3,4,1,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'reason',791,'varchar2(200)',2,0,2,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'total',1043,'number(15,3)',1,3,3,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'returndate',18649,'char(10)',3,2,5,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'relatedprj',782,'integer',3,8,14,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'relatedcrm',783,'integer',3,7,15,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'relateddoc',857,'integer',3,9,6,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'relatedwf',1044,'integer',3,16,7,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'organizationid',18650,'integer',3,1,9,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'description',85,'varchar2(50)',1,1,16,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'amount',534,'number(15,3)',1,3,17,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'debitremark',874,'varchar2(50)',1,1,8,0)
/

CREATE TABLE Bill_FnaLoanApply (
    id integer ,
    applicant integer,
    deptid integer,
    reason varchar2(200),
    total number(15,3),
    returndate char(10),
    relateddoc integer,
    relatedwf integer,
    debitremark varchar2(50),
    requestid integer)
/
create sequence Bill_FnaLoanApply_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_FnaLoanApply_Trigger
before insert on Bill_FnaLoanApply
for each row
begin
select Bill_FnaLoanApply_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Bill_FnaLoanApplyDetail (
    id integer,
    organizationid integer,
    relatedprj integer,
    relatedcrm integer,
    description varchar2(50),
    amount number(15,3))
/

alter table bill_fnaloanapplydetail add organizationtype integer
/

INSERT INTO HtmlLabelIndex values(18520,'借款申请单')
/
INSERT INTO HtmlLabelInfo VALUES(18520,'借款申请单',7)
/
INSERT INTO HtmlLabelIndex values(18652,'个人预算')
/
INSERT INTO HtmlLabelIndex values(18653,'部门预算')
/
INSERT INTO HtmlLabelIndex values(18649,'还款日期')
/
INSERT INTO HtmlLabelIndex values(18650,'借款单位')
/
INSERT INTO HtmlLabelIndex values(18648,'预算期间')
/
INSERT INTO HtmlLabelIndex values(18654,'分部预算')
/
INSERT INTO HtmlLabelInfo VALUES(18648,'预算期间',7)
/
INSERT INTO HtmlLabelInfo VALUES(18649,'还款日期',7)
/
INSERT INTO HtmlLabelInfo VALUES(18650,'借款单位',7)
/
INSERT INTO HtmlLabelInfo VALUES(18652,'个人预算',7)
/
INSERT INTO HtmlLabelInfo VALUES(18653,'部门预算',7)
/
INSERT INTO HtmlLabelInfo VALUES(18654,'分部预算',7)
/




INSERT INTO HtmlLabelIndex values(17895,'申请人部门')
/
INSERT INTO HtmlLabelInfo VALUES(17895,'申请人部门',7)
/


INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(156,18591,'Bill_FnaPayApply','AddFnaPayApply.jsp','ManageFnaPayApply.jsp','ViewFnaPayApply.jsp','Bill_FnaPayApplyDetail','','FnaPayApplyOperation.jsp')
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'applicant',368,'integer',3,1,0,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'deptid',17895,'integer',3,4,1,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'reason',791,'varchar2(200)',2,0,2,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'budgetperiod',15135,'char(10)',3,2,9,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'relatedprj',782,'integer',3,8,15,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'relatedcrm',783,'integer',3,7,16,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'relateddoc',857,'integer',3,9,4,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'relatedwf',1044,'integer',3,16,5,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'total',15134,'number(15,3)',1,3,3,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'organizationid',18667,'integer',3,1,7,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'subject',585,'integer',3,22,8,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'description',85,'varchar2(50)',1,1,17,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'applyamount',856,'number(15,3)',1,3,18,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'hrmremain',18652,'number(15,3)',1,3,12,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'deptremain',18653,'number(15,3)',1,3,13,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'subcomremain',18654,'number(15,3)',1,3,14,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'amount',18669,'number(15,3)',1,3,19,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'debitremark',874,'varchar2(50)',1,1,6,0)
/

CREATE TABLE Bill_FnaPayApply
(
    id integer ,
    applicant integer,
    deptid integer,
    reason varchar2(200),
    total number(15,3),
    relateddoc integer,
    relatedwf integer,
    debitremark varchar2(50),
    requestid integer)
/
create sequence Bill_FnaPayApply_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger B_FPApply_Trigger
before insert on Bill_FnaPayApply
for each row
begin
select Bill_FnaPayApply_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Bill_FnaPayApplyDetail (
    id integer,
    organizationid integer,
    subject integer,
    budgetperiod char(10),
    hrmremain number(15,3),
    deptremain number(15,3),
    subcomremain number(15,3),
    relatedprj integer,
    relatedcrm integer,
    description varchar2(50),
    applyamount number(15,3),
    amount number(15,3))
/

alter table bill_FnaPayApplyDetail add organizationtype integer
/
INSERT INTO HtmlLabelIndex values(18591,'付款申请单')
/
INSERT INTO HtmlLabelInfo VALUES(18591,'付款申请单',7)
/
INSERT INTO HtmlLabelIndex values(18669,'实付金额')
/
INSERT INTO HtmlLabelIndex values(18667,'付款单位')
/
INSERT INTO HtmlLabelInfo VALUES(18667,'付款单位',7)
/
INSERT INTO HtmlLabelInfo VALUES(18669,'实付金额',7)
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(158,18670,'Bill_FnaWipeApply','AddFnaWipeApply.jsp','ManageFnaWipeApply.jsp','ViewFnaWipeApply.jsp','Bill_FnaWipeApplyDetail','','FnaWipeApplyOperation.jsp')
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'applicant',368,'integer',3,1,0,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'deptid',17895,'integer',3,4,1,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'wipetype',6014,'integer',5,0,2,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'reason',791,'varchar2(200)',2,0,3,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'total',18671,'number(15,3)',1,3,4,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'relateddoc',857,'integer',3,9,5,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'relatedwf',1044,'integer',3,16,6,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'organizationid',16961,'integer',3,1,8,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'subject',585,'integer',3,22,9,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'budgetperiod',790,'char(10)',3,2,10,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'attachcount',2002,'integer',1,2,11,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'hrmremain',18652,'number(15,3)',1,3,12,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'deptremain',18653,'number(15,3)',1,3,13,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'subcomremain',18654,'number(15,3)',1,3,14,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'loanbalance',18672,'number(15,3)',1,3,15,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'relatedprj',782,'integer',3,8,16,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'relatedcrm',783,'integer',3,7,17,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'description',85,'varchar2(50)',1,1,18,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'applyamount',18673,'number(15,3)',1,3,19,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'amount',6016,'number(15,3)',1,3,20,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'debitremark',874,'varchar2(50)',1,1,7,0)
/


CREATE TABLE Bill_FnaWipeApply (
    id integer,
    applicant integer,
    deptid integer,
    wipetype integer,
    reason varchar2(200),
    total number(15,3),
    relateddoc integer,
    relatedwf integer,
    debitremark varchar2(50),
    requestid integer)
/
create sequence Bill_FnaWipeApply_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_FWApply_Trigger
before insert on Bill_FnaWipeApply
for each row
begin
select Bill_FnaWipeApply_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Bill_FnaWipeApplyDetail (
    id integer,
    organizationid integer,
    subject integer,
    budgetperiod char(10),
    attachcount integer,
    hrmremain number(15,3),
    deptremain number(15,3),
    subcomremain number(15,3),
    loanbalance number(15,3),
    relatedprj integer,
    relatedcrm integer,
    description varchar2(50),
    applyamount number(15,3),
    amount number(15,3))
/
alter table bill_fnawipeapplydetail add organizationtype integer
/

INSERT INTO HtmlLabelIndex values(18673,'申报金额')
/
INSERT INTO HtmlLabelIndex values(18670,'报销申请单')
/
INSERT INTO HtmlLabelIndex values(18671,'报销金额')
/
INSERT INTO HtmlLabelIndex values(18672,'借款余额')
/
INSERT INTO HtmlLabelInfo VALUES(18670,'报销申请单',7)
/
INSERT INTO HtmlLabelInfo VALUES(18671,'报销金额',7)
/
INSERT INTO HtmlLabelInfo VALUES(18672,'借款余额',7)
/
INSERT INTO HtmlLabelInfo VALUES(18673,'申报金额',7)
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(159,18747,'Bill_FnaBudgetChgApply','AddFnaBudgetChgApply.jsp','ManageFnaBudgetChgApply.jsp','ViewFnaBudgetChgApply.jsp','Bill_FnaBudgetChgApplyDetail','','FnaBudgetChgApplyOperation.jsp')
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'applicant',368,'integer',3,1,0,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'deptid',17895,'integer',3,4,1,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'applydate',855,'char(10)',3,2,2,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'reason',791,'varchar2(200)',2,0,3,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'organizationid',18748,'integer',3,1,4,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'subject',585,'integer',3,22,5,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'budgetperiod',18648,'char(10)',3,2,6,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'description',85,'varchar2(50)',1,1,10,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'relatedprj',782,'integer',3,8,8,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'relatedcrm',783,'integer',3,7,9,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'oldamount',18749,'number(15,3)',1,3,11,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'applyamount',18750,'number(15,3)',1,3,12,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'amount',17773,'number(15,3)',1,3,13,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'changeamount',18751,'number(15,3)',1,3,14,1)
/

CREATE TABLE Bill_FnaBudgetChgApply (
    id integer ,
    applicant integer,
    deptid integer,
    applydate char(10),
    reason varchar2(200),
    requestid integer)
/
create sequence Bill_FBgetApply_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_FBgetApply_Tri
before insert on Bill_FnaBudgetChgApply
for each row
begin
select Bill_FBgetApply_id.nextval into :new.id from dual;
end;
/


CREATE TABLE Bill_FnaBudgetChgApplyDetail (
    id integer,
    organizationid integer,
    subject integer,
    budgetperiod char(10),
    relatedprj integer,
    relatedcrm integer,
    description varchar2(50),
    oldamount number(15,3),
    applyamount number(15,3),
    amount number(15,3),
    changeamount number(15,3))
/

alter table Bill_FnaBudgetChgApplyDetail add organizationtype integer
/
INSERT INTO HtmlLabelIndex values(18747,'预算变更申请单')
/
INSERT INTO HtmlLabelIndex values(18748,'预算单位')
/
INSERT INTO HtmlLabelIndex values(18749,'原预算')
/
INSERT INTO HtmlLabelIndex values(18750,'新预算')
/
INSERT INTO HtmlLabelIndex values(18751,'变更差额')
/
INSERT INTO HtmlLabelInfo VALUES(18747,'预算变更申请单',7)
/
INSERT INTO HtmlLabelInfo VALUES(18748,'预算单位',7)
/
INSERT INTO HtmlLabelInfo VALUES(18749,'原预算',7)
/
INSERT INTO HtmlLabelInfo VALUES(18750,'新预算',7)
/
INSERT INTO HtmlLabelInfo VALUES(18751,'变更差额',7)
/

INSERT INTO HtmlLabelIndex values(17773,'审批预算')
/
INSERT INTO HtmlLabelInfo VALUES(17773,'审批预算',7)
/

CREATE TABLE FnaLoanInfo (
    id integer ,
    loantype integer,
    organizationid integer,
    organizationtype integer,
    occurdate char(10),
    amount number(15,3),
    debitremark varchar2(60),
    remark varchar2(4000),
    requestid integer,
    relatedcrm integer,
    relatedprj integer,
    processorid integer)
/
create sequence FnaLoanInfo_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaLoanInfo_Tri
before insert on FnaLoanInfo
for each row
begin
select FnaLoanInfo_id.nextval into :new.id from dual;
end;
/

INSERT INTO HtmlLabelIndex values(18769,'审批中费用')
/
INSERT INTO HtmlLabelIndex values(18768,'可用预算')
/
INSERT INTO HtmlLabelInfo VALUES(18768,'可用预算',7)
/
INSERT INTO HtmlLabelInfo VALUES(18768,'available budget',8)
/
INSERT INTO HtmlLabelInfo VALUES(18769,'审批中费用',7)
/
INSERT INTO HtmlLabelInfo VALUES(18769,'pending expense',8)
/
INSERT INTO HtmlLabelIndex values(18503,'已发生费用')
/
INSERT INTO HtmlLabelInfo VALUES(18503,'已发生费用',7)
/
INSERT INTO HtmlLabelInfo VALUES(18503,'',8)
/

INSERT INTO HtmlLabelIndex values(18797,'销帐')
/
INSERT INTO HtmlLabelInfo VALUES(18797,'销帐',7)
/
INSERT INTO HtmlLabelInfo VALUES(18797,'writeoff',8)
/
INSERT INTO HtmlLabelIndex values(18798,'帐务往来')
/
INSERT INTO HtmlLabelInfo VALUES(18798,'帐务往来',7)
/
INSERT INTO HtmlLabelInfo VALUES(18798,'account log',8)
/
INSERT INTO HtmlLabelIndex values(18801,'欠款累计')
/
INSERT INTO HtmlLabelInfo VALUES(18801,'欠款累计',7)
/
INSERT INTO HtmlLabelInfo VALUES(18801,'loan amount',8)
/

create or replace procedure importexpense
as
	relatedcrm_1 integer;
	relatedprj_1 integer;
	organizationid_1 integer;
	occurdate_1 char(10);
	amount_1 number(15,3);
	subject_1 integer;
	requestid_1 integer;
	description_1 varchar2(250);

begin
	FOR all_cursor in( 
	select feetypeid,resourceid,crmid,projectid,amount,occurdate,releatedid,description from FnaAccountLog where iscontractid=0 or iscontractid is null)
loop
	subject_1 := all_cursor.feetypeid;
	organizationid_1 := all_cursor.resourceid;
	relatedcrm_1 := all_cursor.crmid;
	relatedprj_1 := all_cursor.projectid;
	amount_1 := all_cursor.amount;
	occurdate_1 := all_cursor.occurdate;
	requestid_1 := all_cursor.releatedid;
	description_1 := all_cursor. description;
	insert into fnaexpenseinfo(subject,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,status,type,description) values(subject_1,3,organizationid_1,relatedcrm_1,relatedprj_1,amount_1,occurdate_1,requestid_1,1,2,description_1);
end loop;
end;
/

create or replace procedure importloan
as
	relatedcrm_1 integer;
	relatedprj_1 integer;
	organizationid_1 integer;
	occurdate_1 char(10);
	amount_1 number(15,3);
	subject_1 integer;
	requestid_1 integer;
	description_1 varchar2(250);
	loantype_1 integer;
	debitremark_1 varchar2(60);
	processorid_1 integer;
begin
	FOR all_cursor in(
	select loantypeid,resourceid,crmid,projectid,amount,occurdate,releatedid,description,credenceno,dealuser from FnaLoanLog)
loop
	loantype_1 := all_cursor.loantypeid;
	organizationid_1 := all_cursor.resourceid;
	relatedcrm_1 := all_cursor.crmid;
	relatedprj_1 := all_cursor.projectid;
	amount_1 := all_cursor.amount;
	occurdate_1 := all_cursor.occurdate;
	requestid_1 := all_cursor.releatedid;
	description_1 := all_cursor.description;
	debitremark_1 := all_cursor.credenceno;
	processorid_1 := all_cursor.dealuser;

	if(loantype_1!=1) then
		amount_1 := -1*amount_1;
	end if;
	insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) values(loantype_1,3,organizationid_1,relatedcrm_1,relatedprj_1,amount_1,occurdate_1,requestid_1,description_1,debitremark_1,processorid_1);
end loop;
end;
/

create or replace TRIGGER Tri_importexpense  after INSERT ON fnaaccountlog
FOR each row
declare
 relatedcrm_1 integer;
 relatedprj_1 integer;
 organizationid_1 integer;
 occurdate_1 char(10);
 amount_1 number(15,3);
 subject_1 integer;
 requestid_1 integer;
 iscontract_1 integer;
 description_1 varchar2(250);
begin
iscontract_1 := :new.iscontractid;
if(iscontract_1 =0 or iscontract_1 is null)
then
subject_1  := :new.feetypeid;
organizationid_1  := :new.resourceid;
relatedcrm_1  := :new.crmid;
relatedprj_1  := :new.projectid;
occurdate_1  := :new.occurdate;
amount_1  := :new.amount;
requestid_1  := :new.releatedid;
insert into fnaexpenseinfo(subject,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,status,type,description) values(subject_1,3,organizationid_1,relatedcrm_1,relatedprj_1,amount_1,occurdate_1,requestid_1,1,2,description_1);
end if;
end;
/

create or replace TRIGGER Tri_importloan after INSERT ON fnaloanlog
FOR each row
declare
	relatedcrm_1 integer;
	relatedprj_1 integer;
	organizationid_1 integer;
	occurdate_1 char(10);
	amount_1 number(15,3);
	subject_1 integer;
	requestid_1 integer;
	description_1 varchar2(250);
	loantype_1 integer;
	debitremark_1 varchar2(60);
	processorid_1 integer;
begin
loantype_1 := :new.loantypeid;
organizationid_1 := :new.resourceid;
relatedcrm_1 := :new.crmid;
relatedprj_1 := :new.projectid;
amount_1 := :new.amount;
occurdate_1 := :new.occurdate;
requestid_1 := :new.releatedid;
description_1 := :new.description;
debitremark_1 := :new.credenceno;
processorid_1 := :new.dealuser;
if(loantype_1=1) then
insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) values(loantype_1,3,organizationid_1,relatedcrm_1,relatedprj_1,amount_1,occurdate_1,requestid_1,description_1,debitremark_1,processorid_1);
end if;
end;
/

call importexpense()
/
call importloan()
/
create or replace procedure Bill_SelectList_Insert
	(billid_1 integer,
	fieldname_2 varchar2,
	selectvalue_3 integer,
	selectname_4 varchar2,
	listorder_5 integer,
	isdefault_6 char)
as
	fieldid integer;
begin
	select  id into  fieldid from workflow_billfield where billid = billid_1 and fieldname = fieldname_2;
	insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname,listorder,isdefault) values(fieldid,1,selectvalue_3,selectname_4,listorder_5,isdefault_6);
end;
/

call Bill_SelectList_Insert (158,'wipetype',1,'现金',0,'y')
/
call Bill_SelectList_Insert (158,'wipetype',2,'支票',0,'n')
/
call Bill_SelectList_Insert (158,'wipetype',3,'汇票',0,'n')
/
call Bill_SelectList_Insert (158,'wipetype',4,'冲销借款',0,'n')
/
call Bill_SelectList_Insert (158,'wipetype',5,'其它',0,'n')
/ 



