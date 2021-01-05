delete from SystemRightDetail where rightid =1727
go
delete from SystemRightsLanguage where id =1727
go
delete from SystemRights where id =1727
go
insert into SystemRights (id,rightdesc,righttype) values (1727,'移动建模设置','7') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,7,'移动建模设置','移动建模设置') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,8,'Mobile Mode Settings','Mobile Mode Settings') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,9,'移動建模設置','移動建模設置') 
go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42953,'移动建模设置完全控制权限','MobileModeSet:All',1727) 
go
