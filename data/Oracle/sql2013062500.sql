delete from SystemRightDetail where rightid =1510
/
delete from SystemRightsLanguage where id =1510
/
delete from SystemRights where id =1510
/
insert into SystemRights (id,rightdesc,righttype) values (1510,'�ֲ��Զ�����Ϣά��','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1510,8,'Custom Segment information maintenance','Custom Segment information maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1510,7,'�ֲ��Զ�����Ϣά��','�ֲ��Զ�����Ϣά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1510,9,'�ֲ��Զ�����Ϣά��','�ֲ��Զ�����Ϣά��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42757,'�ֲ��Զ�����Ϣά��','SubCompanyDefineInfo1:SubMaintain1',1510) 
/

delete from SystemRightDetail where rightid =1511
/
delete from SystemRightsLanguage where id =1511
/
delete from SystemRights where id =1511
/
insert into SystemRights (id,rightdesc,righttype) values (1511,'�����Զ�����Ϣά��','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1511,8,'Custom information maintenance department','Custom information maintenance department') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1511,7,'�����Զ�����Ϣά��','�����Զ�����Ϣά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1511,9,'�����Զ�����Ϣά��','�����Զ�����Ϣά��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42758,'�����Զ�����Ϣά��','DeptDefineInfo1:DeptMaintain1',1511) 
/