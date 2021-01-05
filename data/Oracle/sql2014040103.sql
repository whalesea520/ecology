CREATE TABLE ofpopinfo( 
    id integer not null,
    loginid varchar(60),
    infotitle varchar(200),
    infosubject varchar(1000),
    infourl varchar(200),
    sendtime number
) 
/
create sequence ofpopinfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ofpopinfo_id_trigger
before insert on ofpopinfo
for each row
begin
select ofpopinfo_id.nextval into :new.id from dual;
end;
/
