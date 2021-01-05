INSERT INTO HtmlLabelIndex values(19427,'薪酬指标设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19427,'薪酬指标设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19427,'compensation target setting',8) 
GO
INSERT INTO HtmlLabelIndex values(19430,'薪酬指标数据维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(19430,'薪酬指标数据维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19430,'compensation target data maintenance',8) 
GO
INSERT INTO HtmlLabelIndex values(19436,'本分部及下级分部') 
GO
INSERT INTO HtmlLabelInfo VALUES(19436,'本分部及下级分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19436,'the subcompany and lower subcompany',8) 
GO
INSERT INTO HtmlLabelIndex values(19437,'指定分部') 
GO
INSERT INTO HtmlLabelIndex values(19438,'指定部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(19437,'指定分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19437,'appointe subcompany',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19438,'指定部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19438,'appointe department',8) 
GO
INSERT INTO HtmlLabelIndex values(19454,'薪酬指标') 
GO
INSERT INTO HtmlLabelInfo VALUES(19454,'薪酬指标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19454,'compensation target',8) 
GO
INSERT INTO HtmlLabelIndex values(19464,'数据对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(19464,'数据对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19464,'data object',8) 
GO
INSERT INTO HtmlLabelIndex values(19465,'薪酬指标年月') 
GO
INSERT INTO HtmlLabelInfo VALUES(19465,'薪酬指标年月',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19465,'compensation target monthly',8) 
GO
INSERT INTO HtmlLabelIndex values(19470,'服务器正在处理薪酬指标数据导入，请稍候...') 
GO
INSERT INTO HtmlLabelInfo VALUES(19470,'服务器正在处理薪酬指标数据导入，请稍候...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19470,'loading compensation target data,please wait...',8) 
GO
INSERT INTO HtmlLabelIndex values(19481,'导入前该分部/部门下的该月薪酬指标数据将全部删除，你确定要继续导入吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19481,'导入前该分部/部门下的该月薪酬指标数据将全部删除，你确定要继续导入吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19481,'the compensation target data will be deleted,are you sure continue load?',8) 
GO
INSERT INTO HtmlLabelIndex values(19488,'薪酬指标数据导入成功！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19488,'薪酬指标数据导入成功！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19488,'compensation target data loaded success!',8) 
GO
INSERT INTO HtmlLabelIndex values(19489,'导出Excel模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(19489,'导出Excel模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19489,'export Excel template',8) 
GO

insert into SystemRights (id,rightdesc,righttype,detachable) values (660,'薪酬指标设置','3',1) 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (660,7,'薪酬指标设置','薪酬指标设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (660,8,'compensation target setting','compensation target setting') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4160,'薪酬指标设置权限','Compensation:Setting',660) 
GO
insert into SystemRights (id,rightdesc,righttype,detachable) values (661,'薪酬指标数据维护','3',1) 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (661,7,'薪酬指标数据维护','薪酬指标数据维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (661,8,'compensation target data maintenance','compensation target data maintenance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4161,'薪酬指标数据维护权限','Compensation:Maintenance',661) 
GO

EXECUTE MMConfig_U_ByInfoInsert 50,2
GO
EXECUTE MMInfo_Insert 517,19427,'','/hrm/finance/compensation/CompensationTargetSet_frm.jsp','mainFrame',50,2,2,0,'',0,'Compensation:Setting',0,'','',0,'','',2
GO
EXECUTE MMConfig_U_ByInfoInsert 50,3
GO
EXECUTE MMInfo_Insert 518,19430,'','/hrm/finance/compensation/CompensationTargetMaint_frm.jsp','mainFrame',50,2,3,0,'',0,'Compensation:Maintenance',0,'','',0,'','',2
GO


CREATE TABLE HRM_CompensationTargetSet(
    id  int NOT NULL IDENTITY (1, 1),
    subcompanyid    int,/*分部id*/
    TargetName    varchar(50),/*简称*/
    Explain   varchar(100),/*说明*/
    AreaType int,/*应用范围类型*/
    memo varchar(500)/*备注*/
)
GO

CREATE TABLE HRM_ComTargetSetDetail(
    Targetid    int,/*指标id*/
    companyordeptid    int/*部门/分部id*/
)
GO
CREATE TABLE HRM_CompensationTargetInfo(
    id  int NOT NULL IDENTITY (1, 1),
    subcompanyid    int,/*分部id*/
    departmentid    int,/*部门id*/
    CompensationYear   int,/*年*/
    CompensationMonth  int,/*月*/
    Userid   int,/*员工id*/
    memo varchar(500)/*备注*/
)
GO

CREATE TABLE HRM_CompensationTargetDetail(
    CompensationTargetid    int,/*指标数据id*/
    Targetid    int,/*指标id*/
    Target decimal(15,2)/*指标值*/
)
GO


