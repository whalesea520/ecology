delete from SystemRightDetail where rightid =1912
GO
delete from SystemRightsLanguage where id =1912
GO
delete from SystemRights where id =1912
GO
insert into SystemRights (id,rightdesc,righttype) values (1912,'�ʲ�Ԥ������','4') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,7,'�ʲ�Ԥ������','�ʲ�Ԥ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,9,'�Y�a�A���O��','�Y�a�A���O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,8,'Asset early warning','Asset early warning') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,12,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41912,'�ʲ�Ԥ������','Cpt4Mode:AlarmSettings',1912) 
GO