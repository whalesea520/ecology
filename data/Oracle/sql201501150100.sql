delete from SystemRightDetail where rightid =56
/
delete from SystemRightsLanguage where id =56
/
delete from SystemRights where id =56
/
insert into SystemRights (id,rightdesc,righttype) values (56,'��Ŀ״̬ά��','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (56,7,'��Ŀ״̬ά��','��Ŀ״̬�����ӣ�ɾ�������º���־�鿴') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (56,8,'ProjectStatus Maintenance','Add,delete,update and log ProjectStatus') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (202,'��Ŀ״̬����','AddProjectStatus:Add',56) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (203,'��Ŀ״̬�༭','EditProjectStatus:Edit',56) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (204,'��Ŀ״̬ɾ��','EditProjectStatus:Delete',56) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (205,'��Ŀ״̬��־�鿴','ProjectStatus:Log',56) 
/
delete from SystemRightsLanguage where id =1811
/
delete from SystemRights where id =1811
/
insert into SystemRights (id,rightdesc,righttype) values (1811,'��Ŀ��������','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1811,10,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1811,9,'�Ŀ�����O��','�Ŀ�����O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1811,7,'��Ŀ��������','��Ŀ��������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1811,8,'Project Workflow Settings','Project Workflow Settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41811,'��Ŀ��������Ȩ��','Prj:WorkflowSetting',1811) 
/