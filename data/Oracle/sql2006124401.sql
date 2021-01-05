
delete from  HtmlLabelIndex  where id=20100
/

delete from  HtmlLabelIndex  where id=20099
/

delete from  HtmlLabelInfo  where indexid=20100
/
delete from  HtmlLabelInfo  where indexid=20099
/

INSERT INTO HtmlLabelIndex values(20099,'计划管理') 
/
INSERT INTO HtmlLabelIndex values(20100,'计划类别设定') 
/
INSERT INTO HtmlLabelInfo VALUES(20099,'计划管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20099,'Manager Plan',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20100,'计划类别设定',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20100,'Set Plan Type',8) 
/

insert into SystemRights (id,rightdesc,righttype) values (699,'计划性质设置','7') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (699,7,'计划性质设置','计划性质设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (699,8,'Set Plan Property','Set Plan Property') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4207,'计划性质设置','PLANPROPERTY:SET',699) 
/

insert into SystemRights (id,rightdesc,righttype) values (698,'计划类别设置','7') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (698,7,'计划类别设置','计划类别设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (698,8,'Set Plan Type','Set Plan Type') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4206,'计划类别设置','PLANTYPE:SET',698) 
/
insert into SystemRights (id,rightdesc,righttype) values (697,'查询月度计划','7') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (697,7,'查询月度计划','查询月度计划') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (697,8,'Query Plan of Month','Query Plan of Month') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4205,'月度计划查询','PLAN:QUERY',697) 
/

insert into SystemRights (id,rightdesc,righttype) values (696,'组织机构树浏览权限','7') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (696,8,'View Resource Tree','View Resource Tree') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (696,7,'组织机构树浏览权限','组织机构树浏览权限') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4204,'组织机构浏览权限','RESOURCETREE:VIEW',696) 
/

insert into SystemRights (id,rightdesc,righttype) values (695,'工作写实权限','7') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (695,8,'PLAN LOG','PLAN LOG') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (695,7,'工作写实权限','工作写实权限') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4203,'写实权限','PLANLOG:VIEW',695) 
/

insert into SystemRights (id,rightdesc,righttype) values (694,'计划审批','7') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (694,8,'Plan Confirm','Plan Confirm') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (694,7,'计划审批','计划审批') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4202,'计划审批','PLAN:CONFIRM',694) 
/


insert into SystemRights (id,rightdesc,righttype) values (693,'年度计划建立','7') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (693,8,'create plan of the year','create plan of the year') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (693,7,'年度计划建立','年度计划建立') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4201,'年度计划建立','YEARPLAN:CREATE',693) 
/


delete from  HtmlLabelIndex  where id=20101
/

delete from  HtmlLabelIndex  where id=20102
/
delete from  HtmlLabelIndex  where id=20103
/

delete from  HtmlLabelIndex  where id=20104
/
delete from  HtmlLabelIndex  where id=20105
/

delete from  HtmlLabelIndex  where id=20106
/
delete from  HtmlLabelIndex  where id=20107
/

delete from  HtmlLabelIndex  where id=20108
/


delete from  HtmlLabelInfo  where indexid=20101
/
delete from  HtmlLabelInfo  where indexid=20102
/
delete from  HtmlLabelInfo  where indexid=20103
/
delete from  HtmlLabelInfo  where indexid=20104
/
delete from  HtmlLabelInfo  where indexid=20105
/
delete from  HtmlLabelInfo  where indexid=20106
/
delete from  HtmlLabelInfo  where indexid=20107
/
delete from  HtmlLabelInfo  where indexid=20108
/
INSERT INTO HtmlLabelIndex values(20101,'所属类别') 
/
INSERT INTO HtmlLabelInfo VALUES(20101,'所属类别',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20101,'Belong Type',8) 
/

INSERT INTO HtmlLabelIndex values(20102,'工时计算方式') 
/
INSERT INTO HtmlLabelIndex values(20103,'工时计算标准') 
/
INSERT INTO HtmlLabelIndex values(20104,'是否生成工作编号') 
/
INSERT INTO HtmlLabelIndex values(20105,'是否审批') 
/
INSERT INTO HtmlLabelIndex values(20106,'计划显示颜色') 
/
INSERT INTO HtmlLabelInfo VALUES(20102,'工时计算方式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20102,'Method of Count WorkTime',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20103,'工时计算标准',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20103,'STD of Count WorkTime',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20104,'是否生成工作编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20104,'get code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20105,'是否审批',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20105,'if confirm',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20106,'计划显示颜色',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20106,'color of plan',8) 
/

INSERT INTO HtmlLabelIndex values(20107,'按月平均分配') 
/
INSERT INTO HtmlLabelIndex values(20108,'标准值*月工作天数') 
/
INSERT INTO HtmlLabelInfo VALUES(20107,'按月平均分配',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20107,'share alike by month',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20108,'标准值*月工作天数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20108,'STD value*month''s days',8) 
/

delete from SystemRights where id=595
/

delete from SystemRightDetail where id=4096
/

delete from SystemRightsLanguage where id=595
/

insert into SystemRights (id,rightdesc,righttype) values (595,'部门经理','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (595,7,'部门经理','部门经理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (595,8,'manager','department manager') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4096,'部门经理','Manager',595) 
/

delete from  HtmlLabelIndex  where id=20119
/

delete from  HtmlLabelIndex  where id=20120
/


delete from  HtmlLabelInfo  where indexid=20119
/
delete from  HtmlLabelInfo  where indexid=20120
/

INSERT INTO HtmlLabelIndex values(20119,'添加为月度计划') 
/
INSERT INTO HtmlLabelInfo VALUES(20119,'添加为月度计划',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20119,'add to monthplan',8) 
/
INSERT INTO HtmlLabelIndex values(20120,'工作编号') 
/
INSERT INTO HtmlLabelInfo VALUES(20120,'工作编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20120,'work code',8) 
/