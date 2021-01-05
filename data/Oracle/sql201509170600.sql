delete from SystemRightDetail where rightid =1905
/
delete from SystemRightsLanguage where id =1905
/
delete from SystemRights where id =1905
/
insert into SystemRights (id,rightdesc,righttype) values (1905,'费用标准维度','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1905,7,'费用标准维度','费用标准维度') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1905,8,'Cost standard dimension','Cost standard dimension') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1905,9,'費用标準維度','費用标準維度') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1905,12,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43132,'费用标准维度','CostStandardDimension:Set',1905) 
/

delete from SystemRightDetail where rightid =1909
/
delete from SystemRightsLanguage where id =1909
/
delete from SystemRights where id =1909
/
insert into SystemRights (id,rightdesc,righttype) values (1909,'费用标准设置','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1909,8,'Cost standard setting','Cost standard setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1909,9,'費用标準設置','費用标準設置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1909,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1909,7,'费用标准设置','费用标准设置') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43136,'费用标准设置','CostStandardSetting:set',1909) 
/

delete from SystemRightDetail where rightid =1911
/
delete from SystemRightsLanguage where id =1911
/
delete from SystemRights where id =1911
/
insert into SystemRights (id,rightdesc,righttype) values (1911,'费用标准流程','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1911,7,'费用标准流程','费用标准流程') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1911,9,'費用标準流程','費用标準流程') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1911,8,'Cost standard procedure','Cost standard procedure') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1911,12,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43138,'费用标准流程','CostStandardProcedure:edit',1911) 
/