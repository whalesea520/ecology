delete from workflow_browserurl where labelid = 125829
/
delete from hrm_att_proc_fields where field001 = 5
/
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(38, 5, 'resourceId', '368', 'int', 3, 1, 0, '', 10.00, 1)
/
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(39, 5, 'scheduleResourceId', '125842', 'int', 3, 1, 0, '', 20.00, 1)
/
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(40, 5, 'fromDate', '125843', 'char(10)', 3, 2, 0, '', 30.00, 1)
/
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(41, 5, 'toDate', '125844', 'char(10)', 3, 2, 0, '', 40.00, 1)
/
insert into workflow_browserurl(id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) values((select MAX(id)+1 from workflow_browserurl),125829, 'int','/systeminfo/BrowserMain.jsp?url=/hrm/schedule/hrmScheduleShiftsSet/browser.jsp','hrm_schedule_shifts_set_id','field002','id','',9,1,(select MAX(id)+1 from workflow_browserurl))
/
insert into hrm_att_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(42, 5, 'newShift', '125845', 'int', 3, (select min(id) as id from workflow_browserurl where labelid = 125829 group by labelid), 0, '', 50.00, 1)
/
delete from hrm_att_proc_action where mfid = 5
/
insert into hrm_att_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values(5, -1, 'HrmScheduleShift', '2191,24803', 1, -1, -1, 1, 1)
/
create sequence hrm_schedule_worktime_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_schedule_worktime (
	id number not null primary key,
	delflag number not null,
	creater number not null,
	create_time varchar2(100) not null,
	last_modifier number not null,
	last_modification_time varchar2(100) not null,
	field001 varchar2(100) not null,
	field002 varchar2(100) not null,
	field003 varchar2(100) not null,
	field004 number not null,
	field005 number not null,
	field006 varchar2(1000),
	field007 number(5,1) not null
)
/
CREATE OR REPLACE TRIGGER hrm_schedule_wt_tri before insert on hrm_schedule_worktime for each row begin select hrm_schedule_worktime_id.nextval into :new.id from dual; end;
/
create table hrm_schedule_shifts_set ( 
	id number not null primary key,
	delflag number not null,
	creater number not null,
	create_time varchar2(100) not null,
	last_modifier number not null,
	last_modification_time varchar2(100) not null,
	sn number not null,
	field001 varchar2(100) not null,
	field002 number not null,
	field003 number not null,
	field004 number not null,
	field005 number not null,
	field006 number not null,
	field007 varchar2(100) not null
)
/
create sequence hrm_schedule_shifts_wt_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_schedule_shifts_wt (
	id number not null primary key,
	field001 number not null,
	field002 number not null,
	field003 number not null
)
/
CREATE OR REPLACE TRIGGER hrm_schedule_sfwt_tri before insert on hrm_schedule_shifts_wt for each row begin select hrm_schedule_shifts_wt_id.nextval into :new.id from dual; end;
/
create sequence hrm_schedule_shifts_set_id_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_schedule_shifts_set_id ( 
	id number not null primary key,
	field001 number not null,
	field002 varchar2(100) not null
)
/
CREATE OR REPLACE TRIGGER hrm_schedule_sfsi_tri before insert on hrm_schedule_shifts_set_id for each row begin select hrm_schedule_shifts_set_id_id.nextval into :new.id from dual; end;
/
create sequence hrm_schedule_shifts_detail_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_schedule_shifts_detail ( 
	id number not null primary key,
	delflag number not null,
	mfid number not null,
	d001 number not null,
	d002 number not null,
	d003 number not null,
	d004 number not null,
	d005 number not null,
	d006 number not null,
	d007 number not null,
	d008 number not null,
	d009 number not null,
	d010 number not null,
	d011 number not null,
	d012 number not null,
	d013 number not null,
	d014 number not null,
	d015 number not null,
	d016 number not null,
	d017 number not null,
	d018 number not null,
	d019 number not null,
	d020 number not null,
	d021 number not null,
	d022 number not null,
	d023 number not null,
	d024 number not null,
	d025 number not null,
	d026 number not null,
	d027 number not null,
	d028 number not null,
	d029 number not null,
	d030 number not null,
	d031 number not null,
	w001 number not null,
	w002 number not null,
	w003 number not null,
	w004 number not null,
	w005 number not null,
	w006 number not null,
	w007 number not null,
	field001 number not null,
	field002 varchar2(100) not null,
	field003 number not null,
	field004 number not null,
	field005 number not null
)
/
CREATE OR REPLACE TRIGGER hrm_schedule_sfd_tri before insert on hrm_schedule_shifts_detail for each row begin select hrm_schedule_shifts_detail_id.nextval into :new.id from dual; end;
/
create sequence hrm_schedule_personnel_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_schedule_personnel ( 
	id number not null primary key,
	delflag number not null,
	creater number not null,
	create_time varchar2(100) not null,
	last_modifier number not null,
	last_modification_time varchar2(100) not null,
	sn number not null,
	field001 number not null,
	field002 varchar2(1000),
	field003 number not null,
	field004 number not null,
	field005 number not null
)
/
CREATE OR REPLACE TRIGGER hrm_schedule_pl_tri before insert on hrm_schedule_personnel for each row begin select hrm_schedule_personnel_id.nextval into :new.id from dual; end;
/
create table hrm_schedule_set ( 
	id number not null primary key,
	delflag number not null,
	creater number not null,
	create_time varchar2(100) not null,
	last_modifier number not null,
	last_modification_time varchar2(100) not null,
	sn number not null,
	field001 varchar2(100) not null,
	field002 varchar2(100) not null,
	field003 number not null,
	field004 number not null
)
/
create sequence hrm_schedule_set_person_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_schedule_set_person ( 
	id number not null primary key,
	delflag number not null,
	field001 number not null,
	field002 number not null
)
/
CREATE OR REPLACE TRIGGER hrm_schedule_sp_tri before insert on hrm_schedule_set_person for each row begin select hrm_schedule_set_person_id.nextval into :new.id from dual; end;
/
create sequence hrm_schedule_set_detail_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_schedule_set_detail (
	id number not null primary key,
	delflag number default(((0))) not null,
	field001 varchar2(100) not null,
	field002 number not null,
	field003 varchar2(100) not null,
	field004 number not null,
	field005 varchar2(100) not null
)
/
CREATE OR REPLACE TRIGGER hrm_schedule_sd_tri before insert on hrm_schedule_set_detail for each row begin select hrm_schedule_set_detail_id.nextval into :new.id from dual; end;
/