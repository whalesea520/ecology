truncate table hrm_att_proc_set
/
truncate table hrm_att_proc_relation
/
insert into hrm_att_proc_set(field001,field002,field003,field004,field005,field006,field007,field008,field009,field010,field011,field012,field013,field014,field015,mfid) select a.id as field001,a.formid as field002, 1 as field003, 0 as field004, 1 as field005, ( case when a.formid = 180 then '0' when a.formid = 181 then '1' when a.formid = 182 then '2' end ) as field006, 0 as field007, (select to_char(sysdate,'YYYY-MM-DD') from dual) as field008, (select to_char(sysdate,'YYYY-MM-DD') from dual) as field009, '' as field010, '' as field011, '' as field012, '' as field013, 0 as field014, 0 as field015, 0 as mfid from workflow_base a left join workflow_type b on a.workflowtype = b.id where a.formid between 180 and 182
/
insert into hrm_att_proc_relation(mfid,field001,field002,field003,field004) select 0 as mfid, a.id as field001, b.id as field002, b.field003 as field003, b.field002 as field004 from hrm_att_proc_set a left join hrm_att_proc_fields b on a.field002 = b.field001 where a.field002 between 180 and 182
/
truncate table hrmLeaveTypeColor
/
insert into hrmLeaveTypeColor(itemid,color,subcompanyid,field001,field002,field003,field004,field005) select field006 as itemid,field007 as color,0 as subcompanyid,field001,field002,field003,id as field004,field005 from Hrm_Leave_Type where id not in (3,4)
/
delete from Workflow_Selectitem where fieldid = (select id from workflow_billfield where billid = 45 and fieldname = 'otype')
/
delete from workflow_billfield where billid = 45 and fieldname = 'otype'
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,fromUser,dsporder) values(45,'otype','6159','char(8)',5,0,0,1,8)
/
insert into Workflow_Selectitem(fieldid,isbill,selectvalue,selectname,listorder,isdefault,isAccordToSubCom,cancel)values((select MAX(id) from workflow_billfield), 1, 1, '关联调休', 0, 'n', 0, '')
/
insert into Workflow_Selectitem(fieldid,isbill,selectvalue,selectname,listorder,isdefault,isAccordToSubCom,cancel)values((select MAX(id) from workflow_billfield), 1, 2, '不关联调休', 0, 'n', 0, '')
/