delete from HtmlLabelIndex where id=32288 
GO
delete from HtmlLabelInfo where indexid=32288 
GO
INSERT INTO HtmlLabelIndex values(32288,'举例:ou=zongbu,dc=weaver227,dc=com；如果为多个域以''|''隔开，举例:ou=zongbu,dc=weaver227,dc=com|ou=iuser,dc= weaver227,dc=com') 
GO
INSERT INTO HtmlLabelInfo VALUES(32288,'举例:ou=zongbu,dc=weaver227,dc=com；如果为多个域以''|''隔开，举例:ou=zongbu,dc=weaver227,dc=com|ou=iuser,dc= weaver227,dc=com',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32288,'For example: ou = zongbu, dc = weaver227, dc = com; If multiple domains with ''|'' separated, for example: ou = zongbu, dc = weaver227, dc = com | ou = iuser, dc = weaver227, dc = com',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32288,'舉例:ou=zongbu,dc=weaver227,dc=com；如果爲多個域以''|''隔開，舉例:ou=zongbu,dc=weaver227,dc=com|ou=iuser,dc= weaver227,dc=com',9) 
GO

delete from HtmlLabelIndex where id=30107 
GO
delete from HtmlLabelInfo where indexid=30107 
GO
INSERT INTO HtmlLabelIndex values(30107,'手动同步') 
GO
INSERT INTO HtmlLabelInfo VALUES(30107,'手工同步',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(30107,'Manual Sync',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(30107,'手动同步',9) 
GO