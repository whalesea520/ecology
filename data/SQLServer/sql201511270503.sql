delete from workflow_browserurl where labelid = 125829
GO
delete from hrm_att_proc_fields where field001 = 5
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(38, 5, 'resourceId', '368', 'int', 3, 1, 0, '', 10.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(39, 5, 'scheduleResourceId', '125842', 'int', 3, 1, 0, '', 20.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(40, 5, 'fromDate', '125843', 'char(10)', 3, 2, 0, '', 30.00, 1)
GO
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(41, 5, 'toDate', '125844', 'char(10)', 3, 2, 0, '', 40.00, 1)
GO
DECLARE @id INT
SELECT  @id = MAX(id)+1 FROM workflow_browserurl
insert into workflow_browserurl(id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) values(@id, 125829, 'int','/systeminfo/BrowserMain.jsp?url=/hrm/schedule/hrmScheduleShiftsSet/browser.jsp','hrm_schedule_shifts_set_id','field002','id','',9,1,@id)
GO
DECLARE @id INT
SELECT  @id = min(id) from workflow_browserurl where labelid = 125829 group by labelid
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(42, 5, 'newShift', '125845', 'int', 3, @id, 0, '', 50.00, 1)
GO
delete from hrm_att_proc_action where mfid = 5
GO
insert into hrm_att_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values(5, -1, 'HrmScheduleShift', '2191,24803', 1, -1, -1, 1, 1)
GO

create table hrm_schedule_worktime (
	id bigint identity(1,1) not null primary key,
	delflag int not null,
	creater bigint not null,
	create_time varchar(100) not null,
	last_modifier bigint not null,
	last_modification_time varchar(100) not null,
	field001 varchar(100) not null,
	field002 varchar(100) not null,
	field003 varchar(100) not null,
	field004 int not null,
	field005 int not null,
	field006 varchar(1000),
	field007 decimal(5,1) not null
)
GO
create table hrm_schedule_shifts_set ( 
	id bigint not null primary key,
	delflag int not null,
	creater bigint not null,
	create_time varchar(100) not null,
	last_modifier bigint not null,
	last_modification_time varchar(100) not null,
	sn int not null,
	field001 varchar(100) not null,
	field002 int not null,
	field003 int not null,
	field004 int not null,
	field005 int not null,
	field006 int not null,
	field007 varchar(100) not null
)
GO
create table hrm_schedule_shifts_wt (
	id bigint identity(1,1) not null primary key,
	field001 bigint not null,
	field002 bigint not null,
	field003 bigint not null
)
GO
create table hrm_schedule_shifts_detail ( 
	id bigint identity(1,1) not null primary key,
	delflag int not null,
	mfid bigint not null,
	d001 int not null,
	d002 int not null,
	d003 int not null,
	d004 int not null,
	d005 int not null,
	d006 int not null,
	d007 int not null,
	d008 int not null,
	d009 int not null,
	d010 int not null,
	d011 int not null,
	d012 int not null,
	d013 int not null,
	d014 int not null,
	d015 int not null,
	d016 int not null,
	d017 int not null,
	d018 int not null,
	d019 int not null,
	d020 int not null,
	d021 int not null,
	d022 int not null,
	d023 int not null,
	d024 int not null,
	d025 int not null,
	d026 int not null,
	d027 int not null,
	d028 int not null,
	d029 int not null,
	d030 int not null,
	d031 int not null,
	w001 int not null,
	w002 int not null,
	w003 int not null,
	w004 int not null,
	w005 int not null,
	w006 int not null,
	w007 int not null,
	field001 bigint not null,
	field002 varchar(100) not null,
	field003 int not null,
	field004 int not null,
	field005 int not null
)
GO
create table hrm_schedule_personnel ( 
	id bigint identity(1,1) not null primary key,
	delflag int not null,
	creater bigint not null,
	create_time varchar(100) not null,
	last_modifier bigint not null,
	last_modification_time varchar(100) not null,
	sn int not null,
	field001 int not null,
	field002 varchar(1000),
	field003 int not null,
	field004 int not null,
	field005 int not null
)
GO
create table hrm_schedule_set ( 
	id bigint not null primary key,
	delflag int not null,
	creater bigint not null,
	create_time varchar(100) not null,
	last_modifier bigint not null,
	last_modification_time varchar(100) not null,
	sn int not null,
	field001 varchar(100) not null,
	field002 varchar(100) not null,
	field003 bigint not null,
	field004 int not null
)
GO
create table hrm_schedule_shifts_set_id ( 
	id int identity(1,1) not null primary key,
	field001 bigint not null,
	field002 varchar(100) not null
)
GO
create table hrm_schedule_set_person ( 
	id bigint identity(1,1) not null primary key,
	delflag int not null,
	field001 bigint not null,
	field002 int not null
)
GO
create table hrm_schedule_set_detail (
	id bigint identity(1,1) not null primary key,
	delflag int default(((0))) not null,
	field001 varchar(100) not null,
	field002 bigint not null,
	field003 varchar(100) not null,
	field004 int not null,
	field005 varchar(100) not null
)
GO