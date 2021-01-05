delete from SystemRightDetail where rightid =2011
GO
delete from SystemRightsLanguage where id =2011
GO
delete from SystemRights where id =2011
GO
insert into SystemRights (id,rightdesc,righttype) values (2011,'派工权限','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,9,'派工權限','派工權限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,7,'派工权限','派工权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,8,'Dispatching authority','Dispatching authority') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,15,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43229,'派工权限','workflow:Dispatching',2011) 
GO


delete from HtmlLabelIndex where id=128468 
GO
delete from HtmlLabelInfo where indexid=128468 
GO
INSERT INTO HtmlLabelIndex values(128468,'手动') 
GO
INSERT INTO HtmlLabelInfo VALUES(128468,'手动',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128468,'Manually',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128468,'手動',9) 
GO

delete from HtmlLabelIndex where id=128469 
GO
delete from HtmlLabelInfo where indexid=128469 
GO
INSERT INTO HtmlLabelIndex values(128469,'派工') 
GO
INSERT INTO HtmlLabelInfo VALUES(128469,'派工',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128469,'Dispatching',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128469,'派工',9) 
GO