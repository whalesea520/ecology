delete from SystemRights where id=780 
/
delete from SystemRightsLanguage where id=780 
/
delete from SystemRightDetail where id=4290 
/
insert into SystemRights (id,rightdesc,righttype) values (780,'工作流分权人力资源','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (780,7,'工作流分权人力资源','工作流分权人力资源') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (780,8,'Workflow decentralization of resources','Workflow decentralization of resources') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4290,'工作流分权人力资源','Resources:decentralization',780) 
/
delete from SystemRights where id=781 
/
delete from SystemRightsLanguage where id=781 
/
delete from SystemRightDetail where id=4291 
/
insert into SystemRights (id,rightdesc,righttype) values (781,'工作流分权部门','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (781,7,'工作流分权部门','工作流分权部门') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (781,8,'Workflow decentralization of departments','Workflow decentralization of departments') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4291,'工作流分权部门','Departments:decentralization',781) 
/
delete from SystemRights where id=782 
/
delete from SystemRightsLanguage where id=782 
/
delete from SystemRightDetail where id=4292 
/
insert into SystemRights (id,rightdesc,righttype) values (782,'工作流分权分部','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (782,7,'工作流分权分部','工作流分权分部') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (782,8,'Workflow decentralization of subcompanys','Workflow decentralization of subcompanys') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4292,'工作流分权分部','Subcompanys:decentralization',782) 
/