DELETE from systemrighttogroup where (GROUPid=1 and RIGHTid=1766)
GO
insert into systemrighttogroup (GROUPid, RIGHTid) values (1, 1766)
GO
delete from SystemRightDetail where rightid =1766
GO
delete from SystemRightsLanguage where id =1766
GO
delete from SystemRights where id =1766
GO
insert into SystemRights (id,rightdesc,righttype) values (1766,'��ǩά��','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,7,'��ǩά��','��ǩά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,8,'Label Manage','��ǩά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,9,'�˻`�S�o','��ǩά��') 
GO
delete from SystemRightDetail where id=42995
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42995,'��ǩά��','System:LabelManage',1766) 
GO