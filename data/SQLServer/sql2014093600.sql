delete from SystemRightDetail where rightid =1729
GO
delete from SystemRightsLanguage where id =1729
GO
delete from SystemRights where id =1729
GO
insert into SystemRights (id,rightdesc,righttype) values (1729,'日程应用设置','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1729,7,'日程应用设置','日程应用设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1729,9,'日程應用設置','日程應用設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1729,8,'WorkPlan Set','WorkPlan Set') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42958,'日程应用设置','WorkPlan:Set',1729) 
GO