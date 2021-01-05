create sequence hrm_paid_leave_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_paid_leave (
	id number primary key not null,
	delflag int default((0)) not null,
	field001 number not null,
	field002 number not null,
	field003 varchar2(100) not null,
	field004 varchar2(100) not null,
	field005 varchar2(100) not null,
	field006 varchar2(100) not null,
	field007 int not null,
	field008 float not null,
	field009 float not null,
	field010 varchar2(100) not null,
	field011 float not null,
	field012 varchar2(1000) null
)
/
create or replace trigger hrm_paid_leave_tri before insert on hrm_paid_leave for each row begin select hrm_paid_leave_id.nextval into :new.id from dual; end;
/
delete from hrm_att_proc_action where field001 = 3 and field002 = 'HrmPaidLeaveAction'
/
insert into hrm_att_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (3, -1, 'HrmPaidLeaveAction', '126739', 1, -1, -1, 1, 1)
/