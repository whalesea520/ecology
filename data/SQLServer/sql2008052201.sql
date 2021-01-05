delete from HtmlLabelIndex where id=20221 
GO
delete from HtmlLabelInfo where indexid=20221 
GO
INSERT INTO HtmlLabelIndex values(20221,'日程共享设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(20221,'日程共享设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20221,'Work Plan Share Setting',8) 
GO

delete from HtmlLabelIndex where id=21503 
GO
delete from HtmlLabelInfo where indexid=21503 
GO
INSERT INTO HtmlLabelIndex values(21503,'共享日程') 
GO
INSERT INTO HtmlLabelInfo VALUES(21503,'共享日程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21503,'share calendar',8) 
GO

delete from HtmlLabelIndex where id=21504 
GO
delete from HtmlLabelInfo where indexid=21504 
GO
INSERT INTO HtmlLabelIndex values(21504,'被共享对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(21504,'被共享对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21504,'shared object',8) 
GO

delete from HtmlLabelIndex where id=19117 
GO
delete from HtmlLabelInfo where indexid=19117 
GO
INSERT INTO HtmlLabelIndex values(19117,'共享对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(19117,'共享对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19117,'Share Object',8) 
GO

delete from SystemRights where id=784
GO
insert into SystemRights (id,rightdesc,righttype) values (784,'日程共享','7') 
GO
delete from SystemRightsLanguage where id=784
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (784,8,'clander share','clander share') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (784,7,'日程共享','日程共享') 
GO
delete from SystemRightDetail where id=4294
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4294,'日程共享','SHARERIGHT:WORKPLAN',784) 
GO
