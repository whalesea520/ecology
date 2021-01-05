alter table AppFieldUI add fieldname varchar(60)
GO
update AppFieldUI set AppFieldUI.fieldname=workflow_billfield.fieldname from AppFieldUI,workflow_billfield where AppFieldUI.fieldid=workflow_billfield.id
GO