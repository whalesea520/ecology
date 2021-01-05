alter table workflow_flownode add isfeedback char(1)
/
update workflow_flownode set isfeedback='1'
/
