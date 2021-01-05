update hrm_att_proc_fields set field002 = 'leaveReason', field003 = '25842' where id = 9
/
update hrm_att_proc_fields set field002 = 'vacationInfo', field003 = '20054' where id = 11
/
insert into hrm_att_proc_set(field001,field002,field003,field004,field005,field006,field007,field008,field009,field010,field011,field012,field013,field014,field015,mfid) select a.id as field001,a.formid as field002, 1 as field003, 0 as field004, 1 as field005, ( case when a.formid = 180 then '0' when a.formid = 181 then '1' when a.formid = 182 then '2' end ) as field006, 0 as field007, (select to_char(sysdate,'YYYY-MM-DD') from dual) as field008, (select to_char(sysdate,'YYYY-MM-DD') from dual) as field009, '' as field010, '' as field011, '' as field012, '' as field013, 0 as field014, 0 as field015, 0 as mfid from workflow_base a left join workflow_type b on a.workflowtype = b.id where a.formid between 180 and 182
/
insert into hrm_att_proc_relation(mfid,field001,field002,field003,field004) select 0 as mfid, a.id as field001, b.id as field002, b.field003 as field003, b.field002 as field004 from hrm_att_proc_set a left join hrm_att_proc_fields b on a.field002 = b.field001 where a.field002 between 180 and 182
/