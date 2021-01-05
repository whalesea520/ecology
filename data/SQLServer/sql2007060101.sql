delete from HtmlLabelIndex where id=19870
go
delete from HtmlLabelInfo where indexid=19870
go

INSERT INTO HtmlLabelIndex values(19870,'项目监控') 
GO
INSERT INTO HtmlLabelInfo VALUES(19870,'项目监控',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19870,'',8) 
GO

insert into SystemRights (id,rightdesc,righttype) values (98,'项目维护','6') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (98,8,'Project maintenance','Project maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (98,7,'项目维护','项目维护') 
GO