delete from SystemRightDetail where rightid =1878
/
delete from SystemRightsLanguage where id =1878
/
delete from SystemRights where id =1878
/
insert into SystemRights (id,rightdesc,righttype) values (1878,'״̬�����������','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1878,7,'״̬�����������','״̬�����������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1878,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1878,8,'State change process Settings','State change process Settings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1878,9,'��B׃�������O��','��B׃�������O��') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43109,'״̬�����������','StateChangeProcess:Set',1878) 
/
insert into systemrighttogroup(groupid,rightid) values(3,1878)
/