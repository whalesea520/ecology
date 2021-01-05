create table cowork_maintypes (
    id  integer   primary key ,
    typename   varchar2(100)
)
/
create sequence cowork_maintypes_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create  or  replace trigger cowork_maintypes_trigger
before insert on cowork_maintypes
for each row
begin
select cowork_maintypes_id.nextval into :new.id from dual;
end;
/

create table cowork_types (
    id  integer  primary key ,
    typename     varchar2(100),
    departmentid integer,  
    managerid     varchar2(255),
    members	varchar2(255)
)
/
create sequence cowork_types_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cowork_types_Trigger
before insert on cowork_types
for each row
begin
select cowork_types_id.nextval into :new.id from dual;
end;
/

create table cowork_items 
(   id  integer  primary key ,
    name     varchar2(100),
    typeid	integer,
    levelvalue	integer,
    creater	integer,
    coworkers	varchar2(255),    
    createdate       char(10),  
    createtime       char(5),      
    begindate       char(10),       /*开始日期*/
    beingtime       char(5),        /*开始时间*/
    enddate         char(10),       /*结束日期*/
    endtime         char(5),        /*结束时间*/
    relatedprj	integer,
    relatedcus	integer,
    relatedwf	integer,
    relateddoc	varchar2(255),
    remark	varchar2(4000),
    status	integer,
    readers	varchar2(255),    
    isnew	varchar2(255)
 )
/
create sequence cowork_items_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cowork_items_Trigger
before insert on cowork_items
for each row
begin
select cowork_items_id.nextval into :new.id from dual;
end;
/

create table cowork_discuss (
    coworkid	integer,
    discussant integer,    
    createdate       char(10),  
    createtime       char(5),    
    remark	varchar2(4000)
)
/

CREATE or replace PROCEDURE cowork_types_insert
	(typename_1 	varchar2,
	 departmentid_2 	integer,
	 managerid_3 	varchar2,
	 members_4 	varchar2,
	 flag out integer, 
	 msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
INSERT INTO cowork_types 
	 (typename,
	 departmentid,
	 managerid,
	 members) 
VALUES 
	(typename_1,
	 departmentid_2,
	 managerid_3,
	 members_4);
end;
/

CREATE or replace PROCEDURE cowork_types_delete
(id_1 	integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
DELETE cowork_types WHERE (id = id_1);
end;	
/

CREATE or replace PROCEDURE cowork_types_update
(id_1 	integer,
typename_2 	varchar2,
departmentid_3 integer,
managerid_4 	varchar2,
members_5 	varchar2,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE cowork_types SET  typename = typename_2,
	 departmentid = departmentid_3,
	 managerid = managerid_4,
	 members = members_5 
WHERE ( id = id_1);
end;	
/

CREATE or replace PROCEDURE cowork_items_insert
	(name_1 	varchar2,
	 typeid_2 	integer,
	 levelvalue_3 	integer,
	 creater_4 	integer,
	 coworkers_5 	varchar2,
	 createdate_6 	char,
	 createtime_7 	char,
	 begindate_8 	char,
	 beingtime_9 	char,
	 enddate_10 	char,
	 endtime_11 	char,
	 relatedprj_12 	integer,
	 relatedcus_13 	integer,
	 relatedwf_14 	integer,
	 relateddoc_15 	varchar2,
	 remark_16 	varchar2,
	 status_17 	integer,
	 isnew 	varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
INSERT INTO cowork_items 
	 (name,
	 typeid,
	 levelvalue,
	 creater,
	 coworkers,
	 createdate,
	 createtime,
	 begindate,
	 beingtime,
	 enddate,
	 endtime,
	 relatedprj,
	 relatedcus,
	 relatedwf,
	 relateddoc,
	 remark,
	 status,
	 isnew) 
 
VALUES 
	(name_1,
	 typeid_2,
	 levelvalue_3,
	 creater_4,
	 coworkers_5,
	 createdate_6,
	 createtime_7,
	 begindate_8,
	 beingtime_9,
	 enddate_10,
	 endtime_11,
	 relatedprj_12,
	 relatedcus_13,
	 relatedwf_14,
	 relateddoc_15,
	 remark_16,
	 status_17,
	 isnew);
open thecursor for
select max(id) from cowork_items;
end;
/

CREATE or replace PROCEDURE cowork_discuss_insert
	(coworkid_1 	integer,
	 discussant_2 	integer,
	 createdate_3 	char,
	 createtime_4 	char,
	 remark_5 	varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
INSERT INTO cowork_discuss 
	 (coworkid,
	 discussant,
	 createdate,
	 createtime,
	 remark) 
VALUES 
	(coworkid_1,
	 discussant_2,
	 createdate_3,
	 createtime_4,
	 remark_5);
end;
/

CREATE or replace PROCEDURE cowork_items_update
	(id_1 	integer,
	 name_2 	varchar2,
	 typeid_3 	integer,
	 levelvalue_4 	integer,
	 creater_5 	integer,
	 coworkers_6 	varchar2,
	 begindate_7 	char,
	 beingtime_8 	char,
	 enddate_9 	char,
	 endtime_10 	char,
	 relatedprj_11 	integer,
	 relatedcus_12 	integer,
	 relatedwf_13 	integer,
	 relateddoc_14 	varchar2,
	 remark_15 	varchar2,
	 isnew_16 	varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE cowork_items SET  name = name_2,
	 typeid	 = typeid_3,
	 levelvalue = levelvalue_4,
	 creater = creater_5,
	 coworkers = coworkers_6,
	 begindate = begindate_7,
	 beingtime = beingtime_8,
	 enddate = enddate_9,
	 endtime = endtime_10,
	 relatedprj = relatedprj_11,
	 relatedcus = relatedcus_12,
	 relatedwf = relatedwf_13,
	 relateddoc = relateddoc_14,
	 remark = remark_15,
	 isnew = isnew_16 
WHERE 
	( id = id_1);
end;
/