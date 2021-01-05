delete from SystemRightDetail where rightid =1919
GO
delete from SystemRightsLanguage where id =1919
GO
delete from SystemRights where id =1919
GO
insert into SystemRights (id,rightdesc,righttype) values (1919,'排班设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1919,7,'排班设置','排班设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1919,9,'排班設置','排班設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1919,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1919,8,'Scheduling Settings','Scheduling Settings') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43145,'排班设置','HrmScheduling:set',1919) 
GO

delete from SystemRightDetail where rightid =1918
GO
delete from SystemRightsLanguage where id =1918
GO
delete from SystemRights where id =1918
GO
insert into SystemRights (id,rightdesc,righttype) values (1918,'班次设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1918,7,'班次设置','班次设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1918,9,'班次設置','班次設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1918,8,'Shifts setting','Shifts setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1918,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43143,'班次设置','HrmSchedulingShifts:set',1918) 
GO

delete from SystemRightDetail where rightid =1917
GO
delete from SystemRightsLanguage where id =1917
GO
delete from SystemRights where id =1917
GO
insert into SystemRights (id,rightdesc,righttype) values (1917,'排班人员设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1917,7,'排班人员设置','排班人员设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1917,9,'排班人員設置','排班人員設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1917,8,'Scheduling personnel set up','Scheduling personnel set up') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1917,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43144,'排班人员设置','HrmSchedulingPersonnel:set',1917) 
GO

delete from SystemRightDetail where rightid =1916
GO
delete from SystemRightsLanguage where id =1916
GO
delete from SystemRights where id =1916
GO
insert into SystemRights (id,rightdesc,righttype) values (1916,'工作时段设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1916,7,'工作时段设置','工作时段设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1916,9,'工作時段設置','工作時段設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1916,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1916,8,'Work time Settings','Work time Settings') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43142,'工作时段设置','HrmSchedulingWorkTime:set',1916) 
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