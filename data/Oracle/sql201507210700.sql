delete from SystemRightDetail where rightid =1882
/
delete from SystemRightsLanguage where id =1882
/
delete from SystemRights where id =1882
/
insert into SystemRights (id,rightdesc,righttype) values (1882,'����ѡ���ά��','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1882,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1882,8,'Public choice frame maintenance','Public choice frame maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1882,7,'����ѡ���ά��','����ѡ���ά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1882,9,'�����x���S�o','�����x���S�o') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43113,'����ѡ���ά��','WORKFLOWPUBLICCHOICE:VIEW',1882) 
/