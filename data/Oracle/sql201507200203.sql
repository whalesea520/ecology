update hrm_state_proc_fields set field006 = (select min(id) as id from workflow_browserurl where labelid = 614 group by labelid) where field002 = 'docid' and field001 = 41
/
update hrm_state_proc_fields set field010 = 0 where field002 = 'accounttype' and field001 = 0
/
update hrm_state_proc_fields set field006 = 1 where field002 = 'status' and field001 = 3
/