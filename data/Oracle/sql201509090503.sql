create table social_IMSetting(
  id int ,
  userid int,
  targetid VARCHAR(500),
  remindType int,
  targetType int
)
/

create sequence social_IMSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMSetting_id_tri
before insert on social_IMSetting
for each row
begin
select social_IMSetting_id.nextval into :new.id from dual;
end;
/

create table social_IMFile(
  id int ,
  userid int,
  targetid VARCHAR(500),
  targetType int,
  fileid int,
  fileName VARCHAR(500),
  fileSize int,
  fileType VARCHAR(10),
  createdate VARCHAR(20),
  downCount int DEFAULT 0
)
/

create sequence social_IMFile_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMFile_id_tri
before insert on social_IMFile
for each row
begin
select social_IMFile_id.nextval into :new.id from dual;
end;
/

create table social_IMFileShare(
  id int ,
  userid int,
  fileid int
)
/
create sequence social_IMFileShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMFileShare_id_tri
before insert on social_IMFileShare
for each row
begin
select social_IMFileShare_id.nextval into :new.id from dual;
end;
/
