delete from workflow_billfield where billid = 180 and fieldname = 'vacationInfo'
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,fromUser,dsporder) values(180,'vacationInfo','25842','varchar2(500)',2,0,0,1,15)
/
update hrm_att_proc_fields set field002 = 'vacationInfo' where field001 = 180 and id = 9
/
update hrm_att_proc_relation set field004 = 'vacationInfo' where field003 = 25842
/
alter table Bill_BoHaiLeave add vacationInfo varchar2(500)
/