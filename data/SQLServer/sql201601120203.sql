update hrm_state_proc_fields set field006 = (select id from workflow_browserurl where tablename = 'HrmContract' and columname = 'contractname') where field001 = 3 and field002 = 'changecontractid'
GO
