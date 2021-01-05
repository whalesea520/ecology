alter table workflow_DataInput_entry  add 
type char(1)
/

update workflow_DataInput_entry set type='0'
/
