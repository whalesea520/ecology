alter table AppFieldUI add fieldname varchar2(60)
/
update AppFieldUI set (fieldname)=(select fieldname from workflow_billfield where AppFieldUI.fieldid=workflow_billfield.id)
/