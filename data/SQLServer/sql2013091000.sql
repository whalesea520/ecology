delete from SystemRightDetail where rightid =1547
GO
delete from SystemRightsLanguage where id =1547
GO
delete from SystemRights where id =1547
GO
insert into SystemRights (id,rightdesc,righttype) values (1547,'֪ʶ����Ӧ������','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1547,8,'Knowledge management applications settings','Knowledge management applications settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1547,7,'֪ʶ����Ӧ������','֪ʶ����Ӧ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1547,9,'֪�R���푪���O��','֪�R���푪���O��') 
GO
