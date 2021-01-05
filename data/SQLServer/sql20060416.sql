INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 134,386,'int','/systeminfo/BrowserMain.jsp?url=/fna/budget/BudgetBrowser.jsp','FnaBudgetInfo','remark','id','/fna/budget/FnaBudgetView.jsp?isrequest=1&fnabudgetinfoid=')
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(154,18432,'bill_FnaBudget','','','','','','BillBudgetOperation.jsp')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (154,'budgetdetail',18433,'int',3,134,0,0)
GO

CREATE TABLE bill_FnaBudget (
    id int IDENTITY,
    budgetdetail int,
    requestid int)
GO

delete from  HtmlLabelIndex where id=18436
GO
delete from  HtmlLabelInfo where indexId=18436
GO
INSERT INTO HtmlLabelIndex values(18436,'审批设置')
GO
INSERT INTO HtmlLabelInfo VALUES(18436,'审批设置',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18436,'audit setting',8)
GO

EXECUTE MMConfig_U_ByInfoInsert 165,3
GO
EXECUTE MMInfo_Insert 470,18436,'','/fna/budget/AuditSetting.jsp','mainFrame',165,2,3,0,'',0,'',0,'','',0,'','',6
GO

create table BudgetAuditMapping (subcompanyid int ,
                                   workflowid int)

GO

create table FnaExpenseInfo (id int IDENTITY,
                               organizationid int,
                               organizationtype int,
                               occurdate char(10),
                               amount decimal(15,3),
                               subject int,
                               status int,
                               type int,
                               relatedprj int,
                               relatedcrm int,
                               debitremark varchar(50),
                               description varchar(250),
                               requestid int
                               )

INSERT INTO HtmlLabelIndex values(18432,'预算审批流转单')
GO
INSERT INTO HtmlLabelIndex values(18433,'预算明细表')
GO
INSERT INTO HtmlLabelInfo VALUES(18432,'预算审批流转单',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18433,'预算明细表',7)
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(157,18520,'Bill_FnaLoanApply','AddFnaLoanApply.jsp','ManageFnaLoanApply.jsp','ViewFnaLoanApply.jsp','Bill_FnaLoanApplyDetail','','FnaLoanApplyOperation.jsp')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'applicant',368,'int',3,1,0,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'deptid',17895,'int',3,4,1,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'reason',791,'varchar(200)',2,0,2,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'total',1043,'decimal(15,3)',1,3,3,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'returndate',18649,'char(10)',3,2,5,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'relatedprj',782,'int',3,8,14,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'relatedcrm',783,'int',3,7,15,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'relateddoc',857,'int',3,9,6,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'relatedwf',1044,'int',3,16,7,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'organizationid',18650,'int',3,1,9,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'description',85,'varchar(50)',1,1,16,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'amount',534,'decimal(15,3)',1,3,17,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'debitremark',874,'varchar(50)',1,1,8,0)
GO


CREATE TABLE Bill_FnaLoanApply (
    id int IDENTITY,
    applicant int,
    deptid int,
    reason varchar(200),
    total decimal(15,3),
    returndate char(10),
    relateddoc int,
    relatedwf int,
    debitremark varchar(50),
    requestid int)
GO
CREATE TABLE Bill_FnaLoanApplyDetail (
    id int,
    organizationid int,
    relatedprj int,
    relatedcrm int,
    description varchar(50),
    amount decimal(15,3))
GO

alter table bill_fnaloanapplydetail add organizationtype int
GO


INSERT INTO HtmlLabelIndex values(18520,'借款申请单')
GO
INSERT INTO HtmlLabelInfo VALUES(18520,'借款申请单',7)
GO
INSERT INTO HtmlLabelIndex values(18652,'个人预算')
GO
INSERT INTO HtmlLabelIndex values(18653,'部门预算')
GO
INSERT INTO HtmlLabelIndex values(18649,'还款日期')
GO
INSERT INTO HtmlLabelIndex values(18650,'借款单位')
GO
INSERT INTO HtmlLabelIndex values(18648,'预算期间')
GO
INSERT INTO HtmlLabelIndex values(18654,'分部预算')
GO
INSERT INTO HtmlLabelInfo VALUES(18648,'预算期间',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18649,'还款日期',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18650,'借款单位',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18652,'个人预算',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18653,'部门预算',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18654,'分部预算',7)
GO




INSERT INTO HtmlLabelIndex values(17895,'申请人部门')
GO
INSERT INTO HtmlLabelInfo VALUES(17895,'申请人部门',7)
GO


INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(156,18591,'Bill_FnaPayApply','AddFnaPayApply.jsp','ManageFnaPayApply.jsp','ViewFnaPayApply.jsp','Bill_FnaPayApplyDetail','','FnaPayApplyOperation.jsp')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'applicant',368,'int',3,1,0,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'deptid',17895,'int',3,4,1,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'reason',791,'varchar(200)',2,0,2,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'budgetperiod',15135,'char(10)',3,2,9,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'relatedprj',782,'int',3,8,15,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'relatedcrm',783,'int',3,7,16,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'relateddoc',857,'int',3,9,4,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'relatedwf',1044,'int',3,16,5,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'total',15134,'decimal(15,3)',1,3,3,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'organizationid',18667,'int',3,1,7,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'subject',585,'int',3,22,8,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'description',85,'varchar(50)',1,1,17,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'applyamount',856,'decimal(15,3)',1,3,18,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'hrmremain',18652,'decimal(15,3)',1,3,12,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'deptremain',18653,'decimal(15,3)',1,3,13,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'subcomremain',18654,'decimal(15,3)',1,3,14,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'amount',18669,'decimal(15,3)',1,3,19,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'debitremark',874,'varchar(50)',1,1,6,0)
GO

CREATE TABLE Bill_FnaPayApply (
    id int IDENTITY,
    applicant int,
    deptid int,
    reason varchar(200),
    total decimal(15,3),
    relateddoc int,
    relatedwf int,
    debitremark varchar(50),
    requestid int)
GO
CREATE TABLE Bill_FnaPayApplyDetail (
    id int,
    organizationid int,
    subject int,
    budgetperiod char(10),
    hrmremain decimal(15,3),
    deptremain decimal(15,3),
    subcomremain decimal(15,3),
    relatedprj int,
    relatedcrm int,
    description varchar(50),
    applyamount decimal(15,3),
    amount decimal(15,3))
GO

alter table bill_FnaPayApplyDetail add organizationtype int
GO
INSERT INTO HtmlLabelIndex values(18591,'付款申请单')
GO
INSERT INTO HtmlLabelInfo VALUES(18591,'付款申请单',7)
GO
INSERT INTO HtmlLabelIndex values(18669,'实付金额')
GO
INSERT INTO HtmlLabelIndex values(18667,'付款单位')
GO
INSERT INTO HtmlLabelInfo VALUES(18667,'付款单位',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18669,'实付金额',7)
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(158,18670,'Bill_FnaWipeApply','AddFnaWipeApply.jsp','ManageFnaWipeApply.jsp','ViewFnaWipeApply.jsp','Bill_FnaWipeApplyDetail','','FnaWipeApplyOperation.jsp')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'applicant',368,'int',3,1,0,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'deptid',17895,'int',3,4,1,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'wipetype',6014,'int',5,0,2,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'reason',791,'varchar(200)',2,0,3,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'total',18671,'decimal(15,3)',1,3,4,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'relateddoc',857,'int',3,9,5,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'relatedwf',1044,'int',3,16,6,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'organizationid',16961,'int',3,1,8,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'subject',585,'int',3,22,9,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'budgetperiod',790,'char(10)',3,2,10,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'attachcount',2002,'int',1,2,11,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'hrmremain',18652,'decimal(15,3)',1,3,12,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'deptremain',18653,'decimal(15,3)',1,3,13,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'subcomremain',18654,'decimal(15,3)',1,3,14,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'loanbalance',18672,'decimal(15,3)',1,3,15,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'relatedprj',782,'int',3,8,16,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'relatedcrm',783,'int',3,7,17,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'description',85,'varchar(50)',1,1,18,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'applyamount',18673,'decimal(15,3)',1,3,19,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'amount',6016,'decimal(15,3)',1,3,20,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'debitremark',874,'varchar(50)',1,1,7,0)
GO

CREATE TABLE Bill_FnaWipeApply (
    id int IDENTITY,
    applicant int,
    deptid int,
    wipetype int,
    reason varchar(200),
    total decimal(15,3),
    relateddoc int,
    relatedwf int,
    debitremark varchar(50),
    requestid int)
GO
CREATE TABLE Bill_FnaWipeApplyDetail (
    id int,
    organizationid int,
    subject int,
    budgetperiod char(10),
    attachcount int,
    hrmremain decimal(15,3),
    deptremain decimal(15,3),
    subcomremain decimal(15,3),
    loanbalance decimal(15,3),
    relatedprj int,
    relatedcrm int,
    description varchar(50),
    applyamount decimal(15,3),
    amount decimal(15,3))
GO

alter table bill_fnawipeapplydetail add organizationtype int
GO


INSERT INTO HtmlLabelIndex values(18673,'申报金额')
GO
INSERT INTO HtmlLabelIndex values(18670,'报销申请单')
GO
INSERT INTO HtmlLabelIndex values(18671,'报销金额')
GO
INSERT INTO HtmlLabelIndex values(18672,'借款余额')
GO
INSERT INTO HtmlLabelInfo VALUES(18670,'报销申请单',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18671,'报销金额',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18672,'借款余额',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18673,'申报金额',7)
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(159,18747,'Bill_FnaBudgetChgApply','AddFnaBudgetChgApply.jsp','ManageFnaBudgetChgApply.jsp','ViewFnaBudgetChgApply.jsp','Bill_FnaBudgetChgApplyDetail','','FnaBudgetChgApplyOperation.jsp')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'applicant',368,'int',3,1,0,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'deptid',17895,'int',3,4,1,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'applydate',855,'char(10)',3,2,2,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'reason',791,'varchar(200)',2,0,3,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'organizationid',18748,'int',3,1,4,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'subject',585,'int',3,22,5,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'budgetperiod',18648,'char(10)',3,2,6,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'description',85,'varchar(50)',1,1,10,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'relatedprj',782,'int',3,8,8,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'relatedcrm',783,'int',3,7,9,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'oldamount',18749,'decimal(15,3)',1,3,11,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'applyamount',18750,'decimal(15,3)',1,3,12,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'amount',17773,'decimal(15,3)',1,3,13,1)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'changeamount',18751,'decimal(15,3)',1,3,14,1)
GO
CREATE TABLE Bill_FnaBudgetChgApply (
    id int IDENTITY,
    applicant int,
    deptid int,
    applydate char(10),
    reason varchar(200),
    requestid int)
GO
CREATE TABLE Bill_FnaBudgetChgApplyDetail (
    id int,
    organizationid int,
    subject int,
    budgetperiod char(10),
    relatedprj int,
    relatedcrm int,
    description varchar(50),
    oldamount decimal(15,3),
    applyamount decimal(15,3),
    amount decimal(15,3),
    changeamount decimal(15,3))
GO


alter table Bill_FnaBudgetChgApplyDetail add organizationtype int
GO
INSERT INTO HtmlLabelIndex values(18747,'预算变更申请单')
GO
INSERT INTO HtmlLabelIndex values(18748,'预算单位')
GO
INSERT INTO HtmlLabelIndex values(18749,'原预算')
GO
INSERT INTO HtmlLabelIndex values(18750,'新预算')
GO
INSERT INTO HtmlLabelIndex values(18751,'变更差额')
GO
INSERT INTO HtmlLabelInfo VALUES(18747,'预算变更申请单',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18748,'预算单位',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18749,'原预算',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18750,'新预算',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18751,'变更差额',7)
GO

INSERT INTO HtmlLabelIndex values(17773,'审批预算')
GO
INSERT INTO HtmlLabelInfo VALUES(17773,'审批预算',7)
GO


CREATE TABLE FnaLoanInfo (
    id int IDENTITY,
    loantype int,
    organizationid int,
    organizationtype int,
    occurdate char(10),
    amount decimal(15,3),
    debitremark varchar(60),
    remark varchar(4000),
    requestid int,
    relatedcrm int,
    relatedprj int,
    processorid int)
GO


INSERT INTO HtmlLabelIndex values(18769,'审批中费用')
GO
INSERT INTO HtmlLabelIndex values(18768,'可用预算')
GO
INSERT INTO HtmlLabelInfo VALUES(18768,'可用预算',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18768,'available budget',8)
GO
INSERT INTO HtmlLabelInfo VALUES(18769,'审批中费用',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18769,'pending expense',8)
GO
INSERT INTO HtmlLabelIndex values(18503,'已发生费用')
GO
INSERT INTO HtmlLabelInfo VALUES(18503,'已发生费用',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18503,'',8)
GO

INSERT INTO HtmlLabelIndex values(18797,'销帐')
GO
INSERT INTO HtmlLabelInfo VALUES(18797,'销帐',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18797,'writeoff',8)
GO
INSERT INTO HtmlLabelIndex values(18798,'帐务往来')
GO
INSERT INTO HtmlLabelInfo VALUES(18798,'帐务往来',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18798,'account log',8)
GO
INSERT INTO HtmlLabelIndex values(18801,'欠款累计')
GO
INSERT INTO HtmlLabelInfo VALUES(18801,'欠款累计',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18801,'loan amount',8)
GO

create procedure importexpense
as
 Declare
 @relatedcrm_1 int,
 @relatedprj_1 int,
 @organizationid_1 int,
 @occurdate_1 char(10),
 @amount_1 decimal(15,3),
 @subject_1 int,
 @requestid_1 int,
 @description_1 varchar(250),
 @all_cursor cursor
 SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
 select feetypeid,resourceid,crmid,projectid,amount,occurdate,releatedid,description from FnaAccountLog where iscontractid=0 or iscontractid is null
 OPEN @all_cursor
 FETCH NEXT FROM @all_cursor INTO @subject_1,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,@description_1
 WHILE @@FETCH_STATUS = 0
 begin
  insert into fnaexpenseinfo(subject,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,status,type,description) values(@subject_1,3,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,1,2,@description_1)
  FETCH NEXT FROM @all_cursor INTO @subject_1,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,@description_1
 end
 CLOSE @all_cursor
 DEALLOCATE @all_cursor
go

create procedure importloan
as
 Declare
 @relatedcrm_1 int,
 @relatedprj_1 int,
 @organizationid_1 int,
 @occurdate_1 char(10),
 @amount_1 decimal(15,3),
 @subject_1 int,
 @requestid_1 int,
 @description_1 varchar(250),
 @loantype_1 int,
 @debitremark_1 varchar(60),
 @processorid_1 int,
 @all_cursor cursor
 SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
 select loantypeid,resourceid,crmid,projectid,amount,occurdate,releatedid,description,credenceno,dealuser from FnaLoanLog
 OPEN @all_cursor
 FETCH NEXT FROM @all_cursor INTO @loantype_1,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,@description_1,@debitremark_1,@processorid_1
 WHILE @@FETCH_STATUS = 0
 begin
  if(@loantype_1!=1)
  set @amount_1=-1*@amount_1
  insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) values(@loantype_1,3,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,@description_1,@debitremark_1,@processorid_1)
  FETCH NEXT FROM @all_cursor INTO @loantype_1,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,@description_1,@debitremark_1,@processorid_1
 end
 CLOSE @all_cursor
 DEALLOCATE @all_cursor
go

create TRIGGER Tri_importexpense ON fnaaccountlog
FOR INSERT
AS
declare
 @relatedcrm_1 int,
 @relatedprj_1 int,
 @organizationid_1 int,
 @occurdate_1 char(10),
 @amount_1 decimal(15,3),
 @subject_1 int,
 @requestid_1 int,
 @iscontract int,
 @description_1 varchar(250)
SELECT @iscontract = iscontractid FROM inserted
if(@iscontract=0 or @iscontract is null)
begin
select @subject_1 = feetypeid,@organizationid_1 = resourceid,@relatedcrm_1 = crmid,@relatedprj_1 = projectid,@occurdate_1 = occurdate,@amount_1 = amount,@requestid_1 = releatedid FROM inserted
insert into fnaexpenseinfo(subject,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,status,type,description) values(@subject_1,3,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,1,2,@description_1)
end
go

create TRIGGER Tri_importloan ON fnaloanlog
FOR INSERT
AS
declare
@relatedcrm_1 int,
 @relatedprj_1 int,
 @organizationid_1 int,
 @occurdate_1 char(10),
 @amount_1 decimal(15,3),
 @subject_1 int,
 @requestid_1 int,
 @description_1 varchar(250),
 @loantype_1 int,
 @debitremark_1 varchar(60),
 @processorid_1 int
select @loantype_1=loantypeid,@organizationid_1=resourceid,@relatedcrm_1=crmid,@relatedprj_1=projectid,@amount_1=amount,@occurdate_1=occurdate,@requestid_1=releatedid,@description_1=description,@debitremark_1=credenceno,@processorid_1=dealuser FROM inserted
if(@loantype_1=1)
insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) values(@loantype_1,3,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,@description_1,@debitremark_1,@processorid_1)
go


exec importexpense
go
exec importloan
go
create procedure Bill_SelectList_Insert(@billid int,@fieldname varchar(50),@selectvalue int,@selectname varchar(50),@listorder int,@isdefault char(1)) as
declare @fieldid int
select @fieldid=id from workflow_billfield where billid=@billid and fieldname=@fieldname
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname,listorder,isdefault) values(@fieldid,1,@selectvalue,@selectname,@listorder,@isdefault)
GO

exec Bill_SelectList_Insert 158,'wipetype',1,'现金',0,'y'
GO
exec Bill_SelectList_Insert 158,'wipetype',2,'支票',0,'n'
GO
exec Bill_SelectList_Insert 158,'wipetype',3,'汇票',0,'n'
GO
exec Bill_SelectList_Insert 158,'wipetype',4,'冲销借款',0,'n'
GO
exec Bill_SelectList_Insert 158,'wipetype',5,'其它',0,'n'
GO