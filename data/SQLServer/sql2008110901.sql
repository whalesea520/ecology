delete from SystemRights where id=806
GO
insert into SystemRights (id,rightdesc,righttype) values (806,'客户门户密码修改权限','1') 
GO
delete from SystemRightsLanguage where id=806
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (806,7,'客户门户密码修改权限',' 客户门户密码修改权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (806,9,'客户门户密码修改权限','客户门户密码修改权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (806,8,'Customer portal password authority to amend','Customer portal password authority to amend') 
GO
delete from SystemRightDetail where id=4317
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4317,'客户门户密码修改权限','CRM:CusPassWord',806) 
GO
delete from HtmlLabelIndex where id=17993 
GO
delete from HtmlLabelInfo where indexid=17993 
GO
INSERT INTO HtmlLabelIndex values(17993,'修改密码') 
GO
INSERT INTO HtmlLabelInfo VALUES(17993,'修改密码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17993,'Edit Password',8) 
GO
