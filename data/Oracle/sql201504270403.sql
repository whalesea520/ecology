CREATE TABLE SERIALNUM(
   ID INT primary key,
   NUM INT,
   CODEMAINID INT,
   FIELD1 VARCHAR2(20),
   FIELD2 VARCHAR2(20),
   FIELD3 VARCHAR2(20),
   FIELD4 VARCHAR2(20),
   FIELD5 VARCHAR2(20),
   FIELD6 VARCHAR(20)
)
/
create sequence SERIALNUM_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger SERIALNUM_id_Tri
before insert on SERIALNUM
for each row
begin
select SERIALNUM_id.nextval into :new.id from dual;
end;
/

ALTER TABLE modecodeDetail ADD isSerial int
/
alter table modecode add startCode int
/
alter table ModeCodeDetail add tablename varchar(50)
/
alter table ModeCodeDetail add fieldname varchar(50)
/
