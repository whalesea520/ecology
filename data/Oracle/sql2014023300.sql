delete from SystemRightDetail where rightid =1625
/
delete from SystemRightsLanguage where id =1625
/
delete from SystemRights where id =1625
/
insert into SystemRights (id,rightdesc,righttype) values (1625,'΢�Ź���','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1625,7,'΢�Ź���ƽ̨����','΢�Ź���ƽ̨����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1625,8,'wechat managermenet','wechat managermenet') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1625,9,'΢�Ź��\ƽ̨����','΢�Ź��\ƽ̨����') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42861,'΢�Ź���ƽ̨����','Wechat:Mgr',1625) 
/


delete from SystemRightDetail where rightid =1631
/
delete from SystemRightsLanguage where id =1631
/
delete from SystemRights where id =1631
/
insert into SystemRights (id,rightdesc,righttype) values (1631,'΢��Ӧ������','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1631,8,'Wechat Setting','Wechat Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1631,7,'΢��Ӧ������','΢��Ӧ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1631,9,'΢�ő����O��','΢�ő����O��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42866,'΢��Ӧ������','Wechat:Set',1631) 
/