delete from SystemRightDetail where rightid =1769
GO
delete from SystemRightsLanguage where id =1769
GO
delete from SystemRights where id =1769
GO
insert into SystemRights (id,rightdesc,righttype) values (1769,'Ȩ�޲�ѯ','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,9,'���޲�ԃ','���޲�ԃ') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,8,'Query permissions','Query permissions') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,7,'Ȩ�޲�ѯ','Ȩ�޲�ѯ') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43004,'Ȩ�޲�ѯ','HrmRrightAuthority:search',1769) 
GO