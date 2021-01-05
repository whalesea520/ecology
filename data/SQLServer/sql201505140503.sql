truncate table hrmleavetypecolor
GO
truncate table hrm_leave_type
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) select selectname as field001, 1 as field002, 0 as field003, selectvalue as field004, (case when fieldid = (select id from workflow_billfield where billid = 180 and fieldname = 'leaveType') then 'leaveType' else 'otherLeaveType' end) as field005, id as field006, '#FF0000' as field007, 7 as field008 from workflow_SelectItem where fieldid in (select id from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType'))
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('µ÷ÐÝ',1,1,1001,'otherLeaveType',100001,'#FF0000', 7)
GO
update hrm_leave_type set field003 = 1 where field001 in ('ÊÂ¼Ù','²¡¼Ù','Äê¼Ù','´øÐ½²¡¼Ù')
GO
update hrm_leave_type set field002 = 0 where field001 in ('¶ùÍ¯Åã»¤¼Ù')
GO
alter table Bill_BoHaiLeave add newLeaveType int
GO
update Bill_BoHaiLeave set newLeaveType = (case when leaveType between 1 and 3 then (select id from hrm_leave_type where field004 = leaveType and field005 = 'leaveType') else (select id from hrm_leave_type where field004 = otherLeaveType and field005 = 'otherLeaveType') end) where ((leaveType between 1 and 4) or (otherLeaveType is not null or otherLeaveType != ''))
GO