alter table workflow_base add docCategory1 varchar2(200)
/
update workflow_base set docCategory1=docCategory
/
alter table workflow_base drop column docCategory
/
alter table workflow_base add docCategory varchar2(200)
/
update workflow_base set docCategory=docCategory1
/
alter table workflow_base drop column docCategory1
/