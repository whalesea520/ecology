create table social_IMAttention (
  id int,
  userid int,
  targetid VARCHAR(100),
  targettype VARCHAR(20)
)
/
create sequence social_IMAttention_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMAttention_id_tri
before insert on social_IMAttention
for each row
begin
select social_IMAttention_id.nextval into :new.id from dual;
end;
/

create table social_IMChatResource (
  id int ,
  resourceid int,
  resourcename varchar(100),
  resourcedesc varchar(100),
  resourcetype char(2),
  creatorid int,
  createtime varchar(100),
  targetid varchar(100),
  targettype varchar(20),
  memberids varchar(900)
)
/
create sequence social_IMChatResource_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMChatResource_id_tri
before insert on social_IMChatResource
for each row
begin
select social_IMChatResource_id.nextval into :new.id from dual;
end;
/
create table social_IMConversation (
	id int,
	userid int,
	targetid VARCHAR(100),
	targettype VARCHAR(20),
	targetPortrait VARCHAR(100),
	targetname VARCHAR(100),
	msgcontent VARCHAR(4000),
	unreadcnt int,
	istop CHAR(1),
	lasttime VARCHAR(100) 
)
/
create sequence social_IMConversation_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMConversation_id_tri
before insert on social_IMConversation
for each row
begin
select social_IMConversation_id.nextval into :new.id from dual;
end;
/

create TABLE social_IMMsgCount(
  id int,
  msgid VARCHAR(100),
  receiverid int,
  status int
)
/
create sequence social_IMMsgCount_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMMsgCount_id_tri
before insert on social_IMMsgCount
for each row
begin
select social_IMMsgCount_id.nextval into :new.id from dual;
end;
/

create TABLE social_IMRecent(
  id int,
  userid int, 
  targetid VARCHAR(100), 
  targetType int, 
  lasttime varchar(20) 
)
/
create sequence social_IMRecent_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMRecent_id_tri
before insert on social_IMRecent
for each row
begin
select social_IMRecent_id.nextval into :new.id from dual;
end;
/

create TABLE social_IMMsgRead(
  id int,
  msgid VARCHAR(100),
  receiverid int,
  status int
)
/
create sequence social_IMMsgRead_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMMsgRead_id_tri
before insert on social_IMMsgRead
for each row
begin
select social_IMMsgRead_id.nextval into :new.id from dual;
end;
/

CREATE INDEX social_IMMsgRead_index ON social_IMMsgRead (msgid DESC) 
/

create TABLE im_MsgInitRecord(
  id int,
  msgid VARCHAR(100)
)
/
create sequence Social_im_MsgInitRecord_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger Social_im_MsgInitRecord_id_tri
before insert on im_MsgInitRecord
for each row
begin
select Social_im_MsgInitRecord_id.nextval into :new.id from dual;
end;
/

CREATE INDEX im_MsgInitRecord_index ON im_MsgInitRecord (msgid DESC) 
/

