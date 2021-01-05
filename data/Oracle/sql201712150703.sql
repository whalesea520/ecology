CREATE TABLE hrmoutinterfacelog(
id INT PRIMARY KEY NOT NULL,
memo varchar2(4000),
created date default sysdate
)
/
create sequence hrmoutinterfacelog_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 281
increment by 1
cache 20
/
create or replace trigger hrmoutinterfacelog_ID_Tri before insert on hrmoutinterfacelog for each row begin select hrmoutinterfacelog_ID.nextval into :new.id from dual; end;
/