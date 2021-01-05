delete from SystemRights where id=687
GO
delete from SystemRightsLanguage where id=687
GO
delete from SystemRightDetail where id=4195
GO
insert into SystemRights (id,rightdesc,righttype) values (687,'预算级别维护','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (687,8,'Budget Level Maintain','Budget Level Maintain') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (687,7,'预算级别维护','预算级别维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4195,'预算级别维护','BudgetLevel:Maint',687) 
GO
delete from SystemRights where id=688
GO
delete from SystemRightsLanguage where id=688
GO
delete from SystemRightDetail where id=4196
GO

insert into SystemRights (id,rightdesc,righttype) values (688,'预算权限维护','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (688,8,'Budget Rights Maintain','Budget Rights Maintain') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (688,7,'预算权限维护','预算权限维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4196,'预算权限维护','BudgetRights:Maint',688) 
GO
delete from SystemRights where id=689
GO
delete from SystemRightsLanguage where id=689
GO
delete from SystemRightDetail where id=4197
GO

insert into SystemRights (id,rightdesc,righttype) values (689,'费用导入','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (689,7,'费用导入','费用导入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (689,8,'Fee Data Import','Fee Data Import') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4197,'费用导入','FeeDataImport:Maint',689) 
GO

delete from HtmlLabelIndex where id=19856
GO
delete from HtmlLabelInfo where indexid=19856
GO

INSERT INTO HtmlLabelIndex values(19856,'预算级别') 
GO
INSERT INTO HtmlLabelInfo VALUES(19856,'预算级别',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19856,'Budget Level',8) 
GO
delete from HtmlLabelIndex where id=19857
GO
delete from HtmlLabelInfo where indexid=19857
GO
INSERT INTO HtmlLabelIndex values(19857,'上下级预算值大小是否关联') 
GO
INSERT INTO HtmlLabelInfo VALUES(19857,'上下级预算值大小是否关联',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19857,'Budget Value is connected by level',8) 
GO
 delete from HtmlLabelIndex where id=19858
GO
delete from HtmlLabelInfo where indexid=19858
GO
INSERT INTO HtmlLabelIndex values(19858,'是否关联') 
GO
INSERT INTO HtmlLabelInfo VALUES(19858,'是否关联',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19858,'Is Connected',8) 
GO
delete from HtmlLabelIndex where id=19880
GO
delete from HtmlLabelInfo where indexid=19880
GO 
INSERT INTO HtmlLabelIndex values(19880,'预算权限') 
GO
INSERT INTO HtmlLabelInfo VALUES(19880,'预算权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19880,'Budget Rights',8) 
GO
delete from HtmlLabelIndex where id=19912
GO
delete from HtmlLabelInfo where indexid=19912
GO
INSERT INTO HtmlLabelIndex values(19912,'维护范围') 
GO
INSERT INTO HtmlLabelInfo VALUES(19912,'维护范围',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19912,'Maintenance Scope',8) 
GO
 delete from HtmlLabelIndex where id=19914
GO
delete from HtmlLabelInfo where indexid=19914
GO
INSERT INTO HtmlLabelIndex values(19914,'本部门维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(19914,'本部门维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19914,'Maintenance Self',8) 
GO
delete from HtmlLabelIndex where id=19915
GO
delete from HtmlLabelInfo where indexid=19915
GO
INSERT INTO HtmlLabelIndex values(19915,'指定部门维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(19915,'指定部门维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19915,'Maintenance By Other',8) 
GO
delete from HtmlLabelIndex where id=19966
GO
delete from HtmlLabelInfo where indexid=19966
GO
INSERT INTO HtmlLabelIndex values(19966,'费用导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(19966,'费用导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19966,'Fee Data Import',8) 
GO
delete from HtmlLabelIndex where id=19968
GO
delete from HtmlLabelInfo where indexid=19968
GO
INSERT INTO HtmlLabelIndex values(19968,'请选择费用科目') 
GO
INSERT INTO HtmlLabelInfo VALUES(19968,'请选择费用科目',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19968,'Please Select Fee Subject To Import',8) 
GO
delete from HtmlLabelIndex where id=19970
GO
delete from HtmlLabelInfo where indexid=19970
GO 
INSERT INTO HtmlLabelIndex values(19970,'请下载模版文件，填充费用值后导入!') 
GO
INSERT INTO HtmlLabelInfo VALUES(19970,'请下载模版文件，填充费用值后导入!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19970,'Please Download Templet , Filled it to Import',8) 
GO
delete from HtmlLabelIndex where id=19971
GO
delete from HtmlLabelInfo where indexid=19971
GO
INSERT INTO HtmlLabelIndex values(19971,'模版文件') 
GO
INSERT INTO HtmlLabelInfo VALUES(19971,'模版文件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19971,'Templet File',8) 
GO
 delete from HtmlLabelIndex where id=19984
GO
delete from HtmlLabelInfo where indexid=19984
GO
INSERT INTO HtmlLabelIndex values(19984,'费用导入成功!')
GO
INSERT INTO HtmlLabelInfo VALUES(19984,'费用导入成功!',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19984,'Fee Data Import Successfull!',8)
GO
 