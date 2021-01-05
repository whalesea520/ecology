/*增加 菜单自定义 权限*/
insert into SystemRights (id,rightdesc,righttype) values (460,'菜单自定义','7') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (460,7,'菜单自定义','菜单自定义') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (460,8,'menuCustom','menuCustom') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3152,'菜单自定义','MenuCustom:Maintenance',460) 
GO

insert into SystemRightToGroup (groupid, rightid) values (1,419)
GO