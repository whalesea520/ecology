delete from SystemRights where id = 809
go
delete from SystemRightsLanguage where id = 809
go
delete from SystemRightDetail where rightid = 809
go

insert into SystemRights (id,rightdesc,righttype) values (809,'流程保存为文档','5') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (809,7,'流程保存为文档','流程保存为文档') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (809,8,'Workflow to generate documents','Workflow to generate documents') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (809,9,'流程保存為文檔','流程保存為文檔') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4320,'流程保存为文档','workflowtodocument:all',809) 
GO

delete from HtmlLabelIndex where id=22220 
GO
delete from HtmlLabelInfo where indexid=22220 
GO
INSERT INTO HtmlLabelIndex values(22220,'流程保存为文档的存放路径') 
GO
INSERT INTO HtmlLabelInfo VALUES(22220,'流程保存为文档的存放路径',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22220,'workflow saved as the document store path',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22220,'流程保存為文檔的存放放路徑',9) 
GO

delete from HtmlLabelIndex where id=22231 
GO
delete from HtmlLabelInfo where indexid=22231 
GO
INSERT INTO HtmlLabelIndex values(22231,'流程存为文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(22231,'流程存为文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22231,'workflow saved as document',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22231,'流程存為文檔',9) 
GO

delete from HtmlLabelIndex where id=22232 
GO
delete from HtmlLabelInfo where indexid=22232 
GO
INSERT INTO HtmlLabelIndex values(22232,'您确定要将这些流程保存为文档吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(22232,'您确定要将这些流程保存为文档吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22232,'Are you sure to save these workflow as documents?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22232,'您確定要將這些流程保存為文檔嗎？',9) 
GO