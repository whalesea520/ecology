alter table workflow_base add ShowDelButtonByReject char(1)
/
update workflow_base set ShowDelButtonByReject='1'
/
