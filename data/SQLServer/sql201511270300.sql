delete from SystemRightDetail where rightid =1919
GO
delete from SystemRightsLanguage where id =1919
GO
delete from SystemRights where id =1919
GO
insert into SystemRights (id,rightdesc,righttype) values (1919,'�Ű�����','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1919,7,'�Ű�����','�Ű�����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1919,9,'�Ű��O��','�Ű��O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1919,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1919,8,'Scheduling Settings','Scheduling Settings') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43145,'�Ű�����','HrmScheduling:set',1919) 
GO

delete from SystemRightDetail where rightid =1918
GO
delete from SystemRightsLanguage where id =1918
GO
delete from SystemRights where id =1918
GO
insert into SystemRights (id,rightdesc,righttype) values (1918,'�������','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1918,7,'�������','�������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1918,9,'����O��','����O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1918,8,'Shifts setting','Shifts setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1918,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43143,'�������','HrmSchedulingShifts:set',1918) 
GO

delete from SystemRightDetail where rightid =1917
GO
delete from SystemRightsLanguage where id =1917
GO
delete from SystemRights where id =1917
GO
insert into SystemRights (id,rightdesc,righttype) values (1917,'�Ű���Ա����','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1917,7,'�Ű���Ա����','�Ű���Ա����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1917,9,'�Ű��ˆT�O��','�Ű��ˆT�O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1917,8,'Scheduling personnel set up','Scheduling personnel set up') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1917,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43144,'�Ű���Ա����','HrmSchedulingPersonnel:set',1917) 
GO

delete from SystemRightDetail where rightid =1916
GO
delete from SystemRightsLanguage where id =1916
GO
delete from SystemRights where id =1916
GO
insert into SystemRights (id,rightdesc,righttype) values (1916,'����ʱ������','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1916,7,'����ʱ������','����ʱ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1916,9,'�����r���O��','�����r���O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1916,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1916,8,'Work time Settings','Work time Settings') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43142,'����ʱ������','HrmSchedulingWorkTime:set',1916) 
GO

delete from systemrighttogroup where groupid = 3 and rightid between 1916 and 1919
GO
insert into systemrighttogroup(groupid,rightid) values(3,1916)
GO
insert into systemrighttogroup(groupid,rightid) values(3,1917)
GO
insert into systemrighttogroup(groupid,rightid) values(3,1918)
GO
insert into systemrighttogroup(groupid,rightid) values(3,1919)
GO