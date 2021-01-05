delete from SystemRightsLanguage where id=549
GO
delete from SystemRightDetail where id=4049
GO
delete from SystemRights where id=549
GO



insert into SystemRights (id,rightdesc,righttype) values (549,'新建短信','1') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (549,8,'Send Message','Send Message Right') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (549,7,'新建短信','新建短信页面权限') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4049,'新建短信','CreateSMS:View',549) 
GO

