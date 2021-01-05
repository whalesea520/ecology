delete from HtmlLabelIndex where id=20184
go
delete from HtmlLabelIndex where id=20185
go

delete from HtmlLabelInfo where indexid=20184
go
delete from HtmlLabelInfo where indexid=20185
go
INSERT INTO HtmlLabelIndex values(20184,'计划导入') 
GO
INSERT INTO HtmlLabelIndex values(20185,'写实导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(20184,'计划导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20184,'import plan',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20185,'写实导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20185,'import not',8) 
GO
delete from HtmlLabelIndex where id=20188
go

delete from HtmlLabelInfo where indexid=20188
go
INSERT INTO HtmlLabelIndex values(20188,'计划导出') 
GO
INSERT INTO HtmlLabelInfo VALUES(20188,'计划导出',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20188,'export plan',8) 
GO

delete from HtmlLabelIndex where id=20189
go

delete from HtmlLabelInfo where indexid=20189
go
INSERT INTO HtmlLabelIndex values(20189,'写实导出') 
GO
INSERT INTO HtmlLabelInfo VALUES(20189,'写实导出',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20189,'export not',8) 
GO
 

insert into SystemRights (id,rightdesc,righttype) values (705,'计划导入','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (705,7,'计划导入','计划导入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (705,8,'import plan','import plan') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4213,'计划导入','PlanImport',705) 
GO

insert into SystemRights (id,rightdesc,righttype) values (704,'计划导出','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (704,7,'计划导出','计划导出') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (704,8,'export plan','export plan') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4212,'计划导出','EXPORTPLAN',704) 
GO