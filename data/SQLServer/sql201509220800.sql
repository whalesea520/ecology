delete from SystemRightDetail where rightid =1914
GO
delete from SystemRightsLanguage where id =1914
GO
delete from SystemRights where id =1914
GO
insert into SystemRights (id,rightdesc,righttype) values (1914,'ģ�������Ȩ','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,8,'Module management decentralization','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,9,'ģ�K�����֙�','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,7,'ģ�������Ȩ','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43140,'ģ�������Ȩ','HrmModuleManageDetach:Edit',1914) 
GO
 
delete from SystemRightDetail where rightid =1913
GO
delete from SystemRightsLanguage where id =1913
GO
delete from SystemRights where id =1913
GO
insert into SystemRights (id,rightdesc,righttype) values (1913,'���ܹ�����Ȩ','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,7,'���ܹ�����Ȩ','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,8,'Functional management empowerment','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,9,'���ܹ����x��','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43139,'���ܹ�����Ȩ','HrmEffectManageEmpower:Edit',1913) 
GO