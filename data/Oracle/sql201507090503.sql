create sequence hrm_state_proc_set_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_state_proc_set (
  id number NOT NULL primary key,
  field001 number not null,
  field002 number not null,
  field003 number not null,
  field004 number,
  field005 number not null,
  field006 number not null,
  field007 number not null,
  field008 varchar2(50) not null,
  field009 varchar2(50),
  field010 varchar2(1000),
  field011 varchar2(1000),
  field012 varchar2(100),
  field013 varchar2(100),
  field014 number,
  field015 number,
  mfid number not null
)
/
CREATE OR REPLACE TRIGGER hrm_st_pc_set_Trigger before insert on hrm_state_proc_set for each row begin select hrm_state_proc_set_id.nextval into :new.id from dual; end;
/
create sequence hrm_state_proc_fields_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_state_proc_fields (
  id number NOT NULL primary key,
  mfid number not null,
  field001 number not null,
  field002 varchar2(100) not null,
  field003 varchar2(100) not null,
  field004 varchar2(50) not null,
  field005 number not null,
  field006 number not null,
  field007 number not null,
  field008 varchar2(100),
  field009 number(10,2) not null,
  field010 number not null
)
/
CREATE OR REPLACE TRIGGER hrm_st_pc_fields_Trigger before insert on hrm_state_proc_fields for each row begin select hrm_state_proc_fields_id.nextval into :new.id from dual; end;
/
create sequence hrm_state_proc_relation_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_state_proc_relation (
  id number NOT NULL primary key,
  mfid number not null,
  field001 number not null,
  field002 number not null,
  field003 number not null,
  field004 varchar2(100) not null
)
/
CREATE OR REPLACE TRIGGER hrm_st_pc_relation_Trigger before insert on hrm_state_proc_relation for each row begin select hrm_state_proc_relation_id.nextval into :new.id from dual; end;
/
create sequence hrm_state_proc_action_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_state_proc_action (
  id number NOT NULL primary key,
  mfid number not null,
  field001 number not null,
  field002 varchar2(50) not null,
  field003 varchar2(50) not null,
  field004 number not null,
  field005 number not null,
  field006 number not null,
  field007 number not null,
  field008 number not null
)
/
CREATE OR REPLACE TRIGGER hrm_st_pc_action_Trigger before insert on hrm_state_proc_action for each row begin select hrm_state_proc_action_id.nextval into :new.id from dual; end;
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceEntrant', '16465', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceTry', '17513', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceHire', '16466', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceExtend', '16467', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceRedeploy', '16468', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceDismiss', '16469', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceRetire', '16470', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceFire', '16472', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_action(mfid, field001, field002, field003, field004, field005, field006, field007, field008) values (0, -1, 'HrmResourceReHire', '16471', 1, -1, -1, 1, 1)
/
insert into hrm_state_proc_set(field001,field002,field003,field004,field005,field006,field007,field008,field009,field010,field011,field012,field013,field014,field015,mfid) select a.id as field001,a.formid as field002, 1 as field003, 0 as field004, 1 as field005, ( case when a.formid = 40 then '4' when a.formid = 41 then '5' when a.formid = 42 then '2' end ) as field006, 0 as field007, (select to_char(sysdate,'YYYY-MM-DD') from dual) as field008, (select to_char(sysdate,'YYYY-MM-DD') from dual) as field009, '' as field010, '' as field011, '' as field012, '' as field013, 0 as field014, 0 as field015, 0 as mfid from workflow_base a left join workflow_type b on a.workflowtype = b.id where a.formid between 40 and 42
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) select 0 as mfid, billid as field001, fieldname as field002, fieldlabel as field003, fielddbtype as field004,fieldhtmltype as field005, type as field006, viewtype as field007, detailtable as field008, dsporder * 10 as field009, 1 as field010 from workflow_billfield where billid between 40 and 42 and fromuser = 1 order by billid,id
/
insert into hrm_state_proc_relation(mfid,field001,field002,field003,field004) select 0 as mfid, a.id as field001, b.id as field002, b.field003 as field003, b.field002 as field004 from hrm_state_proc_set a left join hrm_state_proc_fields b on a.field002 = b.field001 where a.field002 between 40 and 42
/
update hrm_state_proc_fields set field003 = '6088,1867' where field001 = 42 and field002 = 'resource_n'
/
update hrm_state_proc_fields set field003 = '16091' where field001 = 42 and field002 = 'manager'
/
update hrm_state_proc_fields set field003 = '897' where field001 = 41 and field002 = 'resource_n'
/
update hrm_state_proc_fields set field003 = '15961' where field001 = 41 and field002 = 'dismissdate'
/
update hrm_state_proc_fields set field009 = 25 where field001 = 41 and field002 = 'dismissreason'
/
update hrm_state_proc_fields set field003 = '16077' where field001 = 41 and field002 = 'manager'
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 40, 'departmentid', '21673,124', 'number', 3, 167, 0, '', 35.00, 1)
/
update hrm_state_proc_fields set field003 = '16001' where field001 = 40 and field002 = 'resource_n'
/
update hrm_state_proc_fields set field009 = 25 where field001 = 40 and field002 = 'redeployreason'
/
update hrm_state_proc_fields set field003 = '21673,1909' where field001 = 40 and field002 = 'oldjoblevel'
/
update hrm_state_proc_fields set field003 = '24129', field009 = 65 where field001 = 40 and field002 = 'manager'
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 40, 'infoman', '16108', 'number', 3, 1, 0, '', 80.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'departmentid', '124', 'number', 3, 167, 0, '', 10.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'jobtitle', '6086', 'number', 3, 24, 0, '', 20.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'lastname', '413', 'varchar2(60)', 1, 1, 0, '', 30.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'sex', '416', 'char(1)', 5, 0, 0, '', 40.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'locationid', '378', 'number', 3, 262, 0, '', 50.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'status', '602', 'number', 5, 0, 0, '', 60.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'accounttype', '17745', 'number', 5, 0, 0, '', 70.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'workcode', '714', 'varchar2(60)', 1, 1, 0, '', 80.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'managerid', '15709', 'number', 3, 1, 0, '', 90.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'jobcall', '806', 'number', 3, 260, 0, '', 100.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'joblevel', '1909', 'tinyint', 1, 2, 0, '', 110.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'jobactivitydesc', '15708', 'varchar2(200)', 1, 1, 0, '', 120.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'systemlanguage', '16066', 'number', 3, 259, 0, '', 130.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'mobile', '620', 'varchar2(60)', 1, 1, 0, '', 140.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'telephone', '661', 'varchar2(60)', 1, 1, 0, '', 150.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'mobilecall', '15714', 'varchar2(60)', 1, 1, 0, '', 160.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'fax', '494', 'varchar2(60)', 1, 1, 0, '', 170.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'email', '477', 'varchar2(60)', 1, 1, 0, '', 180.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'workroom', '420', 'varchar2(60)', 1, 1, 0, '', 190.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'assistantid', '441', 'number', 3, 1, 0, '', 200.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 0, 'resourceimageid', '15707', 'text', 6, 2, 0, '', 210.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) select 0 as mfid, 0 as field001, fieldname as field002 , fieldlabel as field003, fielddbtype as field004, fieldhtmltype as field005 ,type as field006, 0 as field007, '' as field008, (190 + fieldorder * 10) as field009, 0 as field010 from hrm_formfield t left join hrm_fieldgroup t2 on t.groupid = t2.id where t2.grouptype = 1 order by t.fieldorder
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) select 0 as mfid, 0 as field001, fieldname as field002 , fieldlabel as field003, fielddbtype as field004, fieldhtmltype as field005 ,type as field006, 0 as field007, '' as field008, (400 + fieldorder * 10) as field009, 0 as field010 from hrm_formfield t left join hrm_fieldgroup t2 on t.groupid = t2.id where t2.grouptype = 3 order by t.fieldorder
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 1, 'resourceid', '413', 'number', 3, 1, 0, '', 10.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 1, 'changedate', '17510', 'char(10)', 3, 2, 0, '', 20.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 1, 'changereason', '17511', 'text', 2, 1, 0, '', 30.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 1, 'infoman', '17512', 'number', 3, 1, 0, '', 40.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 3, 'resourceid', '16079', 'number', 3, 1, 0, '', 10.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 3, 'status', '16080', 'number', 5, 0, 0, '', 20.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 3, 'changedate', '15970', 'char(10)', 3, 2, 0, '', 30.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 3, 'changeenddate', '15971', 'char(10)', 3, 2, 0, '', 40.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 3, 'changereason', '16081', 'text', 2, 1, 0, '', 50.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 3, 'changecontractid', '16082', 'number', 3, 35, 0, '', 60.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 3, 'infoman', '16083', 'number', 3, 1, 0, '', 70.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 6, 'resourceid', '16115', 'number', 3, 1, 0, '', 10.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 6, 'changedate', '16035', 'char(10)', 3, 2, 0, '', 20.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 6, 'changereason', '16116', 'text', 2, 1, 0, '', 30.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 6, 'changecontractid', '16117', 'number', 3, 35, 0, '', 40.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 6, 'infoman', '16118', 'number', 3, 1, 0, '', 50.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 7, 'resourceid', '16086', 'number', 3, 1, 0, '', 10.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 7, 'changedate', '15980', 'char(10)', 3, 2, 0, '', 20.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 7, 'changereason', '16087', 'text', 2, 1, 0, '', 30.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 7, 'changecontractid', '16088', 'number', 3, 35, 0, '', 40.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 7, 'infoman', '16089', 'number', 3, 1, 0, '', 50.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 8, 'resourceid', '16109', 'number', 3, 1, 0, '', 10.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 8, 'changedate', '16110', 'char(10)', 3, 2, 0, '', 20.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 8, 'changeenddate', '16111', 'char(10)', 3, 2, 0, '', 30.00, 1)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 8, 'changereason', '16112', 'text', 2, 1, 0, '', 40.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 8, 'changecontractid', '16113', 'number', 3, 35, 0, '', 50.00, 0)
/
insert into hrm_state_proc_fields(mfid,field001,field002,field003,field004,field005,field006,field007,field008,field009,field010) values(0, 8, 'infoman', '16114', 'number', 3, 1, 0, '', 60.00, 0)
/