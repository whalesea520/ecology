CREATE TABLE OfNoticeRote ( 
    id integer not null,
    loginid varchar(200),
    rote number
) 
/
create sequence OfNoticeRote_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger OfNoticeRote_id_trigger
before insert on OfNoticeRote
for each row
begin
select OfNoticeRote_id.nextval into :new.id from dual;
end;
/

