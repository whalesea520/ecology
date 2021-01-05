insert into SystemRights (id,rightdesc,righttype) values (416,'人力资源显示顺序','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (416,7,'人力资源显示顺序维护','人力资源显示顺序维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (416,8,'Display Order of Human Resource','Display Order of Human Resource') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3105,'人力资源显示顺序查看','Hrmdsporder:Add',416) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3106,'人力资源显示顺序修改','HrmdsporderEdit:Edit',416) 
GO
