/* 文档自定义新增功能*/
CREATE TABLE cus_fielddata (
seqorder integer,
scope varchar2(50) NOT NULL ,
scopeid integer NOT NULL,
id integer NOT NULL 
)
/
create sequence cus_fielddata_seqorder
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cus_fielddata_Trigger
before insert on cus_fielddata
for each row
begin
select cus_fielddata_seqorder.nextval into :new.id from dual;
end;
/

CREATE TABLE cus_formdict (
	id integer NOT NULL ,
	fielddbtype varchar2(40) ,
	fieldhtmltype char(1) ,
	type integer 
)
/

CREATE TABLE cus_formfield (
	scope varchar2(50) NOT NULL ,
    scopeid integer NOT NULL ,
    fieldlable varchar2(100),
	fieldid integer NOT NULL ,
    fieldorder integer NOT NULL,
    ismand char(1)
)
/

CREATE TABLE cus_selectitem (
	fieldid integer NOT NULL,
    selectvalue integer NOT NULL,
    selectname varchar2(250),
    fieldorder integer NOT NULL
)
/