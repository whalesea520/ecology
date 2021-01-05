update hrm_att_proc_fields set field003 = '6151,740' where id = 26
GO
update hrm_att_proc_fields set field003 = '6151,742' where id = 27
GO
update hrm_att_proc_fields set field003 = '6151,741' where id = 28
GO
update hrm_att_proc_fields set field003 = '6151,743' where id = 29
GO
update hrm_att_proc_fields set field002 = 'newLeaveType' where id = 3
GO
update hrm_att_proc_fields set field005 = 5, field006 = 0 where id = 30
GO
update hrm_att_proc_fields set field003 = '740' where id = 33
GO
update hrm_att_proc_fields set field003 = '742' where id = 34
GO
update hrm_att_proc_fields set field003 = '741' where id = 35
GO
update hrm_att_proc_fields set field003 = '743' where id = 36
GO
delete from hrm_att_proc_action where id > 3
GO
update hrm_att_proc_action set field007 = 1
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,fromUser,dsporder) values(180,'newLeaveType','1881','int',3,34,0,1,2)
GO