alter table docshare add  joblevel char(10)   DEFAULT '0'  not null
/
alter table docshare add  jobdepartment char(10)   DEFAULT '0' not null
/
alter table docshare add  jobsubcompany char(10)   DEFAULT '0' not null
/
alter table docshare add  jobids char(10)   DEFAULT '0'  not null
/

alter table shareinnerdoc add  joblevel char(10)   DEFAULT '0' not null
/
alter table shareinnerdoc add  jobdepartment char(10)  DEFAULT '0' not null 
/
alter table shareinnerdoc add  jobsubcompany char(10)   DEFAULT '0' not null
/


alter table ShareouterDoc add  joblevel char(10)   DEFAULT '0' not null
/
alter table ShareouterDoc add  jobdepartment char(10)   DEFAULT '0' not null
/
alter table ShareouterDoc add  jobsubcompany char(10)  DEFAULT '0' not null 
/
