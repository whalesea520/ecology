insert into SystemRights (id,rightdesc,righttype,detachable) values (664,'薪酬管理','3',1) 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (664,7,'薪酬管理','薪酬管理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (664,8,'Compensation Manager','Compensation Manager') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4165,'薪酬管理权限','Compensation:Manager',664) 
/
INSERT INTO HtmlLabelIndex values(19554,'工资单年月') 
/
INSERT INTO HtmlLabelInfo VALUES(19554,'工资单年月',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19554,'Date of the payroll',8) 
/
INSERT INTO HtmlLabelIndex values(19555,'是否已发送') 
/
INSERT INTO HtmlLabelInfo VALUES(19555,'是否已发送',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19555,'Whether Sent',8) 
/
INSERT INTO HtmlLabelIndex values(19556,'工资单状态') 
/
INSERT INTO HtmlLabelInfo VALUES(19556,'工资单状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19556,'Payroll State',8) 
/
INSERT INTO HtmlLabelIndex values(19557,'未发送') 
/
INSERT INTO HtmlLabelInfo VALUES(19557,'未发送',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19557,'Unsent',8) 
/
INSERT INTO HtmlLabelIndex values(19558,'已发送') 
/
INSERT INTO HtmlLabelInfo VALUES(19558,'已发送',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19558,'Sent',8) 
/
INSERT INTO HtmlLabelIndex values(19575,'关闭工资单') 
/
INSERT INTO HtmlLabelInfo VALUES(19575,'关闭工资单',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19575,'Close the payroll',8) 
/
INSERT INTO HtmlLabelIndex values(19576,'历史工资单') 
/
INSERT INTO HtmlLabelInfo VALUES(19576,'历史工资单',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19576,'History the payroll',8) 
/
INSERT INTO HtmlLabelIndex values(19577,'工资单已经存在，是否要重新生成？') 
/
INSERT INTO HtmlLabelInfo VALUES(19577,'工资单已经存在，是否要重新生成？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19577,'Payroll already existed,create payroll again?',8) 
/
INSERT INTO HtmlLabelIndex values(19578,'正在生成工资单，请稍等...') 
/
INSERT INTO HtmlLabelInfo VALUES(19578,'正在生成工资单，请稍等...',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19578,'Building payroll,Please wait...',8) 
/
INSERT INTO HtmlLabelIndex values(19580,'调整薪酬设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19580,'调整薪酬设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19580,'Change salary set',8) 
/
INSERT INTO HtmlLabelIndex values(19581,'你确定要调整薪酬设置吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19581,'你确定要调整薪酬设置吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19581,'Change salary set,are you sure?',8) 
/
INSERT INTO HtmlLabelIndex values(19583,'没有修改项！') 
/
INSERT INTO HtmlLabelInfo VALUES(19583,'没有修改项！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19583,'No changed items!',8) 
/
INSERT INTO HtmlLabelIndex values(19586,'你确定要发送工资单吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19586,'你确定要发送工资单吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19586,'Will send payroll,are you sure?',8) 
/
INSERT INTO HtmlLabelIndex values(19590,'工资单列表') 
/
INSERT INTO HtmlLabelInfo VALUES(19590,'工资单列表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19590,'Payroll list',8) 
/
INSERT INTO HtmlLabelIndex values(19592,'工资单调整') 
/
INSERT INTO HtmlLabelInfo VALUES(19592,'工资单调整',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19592,'Payroll changed',8) 
/
INSERT INTO HtmlLabelIndex values(19594,'生成工资单失败，请检查数据重试！') 
/
INSERT INTO HtmlLabelInfo VALUES(19594,'生成工资单失败，请检查数据重试！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19594,'Create payroll error,Please check data and create again!',8) 
/

alter table HrmSalarypaydetail add departmentid integer
/
alter table HrmSalarypaydetail add status integer default(0)
/
alter table HrmSalarypaydetail add sent integer default(0)
/
/* 薪酬管理更改记录 */
CREATE TABLE HRMSalaryPayLog(
    id int NOT NULL ,
    changid integer,/*修改人*/
    userid integer,/*被修改人*/
    changedate    varchar2(10),/*修改日期*/
    changetime   varchar2(8),/*修改时间*/
    payid integer,/*工资单id*/
    itemid varchar2(10),/*工资项*/
    oldvalue number(15,2),/*修改前值*/
    newvalue number(15,2), /*修改后值*/
    changedset integer /*是否应用到薪酬设置*/
)

/
create sequence  HRMSalaryPayLog_id                                      
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger HRMSalaryPayLog_trigger		
	before insert on HRMSalaryPayLog
	for each row
	begin
	select HRMSalaryPayLog_id.nextval into :new.id from dual;
	end ;
/