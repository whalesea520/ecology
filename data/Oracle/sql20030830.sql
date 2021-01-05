insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (370,7,'培训规划维护','培训规划添加，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (370,8,'','')
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (371,7,'培训安排维护','培训安排添加，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (371,8,'','')
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (372,7,'培训资源维护','培训资源添加，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (372,8,'','')
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (373,7,'培训活动维护','培训活动添加，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (373,8,'','')
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (374,7,'用工需求维护','用工需求添加，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (374,8,'','')
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (375,7,'招聘计划维护','招聘计划添加，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (375,8,'','')
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (381,7,'考勤维护','考勤维护添加，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (381,8,'','')
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (383,7,'合同种类维护','合同种类添加，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (383,8,'','')
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (384,7,'合同维护','合同添加，编辑，删除')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (384,8,'','')
/

insert into SystemRights (id,rightdesc,righttype) values (385,'CRM调查维护','0')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3051,'CRM调查维护','DataCenter:Maintenance',385)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (385,7,'CRM调查维护','CRM调查维护')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (385,8,'','')
/
insert into SystemRightToGroup (groupid,rightid) values (6,385)
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (385,8,'1')
/


insert into SystemRights (id,rightdesc,righttype) values (386,'人力资源考核种类维护','3')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3052,'人力资源考核种类新建','HrmCheckKindAdd:Add',386)
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3053,'人力资源考核种类编辑','HrmCheckKindEdit:Edit',386)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (386,7,'人力资源考核种类维护','人力资源考核种类新建，编辑和删除')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (386,8,'','')
/
insert into SystemRightToGroup (groupid,rightid) values (3,386)
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (386,4,'2')
/

insert into SystemRights (id,rightdesc,righttype) values (387,'人力资源考核项目维护','3')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3054,'人力资源考核项目新建','HrmCheckItemAdd:Add',387)
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3055,'人力资源考核项目编辑','HrmCheckItemEdit:Edit',387)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,7,'人力资源考核项目维护','人力资源考核项目新建，编辑和删除')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,8,'','')
/
insert into SystemRightToGroup (groupid,rightid) values (3,387)
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (387,4,'2')
/


update workflow_groupdetail set objid = 5 where groupid = 2 
/

insert into SystemRights (id,rightdesc,righttype) values (388,'人力资源考核实施维护','3')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3056,'人力资源考核实施维护','HrmCheckInfo:Maintenance',388)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (388,7,'人力资源考核实施维护','人力资源考核实施维护')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (388,8,'','')
/
insert into SystemRightToGroup (groupid,rightid) values (3,388)
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (388,4,'2')
/


insert into SystemRights (id,rightdesc,righttype) values (389,'邮件模板维护','3')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3057,'邮件模板新建','DocMailMouldEdit:add',389)
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3058,'邮件模板新建','DocMailMouldAdd:add',389)
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3059,'邮件模板编辑','DocMailMouldEdit:Edit',389)
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3060,'邮件模板删除','DocMailMouldEdit:Delete',389)
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3061,'邮件模板日志查看','DocMailMould:log',389)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (389,7,'邮件模板维护','邮件模板新建，编辑，删除和日志查看')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (389,8,'','')
/
insert into SystemRightToGroup (groupid,rightid) values (2,389)
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (389,3,'2')
/
