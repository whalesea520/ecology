delete from Workflow_Selectitem where fieldid = 655 and selectname = '调休'
/
delete from Workflow_Selectitem where fieldid = (select id from workflow_billfield where billid = 0 and fieldname = 'otherLeaveType') and selectname = '调休'
/
insert into workflow_selectitem(fieldid, isbill, selectvalue, selectname, listorder, isdefault,isAccordToSubCom,cancel) values((select id from workflow_billfield where billid = 0 and fieldname = 'otherLeaveType'), 1, 13, '调休', 13.00, 'n', 0, '')
/
truncate table hrm_leave_type
/
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) select selectname as field001, 1 as field002, 0 as field003, selectvalue as field004, (case when fieldid = (select id from workflow_billfield where billid = 0 and fieldname = 'leaveType') then 'leaveType' else 'otherLeaveType' end) as field005, id as field006, '#FF0000' as field007, 7 as field008 from workflow_SelectItem where fieldid in (select id from workflow_billfield where billid = 0 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType'))
/
update hrm_leave_type set field003 = 1 where field001 in ('事假','病假','年假','带薪病假')
/
update hrm_leave_type set field002 = 0 where field001 in ('儿童陪护假')
/
truncate table hrmLeaveTypeColor
/
insert into hrmLeaveTypeColor(itemid,color,subcompanyid,field001,field002,field003,field004,field005) select field006 as itemid,field007 as color,0 as subcompanyid,field001,field002,field003,id as field004,field005 from Hrm_Leave_Type where field001 not in ('其它带薪假','其它非带薪假')
/
update hrmLeaveTypeColor set field006 = field004
/
update hrmLeaveTypeColor set field004 = -6 where field001 = '年假'
/
update hrmLeaveTypeColor set field004 = -12 where field001 = '带薪病假'
/
update hrmLeaveTypeColor set field004 = -13 where field001 = '调休'
/
update Bill_BoHaiLeave set newLeaveType = (case when leaveType between 1 and 3 then (select id from hrm_leave_type where field004 = leaveType and field005 = 'leaveType') else (select id from hrm_leave_type where field004 = otherLeaveType and field005 = 'otherLeaveType') end) where ((leaveType between 1 and 4) or (otherLeaveType is not null or otherLeaveType != ''))
/
update Bill_BoHaiLeave set newLeaveType = -6 where newLeaveType = (select id from hrm_leave_type where field001 = '年假')
/
update Bill_BoHaiLeave set newLeaveType = -12 where newLeaveType = (select id from hrm_leave_type where field001 = '带薪病假')
/
update Bill_BoHaiLeave set newLeaveType = -13 where newLeaveType = (select id from hrm_leave_type where field001 = '调休')
/
update HrmAnnualLeaveInfo set leaveType = (case when leaveType between 1 and 3 then (select id from hrm_leave_type where field004 = leaveType and field005 = 'leaveType') else (select id from hrm_leave_type where field004 = otherLeaveType and field005 = 'otherLeaveType') end) where ((leaveType between 1 and 4) or (otherLeaveType !=0))
/
update HrmAnnualLeaveInfo set leaveType = -6 where leaveType = (select id from hrm_leave_type where field001 = '年假')
/
update HrmAnnualLeaveInfo set leaveType = -12 where leaveType = (select id from hrm_leave_type where field001 = '带薪病假')
/
update HrmAnnualLeaveInfo set leaveType = -13 where leaveType = (select id from hrm_leave_type where field001 = '调休')
/