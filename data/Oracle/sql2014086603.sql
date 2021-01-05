CREATE TABLE Meeting_repeat  
(
id INT NOT NULL,
meetingid INT NOT NULL,
begindate varchar(10) NOT NULL,
doneflag varchar(1)
)
/

create sequence Meeting_repeat_id
minvalue 1
start with 1
increment by 1
/

create or replace trigger Meeting_repeat_tri
before insert on Meeting_repeat for each row
begin
select Meeting_repeat_id.nextval into :new.id from dual;
end;
/