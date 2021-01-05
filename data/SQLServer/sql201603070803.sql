create table hrm_paid_leave (
	id bigint identity(1,1) primary key not null,
	delflag int default((0)) not null,
	field001 bigint not null,
	field002 bigint not null,
	field003 varchar(100) not null,
	field004 varchar(100) not null,
	field005 varchar(100) not null,
	field006 varchar(100) not null,
	field007 int not null,
	field008 float not null,
	field009 float not null,
	field010 varchar(100) not null,
	field011 float not null,
	field012 varchar(1000) null
)
GO
delete from hrm_att_proc_action where field001 = 3 and field002 = 'HrmPaidLeaveAction'
GO
insert into hrm_att_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (3, -1, 'HrmPaidLeaveAction', '126739', 1, -1, -1, 1, 1)
GO