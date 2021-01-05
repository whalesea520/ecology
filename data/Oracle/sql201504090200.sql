delete from SystemRightDetail where rightid =1836
/
delete from SystemRightsLanguage where id =1836
/
delete from SystemRights where id =1836
/
insert into SystemRights (id,rightdesc,righttype,detachable) values (1836,'流程交换设置','5',1) 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1836,10,'Поток настройки 

коммутатора','Поток настройки коммутатора') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1836,7,'流程交换设置','流程交换设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1836,8,'Flow switch setting','Flow 

switch setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1836,9,'流程交換設置','流程交換設置') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43066,'流程交换设

置','WFEC:SETTING',1836) 
/

delete from SystemRightToGroup where rightid =1836
/
INSERT INTO SystemRightToGroup ( groupid, rightid ) VALUES  ( 8,1836)
/