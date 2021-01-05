delete from HtmlLabelIndex where id=383010 
GO
delete from HtmlLabelInfo where indexid=383010 
GO
INSERT INTO HtmlLabelIndex values(383010,'') 
GO
INSERT INTO HtmlLabelInfo VALUES(383010,'拥有管理员权限的LDAP用户,输入对应的distinguishedName属性值;如果在根目录USERS组下只需要输入CN内容即可,如:administrator;如果在非根目录USERS组下的用户,需要输入全路径,如:CN=admin,OU=用户,OU=公司,DC=lw,DC=com',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(383010,'Hint',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(383010,'拥有管理员权限的LDAP用户,输入对应的distinguishedName属性值;如果在根目录USERS组下只需要输入CN内容即可,如:administrator;如果在非根目录USERS组下的用户,需要输入全路径,如:CN=admin,OU=用户,OU=公司,DC=lw,DC=com',9) 
GO