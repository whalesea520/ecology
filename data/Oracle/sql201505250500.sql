delete from SystemRightDetail where rightid =1865
/
delete from SystemRightsLanguage where id =1865
/
delete from SystemRights where id =1865
/
insert into SystemRights (id,rightdesc,righttype) values (1865,'Эͬ��ά��Ȩ��','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1865,7,'Эͬ��ά��Ȩ��','Эͬ��ά��Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1865,8,'Synergy Maintenance','Synergy Maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1865,9,'�fͬ�^�S�o����','�fͬ�^�S�o����') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43094,'Эͬ��ά��Ȩ��','Synergy:Maint',1865) 
/