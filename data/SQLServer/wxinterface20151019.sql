delete from SystemRightDetail where rightid =1929
GO
delete from SystemRightsLanguage where id =1929
GO
delete from SystemRights where id =1929
GO
insert into SystemRights (id,rightdesc,righttype) values (1929,'����΢��Ȩ��','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1929,7,'΢��Ⱥ����ϢȨ��','΢��Ⱥ����ϢȨ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1929,9,'΢��Ⱥ�l��Ϣ����','΢��Ⱥ�l��Ϣ����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1929,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1929,8,'WX_SENDALL_RIGHT','WX_SENDALL_RIGHT') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43150,'΢��Ⱥ����ϢȨ��','WX_SENDALL_RIGHT',1929) 
GO