insert into SystemRights (id,rightdesc,righttype,detachable) values (664,'薪酬管理','3',1) 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (664,7,'薪酬管理','薪酬管理') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (664,8,'Compensation Manager','Compensation Manager') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4165,'薪酬管理权限','Compensation:Manager',664) 
GO
INSERT INTO HtmlLabelIndex values(19554,'工资单年月') 
GO
INSERT INTO HtmlLabelInfo VALUES(19554,'工资单年月',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19554,'Date of the payroll',8) 
GO
INSERT INTO HtmlLabelIndex values(19555,'是否已发送') 
GO
INSERT INTO HtmlLabelInfo VALUES(19555,'是否已发送',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19555,'Whether Sent',8) 
GO
INSERT INTO HtmlLabelIndex values(19556,'工资单状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(19556,'工资单状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19556,'Payroll State',8) 
GO
INSERT INTO HtmlLabelIndex values(19557,'未发送') 
GO
INSERT INTO HtmlLabelInfo VALUES(19557,'未发送',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19557,'Unsent',8) 
GO
INSERT INTO HtmlLabelIndex values(19558,'已发送') 
GO
INSERT INTO HtmlLabelInfo VALUES(19558,'已发送',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19558,'Sent',8) 
GO
INSERT INTO HtmlLabelIndex values(19575,'关闭工资单') 
GO
INSERT INTO HtmlLabelInfo VALUES(19575,'关闭工资单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19575,'Close the payroll',8) 
GO
INSERT INTO HtmlLabelIndex values(19576,'历史工资单') 
GO
INSERT INTO HtmlLabelInfo VALUES(19576,'历史工资单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19576,'History the payroll',8) 
GO
INSERT INTO HtmlLabelIndex values(19577,'工资单已经存在，是否要重新生成？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19577,'工资单已经存在，是否要重新生成？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19577,'Payroll already existed,create payroll again?',8) 
GO
INSERT INTO HtmlLabelIndex values(19578,'正在生成工资单，请稍等...') 
GO
INSERT INTO HtmlLabelInfo VALUES(19578,'正在生成工资单，请稍等...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19578,'Building payroll,Please wait...',8) 
GO
INSERT INTO HtmlLabelIndex values(19580,'调整薪酬设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19580,'调整薪酬设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19580,'Change salary set',8) 
GO
INSERT INTO HtmlLabelIndex values(19581,'你确定要调整薪酬设置吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19581,'你确定要调整薪酬设置吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19581,'Change salary set,are you sure?',8) 
GO
INSERT INTO HtmlLabelIndex values(19583,'没有修改项！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19583,'没有修改项！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19583,'No changed items!',8) 
GO
INSERT INTO HtmlLabelIndex values(19586,'你确定要发送工资单吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19586,'你确定要发送工资单吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19586,'Will send payroll,are you sure?',8) 
GO
INSERT INTO HtmlLabelIndex values(19590,'工资单列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(19590,'工资单列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19590,'Payroll list',8) 
GO
INSERT INTO HtmlLabelIndex values(19592,'工资单调整') 
GO
INSERT INTO HtmlLabelInfo VALUES(19592,'工资单调整',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19592,'Payroll changed',8) 
GO
INSERT INTO HtmlLabelIndex values(19594,'生成工资单失败，请检查数据重试！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19594,'生成工资单失败，请检查数据重试！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19594,'Create payroll error,Please check data and create again!',8) 
GO

alter table HrmSalarypaydetail add departmentid int
GO
alter table HrmSalarypaydetail add status int default(0)
GO
alter table HrmSalarypaydetail add sent int default(0)
GO
/* 薪酬管理更改记录 */
CREATE TABLE HRMSalaryPayLog(
    id int NOT NULL IDENTITY (1, 1),
    changid int,/*修改人*/
    userid int,/*被修改人*/
    changedate    varchar(10),/*修改日期*/
    changetime   varchar(8),/*修改时间*/
    payid int,/*工资单id*/
    itemid varchar(10),/*工资项*/
    oldvalue decimal(15,2),/*修改前值*/
    newvalue decimal(15,2), /*修改后值*/
    changedset int /*是否应用到薪酬设置*/
)

go