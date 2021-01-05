INSERT INTO HtmlLabelIndex values(19427,'薪酬指标设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19427,'薪酬指标设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19427,'compensation target setting',8) 
/
INSERT INTO HtmlLabelIndex values(19430,'薪酬指标数据维护') 
/
INSERT INTO HtmlLabelInfo VALUES(19430,'薪酬指标数据维护',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19430,'compensation target data maintenance',8) 
/
INSERT INTO HtmlLabelIndex values(19436,'本分部及下级分部') 
/
INSERT INTO HtmlLabelInfo VALUES(19436,'本分部及下级分部',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19436,'the subcompany and lower subcompany',8) 
/
INSERT INTO HtmlLabelIndex values(19437,'指定分部') 
/
INSERT INTO HtmlLabelIndex values(19438,'指定部门') 
/
INSERT INTO HtmlLabelInfo VALUES(19437,'指定分部',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19437,'appointe subcompany',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19438,'指定部门',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19438,'appointe department',8) 
/
INSERT INTO HtmlLabelIndex values(19454,'薪酬指标') 
/
INSERT INTO HtmlLabelInfo VALUES(19454,'薪酬指标',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19454,'compensation target',8) 
/
INSERT INTO HtmlLabelIndex values(19464,'数据对象') 
/
INSERT INTO HtmlLabelInfo VALUES(19464,'数据对象',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19464,'data object',8) 
/
INSERT INTO HtmlLabelIndex values(19465,'薪酬指标年月') 
/
INSERT INTO HtmlLabelInfo VALUES(19465,'薪酬指标年月',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19465,'compensation target monthly',8) 
/
INSERT INTO HtmlLabelIndex values(19470,'服务器正在处理薪酬指标数据导入，请稍候...') 
/
INSERT INTO HtmlLabelInfo VALUES(19470,'服务器正在处理薪酬指标数据导入，请稍候...',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19470,'loading compensation target data,please wait...',8) 
/
INSERT INTO HtmlLabelIndex values(19481,'导入前该分部/部门下的该月薪酬指标数据将全部删除，你确定要继续导入吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19481,'导入前该分部/部门下的该月薪酬指标数据将全部删除，你确定要继续导入吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19481,'the compensation target data will be deleted,are you sure continue load?',8) 
/
INSERT INTO HtmlLabelIndex values(19488,'薪酬指标数据导入成功！') 
/
INSERT INTO HtmlLabelInfo VALUES(19488,'薪酬指标数据导入成功！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19488,'compensation target data loaded success!',8) 
/
INSERT INTO HtmlLabelIndex values(19489,'导出Excel模板') 
/
INSERT INTO HtmlLabelInfo VALUES(19489,'导出Excel模板',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19489,'export Excel template',8) 
/

insert into SystemRights (id,rightdesc,righttype,detachable) values (660,'薪酬指标设置','3',1) 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (660,7,'薪酬指标设置','薪酬指标设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (660,8,'compensation target setting','compensation target setting') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4160,'薪酬指标设置权限','Compensation:Setting',660) 
/
insert into SystemRights (id,rightdesc,righttype,detachable) values (661,'薪酬指标数据维护','3',1) 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (661,7,'薪酬指标数据维护','薪酬指标数据维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (661,8,'compensation target data maintenance','compensation target data maintenance') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4161,'薪酬指标数据维护权限','Compensation:Maintenance',661) 
/

call MMConfig_U_ByInfoInsert (50,2)
/
call MMInfo_Insert( 517,19427,'','/hrm/finance/compensation/CompensationTargetSet_frm.jsp','mainFrame',50,2,2,0,'',0,'Compensation:Setting',0,'','',0,'','',2)
/
call MMConfig_U_ByInfoInsert (50,3)
/
call MMInfo_Insert (518,19430,'','/hrm/finance/compensation/CompensationTargetMaint_frm.jsp','mainFrame',50,2,3,0,'',0,'Compensation:Maintenance',0,'','',0,'','',2)
/


CREATE TABLE HRM_CompensationTargetSet(
    id  integer NOT NULL ,
    subcompanyid    integer,/*分部id*/
    TargetName    varchar2(50),/*简称*/
    Explain   varchar2(100),/*说明*/
    AreaType integer,/*应用范围类型*/
    memo varchar2(500)/*备注*/
)
/
create sequence Prj_HRM_CptTSet_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_HRM_CptTSet_Trigger
before insert on HRM_CompensationTargetSet
for each row
begin
select Prj_HRM_CptTSet_id.nextval into :new.id from dual;
end;
/



CREATE TABLE HRM_ComTargetSetDetail(
    Targetid    integer,/*指标id*/
    companyordeptid    integer/*部门/分部id*/
)
/


CREATE TABLE HRM_CompensationTargetInfo(
    id  integer NOT NULL ,
    subcompanyid    integer,/*分部id*/
    departmentid    integer,/*部门id*/
    CompensationYear   integer,/*年*/
    CompensationMonth  integer,/*月*/
    Userid   integer,/*员工id*/
    memo varchar2(500)/*备注*/
)
/
create sequence HRM_CpTargetInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HRM_CpTargetInfo_Trigger
before insert on HRM_CompensationTargetInfo
for each row
begin
select HRM_CpTargetInfo_id.nextval into :new.id from dual;
end;
/


CREATE TABLE HRM_CompensationTargetDetail(
    CompensationTargetid    integer,/*指标数据id*/
    Targetid    integer,/*指标id*/
    Target number(15,2)/*指标值*/
)
/
