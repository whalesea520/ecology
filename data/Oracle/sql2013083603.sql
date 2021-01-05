
create table MeetingRoom_share 
	(id number , mid int,
	permissiontype int,seclevel int,
	departmentid int,deptlevel int,
	subcompanyid int,sublevel int,
	userid int,describ varchar(1000))
/

create table MeetingType_share 
	(id number, mtid int,
	permissiontype int,seclevel int,
	departmentid int,deptlevel int,
	subcompanyid int,sublevel int,
	userid int,describ varchar(1000))
/
CREATE SEQUENCE  MeetingType_share_id
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 9999999999999
 START WITH 1
 CACHE 20
/
CREATE OR REPLACE TRIGGER MeetingType_share_TRIGGER BEFORE INSERT ON MeetingType_share FOR EACH ROW
begin select MeetingType_share_id.nextval into :new.id from dual; end ;
/
ALTER TRIGGER MeetingType_share_TRIGGER ENABLE
/
CREATE SEQUENCE  MeetingRoom_share_id
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 9999999999999
 START WITH 1
 CACHE 20
/
CREATE OR REPLACE TRIGGER MeetingRoom_share_TRIGGER BEFORE INSERT ON MeetingRoom_share FOR EACH ROW
begin select MeetingRoom_share_id.nextval into :new.id from dual; end ;
/
ALTER TRIGGER MeetingRoom_share_TRIGGER ENABLE
/