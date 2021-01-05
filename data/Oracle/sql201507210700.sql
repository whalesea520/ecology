delete from SystemRightDetail where rightid =1882
/
delete from SystemRightsLanguage where id =1882
/
delete from SystemRights where id =1882
/
insert into SystemRights (id,rightdesc,righttype) values (1882,'公共选择框维护','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1882,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1882,8,'Public choice frame maintenance','Public choice frame maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1882,7,'公共选择框维护','公共选择框维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1882,9,'公共選擇框維護','公共選擇框維護') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43113,'公共选择框维护','WORKFLOWPUBLICCHOICE:VIEW',1882) 
/