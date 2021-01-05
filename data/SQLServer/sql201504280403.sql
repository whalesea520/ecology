create table hrm_att_proc_set (
	id bigint IDENTITY(1,1) NOT NULL primary key,
	field001 int not null,
	field002 int not null,
	field003 int not null,
	field004 int,
	field005 int not null,
	field006 int not null,
	field007 int not null,
	field008 varchar(50) not null,
	field009 varchar(50),
	field010 varchar(1000),
	field011 varchar(1000),
	field012 varchar(100),
	field013 varchar(100),
	field014 int,
	field015 int,
	mfid bigint not null
)
GO
create table hrm_att_proc_relation (
	id bigint IDENTITY(1,1) NOT NULL primary key,
	mfid bigint not null,
	field001 int not null,
	field002 int not null,
	field003 int not null,
	field004 varchar(100) not null
)
GO
create table hrm_att_proc_action (
	id bigint IDENTITY(1,1) NOT NULL primary key,
	mfid bigint not null,
	field001 bigint not null,
	field002 varchar(50) not null,
	field003 varchar(50) not null,
	field004 int not null,
	field005 int not null,
	field006 int not null,
	field007 int not null,
	field008 int not null
)
GO
insert into hrm_att_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'deduction', '82823,25842', 1, -1, -1, -1, 1)
GO
insert into hrm_att_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'freeze', '1232,25842', 1, -1, -1, -1, 2)
GO
insert into hrm_att_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'release', '82824,25842', 1, -1, -1, -1, 3)
GO
create table hrm_att_proc_fields (
	id bigint IDENTITY(1,1) NOT NULL primary key,
	mfid bigint not null,
	field001 int not null,
	field002 varchar(100) not null,
	field003 varchar(100) not null,
	field004 varchar(50) not null,
	field005 int not null,
	field006 int not null,
	field007 int not null,
	field008 varchar(100),
	field009 decimal(10,2) not null,
	field010 int not null
)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(1, 180, 'resourceId', '413', 'int', 3, 1, 0, '', 10.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(2, 180, 'departmentId', '124', 'int', 3, 4, 0, '', 20.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(3, 180, 'leaveType', '1881', 'int', 5, 0, 0, '', 30.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(4, 180, 'fromDate', '1322', 'char(10)', 3, 2, 0, '', 40.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(5, 180, 'fromTime', '17690', 'char(8)', 3, 19, 0, '', 50.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(6, 180, 'toDate', '741', 'char(10)', 3, 2, 0, '', 60.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(7, 180, 'toTime', '743', 'char(8)', 3, 19, 0, '', 70.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(8, 180, 'leaveDays', '828', 'decimal(15,2)', 1, 3, 0, '', 80.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(9, 180, 'vacationInfo', '25842', 'varchar(500)', 2, 0, 0, '', 90.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(10, 180, 'manager', '144', 'int', 3, 1, 0, '', 100.00, 0)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(11, 180, 'leaveReason', '20054', 'varchar(500)', 2, 0, 0, '', 110.00, 0)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(12, 181, 'resourceId', '413', 'int', 3, 1, 0, '', 10.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(13, 181, 'departmentId', '18939', 'int', 3, 4, 0, '', 20.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(14, 181, 'fromDate', '1322', 'char(10)', 3, 2, 0, '', 30.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(15, 181, 'fromTime', '17690', 'char(8)', 3, 19, 0, '', 40.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(16, 181, 'toDate', '741', 'char(10)', 3, 2, 0, '', 50.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(17, 181, 'toTime', '743', 'char(8)', 3, 19, 0, '', 60.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(18, 182, 'resourceId', '413', 'int', 3, 1, 0, '', 10.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(19, 182, 'departmentId', '18939', 'int', 3, 4, 0, '', 20.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(20, 182, 'fromDate', '20058', 'char(10)', 3, 2, 0, '', 30.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(21, 182, 'fromTime', '20059', 'char(8)', 3, 19, 0, '', 40.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(22, 182, 'toDate', '20060', 'char(10)', 3, 2, 0, '', 50.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(23, 182, 'toTime', '20061', 'char(8)', 3, 19, 0, '', 60.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(24, 161, 'resourceId', '413', 'int', 3, 1, 0, '', 10.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(25, 161, 'departmentId', '124', 'int', 3, 4, 0, '', 20.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(26, 161, 'fromdate', '18834', 'char(10)', 3, 2, 0, '', 30.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(27, 161, 'fromtime', '18835', 'char(8)', 3, 19, 0, '', 40.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(28, 161, 'tilldate', '18836', 'char(10)', 3, 2, 0, '', 50.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(29, 161, 'tilltime', '18837', 'char(8)', 3, 19, 0, '', 60.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(30, 161, 'otype', '6159', 'char(8)', 2, 0, 0, '', 70.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(31, 0, 'resourceId', '413', 'int', 3, 1, 0, '', 10.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(32, 0, 'departmentId', '124', 'int', 3, 4, 0, '', 20.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(33, 0, 'fromDate', '1322', 'char(10)', 3, 2, 0, '', 30.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(34, 0, 'fromTime', '17690', 'char(8)', 3, 19, 0, '', 40.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(35, 0, 'toDate', '741', 'char(10)', 3, 2, 0, '', 50.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(36, 0, 'toTime', '743', 'char(8)', 3, 19, 0, '', 60.00, 1)
GO