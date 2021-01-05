CREATE TABLE blog_app
	(
	id       integer NOT NULL,
	name     VARCHAR2 (20) NULL,
	isActive integer NULL,
	appType  VARCHAR2 (50) NULL,
	sort     integer NULL,
	iconPath VARCHAR2 (255) NULL
	)
/
create sequence blog_app_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_app_id_trigger
before insert on blog_app
for each row
begin
select blog_app_id.nextval into :new.id from dual;
end;
/


INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('26769', 1, 'mood', 1, 'images/crm.png')
/
INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('58', 1, 'doc', 2, 'images/app-doc.png')
/
INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('18015', 1, 'workflow', 3, 'images/app-wl.png')
/

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('136', 1, 'crm', 4, 'images/app-crm.png')
/

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('101', 1, 'project', 5, 'images/app-project.png')
/

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('1332', 1, 'task', 6, 'images/app-task.png')
/


CREATE TABLE blog_appDatas
	(
	id         integer  NOT NULL,
	userid     integer NOT NULL,
	workDate   VARCHAR2 (10) NOT NULL,
	createDate VARCHAR2 (10) NOT NULL,
	createTime VARCHAR2 (10) NOT NULL,
	discussid  integer NOT NULL,
	appItemId  integer NOT NULL
	)
/
create sequence blog_appDatas_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_appDatas_id_trigger
before insert on blog_appDatas
for each row
begin
select blog_appDatas_id.nextval into :new.id from dual;
end;
/


CREATE TABLE blog_AppItem
	(
	id       integer  NOT NULL,
	itemName VARCHAR2 (20) NULL,
	value    integer NOT NULL,
	type     VARCHAR2 (20) NOT NULL,
	face     VARCHAR2 (500) NULL
	)
/
create sequence blog_AppItem_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_AppItem_id_trigger
before insert on blog_AppItem
for each row
begin
select blog_AppItem_id.nextval into :new.id from dual;
end;
/

INSERT INTO blog_AppItem (itemName, value, type, face)
VALUES ('26917', 4, 'mood', '/blog/images/mood-happy.png')
/

INSERT INTO blog_AppItem (itemName, value, type, face)
VALUES ('26918', 2, 'mood', '/blog/images/mood-unhappy.png')
/

CREATE TABLE blog_attention
	(
	id          integer NOT NULL,
	userid      integer NULL,
	attentionid integer NULL
	)
/
create sequence blog_attention_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_attention_id_trigger
before insert on blog_attention
for each row
begin
select blog_attention_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_cancelAttention
	(
	id          integer NOT NULL,
	userid      integer NULL,
	attentionid integer NULL
	)
/
create sequence blog_cancelAttention_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_calAttention_id_trigger
before insert on blog_cancelAttention
for each row
begin
select blog_cancelAttention_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_discuss
	(
	id             integer NOT NULL,
	userid         integer NULL,
	createdate     VARCHAR2 (10) NULL,
	createtime     VARCHAR2 (10) NULL,
	content        clob NULL,
	lastUpdatetime VARCHAR2 (50) NULL,
	isReplenish    integer NULL,
	workdate       VARCHAR2 (10) NULL
	)
/
create sequence blog_discuss_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_discuss_id_trigger
before insert on blog_discuss
for each row
begin
select blog_discuss_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_read
	(
	id     integer NOT NULL,
	userid integer NULL,
	blogid integer NULL
	)
/
create sequence blog_read_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_read_id_trigger
before insert on blog_read
for each row
begin
select blog_read_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_remind
	(
	id          integer NOT NULL,
	remindid    integer NULL,
	relatedid   integer NULL,
	remindType  integer NULL,
	remindValue VARCHAR2 (100) NULL,
	status      integer NULL,
	createdate  VARCHAR2 (10) NULL,
	createtime  VARCHAR2 (10) NULL
	)
/
create sequence blog_remind_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_remind_id_trigger
before insert on blog_remind
for each row
begin
select blog_remind_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_reportTemp
	(
	id        integer NOT NULL,
	userid    integer NULL,
	tempName  VARCHAR2 (50) NULL,
	isDisplay integer NULL,
	isDefault integer NULL,
	sort      integer NULL
	)
/
create sequence blog_reportTemp_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_reportTemp_id_trigger
before insert on blog_reportTemp
for each row
begin
select blog_reportTemp_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_setting
	(
	id           integer NOT NULL,
	userid       integer NULL,
	isReceive    integer NULL,
	maxAttention integer NULL,
	isThumbnail  integer NULL
	)
/
create sequence blog_setting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_setting_id_trigger
before insert on blog_setting
for each row
begin
select blog_setting_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_share
	(
	id         integer NOT NULL,
	blogid     integer NULL,
	type       integer NULL,
	content    VARCHAR2 (4000) NULL,
	seclevel   integer NULL,
	sharelevel integer NULL
	)
/
create sequence blog_share_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_share_id_trigger
before insert on blog_share
for each row
begin
select blog_share_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_sysSetting
	(
	id           integer NOT NULL,
	allowRequest integer NULL,
	enableDate   VARCHAR2 (10) NULL,
	isSingRemind integer NULL
	)
/


create sequence blog_sysSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_sysSetting_id_trigger
before insert on blog_sysSetting
for each row
begin
select blog_sysSetting_id.nextval into :new.id from dual;
end;
/

INSERT INTO blog_sysSetting (allowRequest, enableDate,isSingRemind)
VALUES (1, '2011-09-01',0)
/

CREATE TABLE blog_tempCondition
	(
	id      integer NOT NULL,
	tempid  integer NULL,
	type    integer NULL,
	content VARCHAR2 (50) NULL
	)
/
create sequence blog_tempCondition_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_tempCondition_id_trigger
before insert on blog_tempCondition
for each row
begin
select blog_tempCondition_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_visit
	(
	id        integer NOT NULL,
	userid    integer NULL,
	blogid    integer NULL,
	visitdate VARCHAR2 (10) NULL,
	visittime VARCHAR2 (10) NULL
	)
/
create sequence blog_visit_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_visit_id_trigger
before insert on blog_visit
for each row
begin
select blog_visit_id.nextval into :new.id from dual;
end;
/

CREATE TABLE   blog_reply
	(
	id         integer NOT NULL,
	userid     integer NULL,
	discussid  integer NULL,
	createdate VARCHAR2 (10) NULL,
	createtime VARCHAR2 (10) NULL,
	content    clob NULL
	)
/
create sequence blog_reply_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_reply_id_trigger
before insert on blog_reply
for each row
begin
select blog_reply_id.nextval into :new.id from dual;
end;
/

UPDATE LeftMenuInfo SET module='blog' WHERE id=392
/

UPDATE MainMenuInfo SET module='blog' WHERE id=1047
/