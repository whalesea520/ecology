update SystemRights set rightdesc='职务维护' where id=29
go
DELETE FROM SystemRights WHERE ID=30
GO
DELETE FROM SystemRightsLanguage WHERE ID =30
GO
DELETE FROM SystemRightDetail WHERE rightid = 30
GO
insert into SystemRights (id,rightdesc,righttype) values (30,'岗位维护','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (30,7,'岗位维护','岗位的添加，删除，更新和日志查看') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (30,8,'HrmJobTitles','Add,delete,update and log HrmJobTitles') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (104,'岗位添加','HrmJobTitlesAdd:Add',30) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (105,'岗位编辑','HrmJobTitlesEdit:Edit',30) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (106,'岗位删除','HrmJobTitlesEdit:Delete',30) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (107,'岗位日志查看','HrmJobTitles:Log',30) 
GO