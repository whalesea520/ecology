CREATE TABLE blog_template
	(
	id          integer  NOT NULL,
	tempName    VARCHAR2 (100) NULL,
	isUsed      integer NULL,
	tempContent clob NULL,
	description clob NULL
	)
/

CREATE TABLE blog_tempShare
	(
	id       integer NOT NULL,
	tempid   integer NULL,
	type     integer NULL,
	content  VARCHAR2 (4000) NULL,
	seclevel integer NULL
	)
/

CREATE TABLE tokenJscx
	(
	tokenKey VARCHAR2 (100) NOT NULL,
	authkey  VARCHAR2 (200) NOT NULL,
	currsucc integer DEFAULT ((0)) NULL,
	currdft  integer DEFAULT ((0)) NULL,
	lastcode VARCHAR2 (20) NULL,
	lasttime VARCHAR2 (20) NULL,
	userid   integer NULL
	)
/


CREATE TABLE blog_specifiedShare
	(
	id              integer  NOT NULL ,
	specifiedid     integer NULL,
	type            integer NULL,
	content         VARCHAR2 (4000) NULL,
	seclevel        integer NULL,
	sharelevel      integer NULL
	)
/

alter table HrmResource add tokenkey varchar2(100)
/

ALTER TABLE tokenJscx modify authkey VARCHAR2(4000)
/

create sequence blog_template_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_template_id_trigger
before insert on blog_template
for each row
begin
select blog_template_id.nextval into :new.id from dual;
end;
/

create sequence blog_tempShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_tempShare_id_trigger
before insert on blog_tempShare
for each row
begin
select blog_tempShare_id.nextval into :new.id from dual;
end;
/

create sequence blog_specifiedShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_specifiedShare_id_trigger
before insert on blog_specifiedShare
for each row
begin
select blog_specifiedShare_id.nextval into :new.id from dual;
end;
/
