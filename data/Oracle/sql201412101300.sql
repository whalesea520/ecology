delete from SystemRightDetail where rightid =1748
/
delete from SystemRightsLanguage where id =1748
/
delete from SystemRights where id =1748
/
insert into SystemRights (id,rightdesc,righttype) values (1748,'流程应用设置','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1748,8,'workflow application setting','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1748,7,'流程应用设置','可以通过配置快捷的配置流程的超时、反馈等') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1748,9,'流程應用設置','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43018,'流程应用设置','WorkflowManage:PsSet',1748) 
/
DELETE from systemrighttogroup where (GROUPid=8 and RIGHTid=1748) 
/
insert into systemrighttogroup (GROUPid, RIGHTid) values (8, 1748)
/