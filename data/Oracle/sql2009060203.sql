alter table workflow_docshow add dateShowType char(1)  default '0'
/
update workflow_docshow set  dateShowType='0'
/
