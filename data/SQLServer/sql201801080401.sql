delete from HtmlLabelIndex where id=382106 
GO
delete from HtmlLabelInfo where indexid=382106 
GO
INSERT INTO HtmlLabelIndex values(382106,'同步黑名单') 
GO
delete from HtmlLabelIndex where id=382107 
GO
delete from HtmlLabelInfo where indexid=382107 
GO
INSERT INTO HtmlLabelIndex values(382107,'人员黑名单') 
GO
delete from HtmlLabelIndex where id=382108 
GO
delete from HtmlLabelInfo where indexid=382108 
GO
INSERT INTO HtmlLabelIndex values(382108,'填入不需要同步的人员登录名，用英文逗号分隔例如：zhangsan,lisi') 
GO
INSERT INTO HtmlLabelInfo VALUES(382108,'填入不需要同步的人员登录名，用英文逗号分隔例如：zhangsan,lisi',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382108,'Fill in the names of people who do not need synchronization, separated by English commas, such as zhangsan,lisi',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382108,'填入不需要同步的人員登錄名，用英文逗號分隔例如：zhangsan,lisi',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382107,'人员黑名单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382107,'Blacklist of personnel',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382107,'人員黑名單',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382106,'同步黑名单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382106,'Synchro blacklist',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382106,'同步黑名單',9) 
GO