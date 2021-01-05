
create table WECHAT_PLATFORM
(
  ID              INTEGER not null primary key ,
  PUBLICID        VARCHAR2(100) not null,
  APPID           VARCHAR2(100) not null,
  APPSECRET       VARCHAR2(100) not null,
  NAME            VARCHAR2(100),
  description        VARCHAR2(100),
  STATE           CHAR(1),
  ACCESSTOKEN     VARCHAR2(400),
  EXPIRES         NUMBER(20) default 0,
  TOKENLOCK       CHAR(1),
  SUBCOMPANYID    INTEGER,
  ISDELETE        CHAR(1) default 0 not null,
  DEFAULTREMINDER CHAR(1) default 0 not null,
  SUFFIX          VARCHAR2(50),
  autoReply	char(1) DEFAULT 0 NOT NULL,
  welcomeMsg	varchar2(200) NULL 

)
/
create sequence wechat_platform_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_platform_tri
before insert on wechat_platform for each row
begin
select wechat_platform_id.nextval into :new.id from dual;
end;
/


create table WECHAT_SHARE
(
  ID             INTEGER not null primary key,
  PLATFORMID     INTEGER not null,
  PERMISSIONTYPE INTEGER,
  TYPEVALUE      INTEGER,
  SECLEVEL       INTEGER,
  SECLEVELMAX    INTEGER
)
/
create sequence wechat_share_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_share_tri
before insert on WECHAT_SHARE for each row
begin
select wechat_share_id.nextval into :new.id from dual;
end;
/


create table WECHAT_BAND
(
  ID         INTEGER not null primary key,
  PUBLICID   VARCHAR2(100) not null,
  OPENID     VARCHAR2(100),
  USERID     INTEGER not null,
  USERTYPE   INTEGER not null,
  BANDTIME   VARCHAR2(19),
  ACTIVETIME VARCHAR2(19),
  TICKET     VARCHAR2(255),
  EXPIRES    NUMBER(20) default 0 not null
)
/
create sequence wechat_band_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_band_tri
before insert on WECHAT_BAND for each row
begin
select wechat_band_id.nextval into :new.id from dual;
end;
/



create table wechat_action
(
  ID        INTEGER not null primary key ,
  PUBLICID  VARCHAR2(100),
  MSGTYPE   VARCHAR2(50),
  EVENTTYPE VARCHAR2(50),
  EVENTKEY  VARCHAR2(50),
  CLASSNAME VARCHAR2(255),
  TYPE      CHAR(1) default 1 not null
)
/
create sequence wechat_action_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_action_tri
before insert on wechat_action for each row
begin
select wechat_action_id.nextval into :new.id from dual;
end;
/
INSERT INTO wechat_action (publicid, msgtype, eventtype, eventkey, classname, type) VALUES (null, 'event', 'scan', null, 'weaver.wechat.receive.ScanAction', '1')
/
INSERT INTO wechat_action ( publicid, msgtype, eventtype, eventkey, classname, type) VALUES (null, 'event', 'subscribe', null, 'weaver.wechat.receive.ScanAction', '1')
/
INSERT INTO wechat_action ( publicid, msgtype, eventtype, eventkey, classname, type) VALUES ( null, 'text', null, null, 'weaver.wechat.receive.TextAction', '1')
/
commit
/

create table wechat_msg
(
  ID         INTEGER not null primary key,
  PUBLICID   VARCHAR2(100) not null,
  USERID     INTEGER,
  USERTYPE   INTEGER,
  MSG        VARCHAR2(4000),
  MSGTYPE    INTEGER,
  TOUSERID   INTEGER,
  TOUSERTYPE INTEGER,
  STATE      CHAR(1),
  CREATETIME CHAR(19),
  SENDTIME   CHAR(19),
  RESULT     VARCHAR2(200),
  MSGID      VARCHAR2(200),
  ISDELETE   CHAR(1) default 0 not null
)
/
create sequence wechat_msg_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_msg_tri
before insert on wechat_msg for each row
begin
select wechat_msg_id.nextval into :new.id from dual;
end;
/





CREATE TABLE wechat_receive_event(
 ID INTEGER not null primary key ,
 event varchar2(200) NULL 
)
/
alter table WECHAT_RECEIVE_EVENT  add constraint EVENT unique (EVENT)
/
create sequence wechat_receive_event_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_receive_event_tri
before insert on wechat_receive_event for each row
begin
select wechat_receive_event_id.nextval into :new.id from dual;
end;
/


CREATE TABLE wechat_reply(
ID INTEGER not null primary key ,
publicid varchar2(100) NOT NULL ,
name varchar2(100) NOT NULL ,
replytype char(1) NOT NULL ,
replymsg varchar2(4000) NULL ,
classname varchar2(100) NULL ,
sort NUMBER(11,2) NULL ,
state char(1)  DEFAULT 0 NOT NULL
)
/
create sequence wechat_reply_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_reply_tri
before insert on wechat_reply for each row
begin
select wechat_reply_id.nextval into :new.id from dual;
end;
/

CREATE TABLE wechat_reply_rule (
ID INTEGER not null primary key ,
replyid INTEGER NOT NULL ,
keyword varchar2(100) NOT NULL ,
keytype char(1)  DEFAULT 0 NOT NULL
)
/
create sequence wechat_reply_rule_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_reply_rule_tri
before insert on wechat_reply_rule for each row
begin
select wechat_reply_rule_id.nextval into :new.id from dual;
end;
/



alter table wechat_band add token VARCHAR2(200)
/
alter table wechat_band add tokenExpires decimal(20) DEFAULT 0 not null
/


CREATE table wechat_set(
  id int NOT NULL PRIMARY key,
  oaUrl VARCHAR(200) null,
  mobileUrl VARCHAR(200) null,
  signPostion char(1) DEFAULT 1,
  username char(1)  DEFAULT 1,
  userid char(1)  DEFAULT 0,
  dept char(1) DEFAULT 0,
  subcomp char(1) DEFAULT 0
)
/
INSERT into wechat_set(id) values(1)
/




CREATE table wechat_reminder_mode(
  modekey VARCHAR(50) PRIMARY key,
  modename VARCHAR(200) not null
)
/
CREATE table wechat_reminder_type(
  type VARCHAR(50) PRIMARY key,
  typename VARCHAR(200) not null,
  modekey VARCHAR(50) not null
)
/
CREATE table wechat_reminder_set(
  ID INTEGER not null primary key ,
  prefix VARCHAR(200) null,
  prefixConnector VARCHAR(10) null,
  suffix VARCHAR(200) null,
  suffixConnector VARCHAR(10) null,
  type VARCHAR(100) not null,
  def char(1) not null
)
/
create sequence wechat_reminder_set_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_reminder_set_tri
before insert on wechat_reminder_set for each row
begin
select wechat_reminder_set_id.nextval into :new.id from dual;
end;
/


