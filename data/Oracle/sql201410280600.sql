DELETE from systemrighttogroup where (GROUPid=1 and RIGHTid=1766)
/
insert into systemrighttogroup (GROUPid, RIGHTid) values (1, 1766)
/
delete from SystemRightDetail where rightid =1766
/
delete from SystemRightsLanguage where id =1766
/
delete from SystemRights where id =1766
/
insert into SystemRights (id,rightdesc,righttype) values (1766,'��ǩά��','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,7,'��ǩά��','��ǩά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,8,'Label Manage','��ǩά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1766,9,'�˻`�S�o','��ǩά��') 
/
delete from SystemRightDetail where id=42995
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42995,'��ǩά��','System:LabelManage',1766) 
/