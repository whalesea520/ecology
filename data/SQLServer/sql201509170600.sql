delete from SystemRightDetail where rightid =1905
GO
delete from SystemRightsLanguage where id =1905
GO
delete from SystemRights where id =1905
GO
insert into SystemRights (id,rightdesc,righttype) values (1905,'���ñ�׼ά��','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1905,7,'���ñ�׼ά��','���ñ�׼ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1905,8,'Cost standard dimension','Cost standard dimension') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1905,9,'�M�ñ�ʾS��','�M�ñ�ʾS��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1905,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43132,'���ñ�׼ά��','CostStandardDimension:Set',1905) 
GO

delete from SystemRightDetail where rightid =1909
GO
delete from SystemRightsLanguage where id =1909
GO
delete from SystemRights where id =1909
GO
insert into SystemRights (id,rightdesc,righttype) values (1909,'���ñ�׼����','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1909,8,'Cost standard setting','Cost standard setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1909,9,'�M�ñ���O��','�M�ñ���O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1909,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1909,7,'���ñ�׼����','���ñ�׼����') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43136,'���ñ�׼����','CostStandardSetting:set',1909) 
GO

delete from SystemRightDetail where rightid =1911
GO
delete from SystemRightsLanguage where id =1911
GO
delete from SystemRights where id =1911
GO
insert into SystemRights (id,rightdesc,righttype) values (1911,'���ñ�׼����','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1911,7,'���ñ�׼����','���ñ�׼����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1911,9,'�M�ñ������','�M�ñ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1911,8,'Cost standard procedure','Cost standard procedure') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1911,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43138,'���ñ�׼����','CostStandardProcedure:edit',1911) 
GO