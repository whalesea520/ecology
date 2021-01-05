CREATE TABLE templetecheck_matchresult(
id INTEGER PRIMARY key not null,
filepath  varchar(200) not null,
workflowname varchar(200) null,
nodename varchar(200) null,
detail varchar(2000) null
)
/
CREATE SEQUENCE templetecheck_matchresult_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger templetecheck_matchresult_Tri
before insert on templetecheck_matchresult
for each row
begin
select templetecheck_matchresult_seq.nextval into :new.id from dual;
end;
/
