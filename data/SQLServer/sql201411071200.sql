delete from SystemRightDetail where rightid =1770
GO
delete from SystemRightsLanguage where id =1770
GO
delete from SystemRights where id =1770
GO
insert into SystemRights (id,rightdesc,righttype) values (1770,'�ʲ��Զ�����������','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,8,'Capital Customized Workflow Settings','Capital Customized Workflow Settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,7,'�ʲ��Զ�����������','�ʲ��Զ�����������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,9,'�Y�a�Զ��x����','�Y�a�Զ��x����') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41770,'�ʲ��Զ�����������Ȩ��','Cpt:CusWfConfig',1770) 
GO