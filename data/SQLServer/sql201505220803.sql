update hrm_att_proc_fields set field005 = 3, field006 = 34 where id = 3
GO
update hrm_att_proc_fields set field010 = 0 where id in (8, 9)
GO
delete from hrm_att_proc_fields where field001 = 180 and field002 in ('manager','vacationInfo')
GO