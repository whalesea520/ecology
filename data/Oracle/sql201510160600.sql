delete from SystemRightDetail where rightid =1912
/
delete from SystemRightsLanguage where id =1912
/
delete from SystemRights where id =1912
/
insert into SystemRights (id,rightdesc,righttype) values (1912,'�ʲ�Ԥ������','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,7,'�ʲ�Ԥ������','�ʲ�Ԥ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,9,'�Y�a�A���O��','�Y�a�A���O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,8,'Asset early warning','Asset early warning') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,12,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41912,'�ʲ�Ԥ������','Cpt4Mode:AlarmSettings',1912) 
/