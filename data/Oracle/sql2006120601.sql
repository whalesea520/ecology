delete from SystemRights where id=687
/
delete from SystemRightsLanguage where id=687
/
delete from SystemRightDetail where id=4195
/
insert into SystemRights (id,rightdesc,righttype) values (687,'预算级别维护','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (687,8,'Budget Level Maintain','Budget Level Maintain') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (687,7,'预算级别维护','预算级别维护') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4195,'预算级别维护','BudgetLevel:Maint',687) 
/
delete from SystemRights where id=688
/
delete from SystemRightsLanguage where id=688
/
delete from SystemRightDetail where id=4196
/

insert into SystemRights (id,rightdesc,righttype) values (688,'预算权限维护','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (688,8,'Budget Rights Maintain','Budget Rights Maintain') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (688,7,'预算权限维护','预算权限维护') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4196,'预算权限维护','BudgetRights:Maint',688) 
/
delete from SystemRights where id=689
/
delete from SystemRightsLanguage where id=689
/
delete from SystemRightDetail where id=4197
/

insert into SystemRights (id,rightdesc,righttype) values (689,'费用导入','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (689,7,'费用导入','费用导入') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (689,8,'Fee Data Import','Fee Data Import') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4197,'费用导入','FeeDataImport:Maint',689) 
/

delete from HtmlLabelIndex where id=19856
/
delete from HtmlLabelInfo where indexid=19856
/

INSERT INTO HtmlLabelIndex values(19856,'预算级别') 
/
INSERT INTO HtmlLabelInfo VALUES(19856,'预算级别',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19856,'Budget Level',8) 
/
delete from HtmlLabelIndex where id=19857
/
delete from HtmlLabelInfo where indexid=19857
/
INSERT INTO HtmlLabelIndex values(19857,'上下级预算值大小是否关联') 
/
INSERT INTO HtmlLabelInfo VALUES(19857,'上下级预算值大小是否关联',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19857,'Budget Value is connected by level',8) 
/
 delete from HtmlLabelIndex where id=19858
/
delete from HtmlLabelInfo where indexid=19858
/
INSERT INTO HtmlLabelIndex values(19858,'是否关联') 
/
INSERT INTO HtmlLabelInfo VALUES(19858,'是否关联',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19858,'Is Connected',8) 
/
delete from HtmlLabelIndex where id=19880
/
delete from HtmlLabelInfo where indexid=19880
/ 
INSERT INTO HtmlLabelIndex values(19880,'预算权限') 
/
INSERT INTO HtmlLabelInfo VALUES(19880,'预算权限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19880,'Budget Rights',8) 
/
delete from HtmlLabelIndex where id=19912
/
delete from HtmlLabelInfo where indexid=19912
/
INSERT INTO HtmlLabelIndex values(19912,'维护范围') 
/
INSERT INTO HtmlLabelInfo VALUES(19912,'维护范围',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19912,'Maintenance Scope',8) 
/
 delete from HtmlLabelIndex where id=19914
/
delete from HtmlLabelInfo where indexid=19914
/
INSERT INTO HtmlLabelIndex values(19914,'本部门维护') 
/
INSERT INTO HtmlLabelInfo VALUES(19914,'本部门维护',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19914,'Maintenance Self',8) 
/
delete from HtmlLabelIndex where id=19915
/
delete from HtmlLabelInfo where indexid=19915
/
INSERT INTO HtmlLabelIndex values(19915,'指定部门维护') 
/
INSERT INTO HtmlLabelInfo VALUES(19915,'指定部门维护',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19915,'Maintenance By Other',8) 
/
delete from HtmlLabelIndex where id=19966
/
delete from HtmlLabelInfo where indexid=19966
/
INSERT INTO HtmlLabelIndex values(19966,'费用导入') 
/
INSERT INTO HtmlLabelInfo VALUES(19966,'费用导入',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19966,'Fee Data Import',8) 
/
delete from HtmlLabelIndex where id=19968
/
delete from HtmlLabelInfo where indexid=19968
/
INSERT INTO HtmlLabelIndex values(19968,'请选择费用科目') 
/
INSERT INTO HtmlLabelInfo VALUES(19968,'请选择费用科目',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19968,'Please Select Fee Subject To Import',8) 
/
delete from HtmlLabelIndex where id=19970
/
delete from HtmlLabelInfo where indexid=19970
/ 
INSERT INTO HtmlLabelIndex values(19970,'请下载模版文件，填充费用值后导入!') 
/
INSERT INTO HtmlLabelInfo VALUES(19970,'请下载模版文件，填充费用值后导入!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19970,'Please Download Templet , Filled it to Import',8) 
/
delete from HtmlLabelIndex where id=19971
/
delete from HtmlLabelInfo where indexid=19971
/
INSERT INTO HtmlLabelIndex values(19971,'模版文件') 
/
INSERT INTO HtmlLabelInfo VALUES(19971,'模版文件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19971,'Templet File',8) 
/
 delete from HtmlLabelIndex where id=19984
/
delete from HtmlLabelInfo where indexid=19984
/
INSERT INTO HtmlLabelIndex values(19984,'费用导入成功!')
/
INSERT INTO HtmlLabelInfo VALUES(19984,'费用导入成功!',7)
/
INSERT INTO HtmlLabelInfo VALUES(19984,'Fee Data Import Successfull!',8)
/
 