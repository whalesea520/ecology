delete from SystemRightDetail where rightid =1770
/
delete from SystemRightsLanguage where id =1770
/
delete from SystemRights where id =1770
/
insert into SystemRights (id,rightdesc,righttype) values (1770,'�ʲ��Զ�����������','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,8,'Capital Customized Workflow Settings','Capital Customized Workflow Settings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,7,'�ʲ��Զ�����������','�ʲ��Զ�����������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,9,'�Y�a�Զ��x����','�Y�a�Զ��x����') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41770,'�ʲ��Զ�����������Ȩ��','Cpt:CusWfConfig',1770) 
/