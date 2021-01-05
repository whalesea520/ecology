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
insert into SystemRights (id,rightdesc,righttype) values (1766,'标签维护','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,7,'标签维护','标签维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,8,'Label Manage','标签维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,9,'標籤維護','标签维护') 
GO
delete from SystemRightDetail where id=42995
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42995,'标签维护','System:LabelManage',1766) 
GO