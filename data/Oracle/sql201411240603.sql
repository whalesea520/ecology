update cus_formdict set fieldname='field'||id where fieldname='field'
/
update cus_formfield set  isuse='1' where scope='ProjCustomField' and isuse is null
/
alter table workflow_base add officalType int null
/
alter table ecology_pagesize add userid int not null
/