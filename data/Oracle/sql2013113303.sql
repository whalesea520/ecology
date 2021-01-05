CREATE TABLE blog_Group
	(
	id   INT NOT NULL,
	groupname VARCHAR (200) NULL,
	userid     INT NULL
	)
/
create sequence blog_Group_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_Group_id_trigger
before insert on blog_Group
for each row
begin
select blog_Group_id.nextval into :new.id from dual;
end;
/

CREATE TABLE blog_userGroup
	(
	id   INT NOT NULL,
	groupid int NULL,
	userid     INT NULL
	)
/
create sequence blog_userGroup_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_userGroup_id_trigger
before insert on blog_userGroup
for each row
begin
select blog_userGroup_id.nextval into :new.id from dual;
end;
/
