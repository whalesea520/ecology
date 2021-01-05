delete from workflow_billfield where billid = 180 and fieldname = 'vacationInfo'
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,fromUser,dsporder) values(180,'vacationInfo','25842','varchar(500)',2,0,0,1,15)
GO
update hrm_att_proc_fields set field002 = 'vacationInfo' where field001 = 180 and id = 9
GO
update hrm_att_proc_relation set field004 = 'vacationInfo' where field003 = 25842
GO
alter table Bill_BoHaiLeave add vacationInfo varchar(500)
GO