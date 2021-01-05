create table SqlFileLogInfo
(
 id integer NOT NULL,
 sqlfilename varchar2(200) NOT NULL,
 rundate varchar2(10),
 runtime varchar2(10)
)
/
create sequence SqlFileLogInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SqlFileLogInfo_id_Tri
before insert on SqlFileLogInfo
for each row
begin
select SqlFileLogInfo_id.nextval into :new.id from dual;
end;
/
