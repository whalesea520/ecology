CREATE TABLE ofUpdateInfo ( 
    id integer not null,
    InfoName varchar(20),
    InfoStatus number
) 
/
create sequence ofUpdateInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ofUpdateInfo_trigger
before insert on ofUpdateInfo
for each row
begin
select ofUpdateInfo_id.nextval into :new.id from dual;
end;
/



insert into ofUpdateInfo(InfoName,InfoStatus) values ('userRole',0)
/