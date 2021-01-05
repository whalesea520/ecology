
delete from SystemRights where id = 776
/
delete from SystemRightsLanguage where id = 776
/
delete from SystemRightDetail where id = 4286
/

insert into SystemRights (id,rightdesc,righttype) values (776,'人力资源卡片系统信息维护','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (776,7,'人力资源卡片系统信息维护','人力资源卡片系统信息维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (776,8,'ResourcesInformationSystem','ResourcesInformationSystem') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4286,'人力资源卡片系统信息维护','ResourcesInformationSystem:All',776) 
/