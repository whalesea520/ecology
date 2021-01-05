update workflow_billfield set type = 4 where billid in (select field002 from hrm_state_proc_set where field006 = 4) and fieldname = 'departmentid' and type = 167
/
