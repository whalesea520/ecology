delete from SystemRightDetail where rightid =1510
GO
delete from SystemRightsLanguage where id =1510
GO
delete from SystemRights where id =1510
GO
insert into SystemRights (id,rightdesc,righttype) values (1510,'�ֲ��Զ�����Ϣά��','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1510,8,'Custom Segment information maintenance','Custom Segment information maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1510,7,'�ֲ��Զ�����Ϣά��','�ֲ��Զ�����Ϣά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1510,9,'�ֲ��Զ�����Ϣά��','�ֲ��Զ�����Ϣά��') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42757,'�ֲ��Զ�����Ϣά��','SubCompanyDefineInfo1:SubMaintain1',1510) 
GO


delete from SystemRightDetail where rightid =1511
GO
delete from SystemRightsLanguage where id =1511
GO
delete from SystemRights where id =1511
GO
insert into SystemRights (id,rightdesc,righttype) values (1511,'�����Զ�����Ϣά��','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1511,8,'Custom information maintenance department','Custom information maintenance department') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1511,7,'�����Զ�����Ϣά��','�����Զ�����Ϣά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1511,9,'�����Զ�����Ϣά��','�����Զ�����Ϣά��') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42758,'�����Զ�����Ϣά��','DeptDefineInfo1:DeptMaintain1',1511) 
GO