delete from SystemRightDetail where rightid =806
/
delete from SystemRightsLanguage where id =806
/
delete from SystemRights where id =806
/
delete from SystemRightDetail where rightid =1827
/
delete from SystemRightsLanguage where id =1827
/
delete from SystemRights where id =1827
/
insert into SystemRights (id,rightdesc,righttype) values (1827,'ϵͳ��Ϣ����ά��','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,7,'ϵͳ��Ϣ����ά��','ϵͳ��Ϣ����ά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,10,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,8,'HrmResourceSys','HrmResourceSys') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,9,'ϵ�y��Ϣ�����S�o','ϵ�y��Ϣ�����S�o') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43059,'ϵͳ��Ϣ����ά��','HrmResourceSys:Mgr',1827) 
/