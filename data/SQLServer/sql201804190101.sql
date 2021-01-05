delete from HtmlLabelIndex where id=383025 
GO
delete from HtmlLabelInfo where indexid=383025 
GO
INSERT INTO HtmlLabelIndex values(383025,'ldap服务器地址框添加提示语') 
GO
INSERT INTO HtmlLabelInfo VALUES(383025,'LDAP服务器地址需以“ldap://”开头，如：ldap://192.168.0.44:389',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(383025,'The LDAP server address needs to start with &quot;ldap://&quot;, such as: ldap://192.168.0.44:389',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(383025,'LDAP伺服器地址需以“ldap://”開頭，如：ldap://192.168.0.44:389',9) 
GO