
delete from SystemRightDetail where rightid =1560
/
delete from SystemRightsLanguage where id =1560
/
delete from SystemRights where id =1560
/
insert into SystemRights (id,rightdesc,righttype) values (1560,'����ͼ����','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1560,9,'���؈D�O��','���؈D�O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1560,8,'Gantt Setting','Gantt Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1560,7,'����ͼ����','����ͼ����') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (50001,'����ͼ����Ȩ��','Pm:GanttSetting',1560) 
/
insert into SystemRightToGroup (groupid,rightid) values (5,1560) 
/


