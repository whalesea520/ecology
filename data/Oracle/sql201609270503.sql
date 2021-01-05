CREATE TABLE  FullSearch_CusLabel (
id integer NOT NULL primary key,
type varchar2(100) ,
sourceid integer NOT NULL ,
label varchar2(1000),
updateTime date
)
/
create sequence seq_fullSearch_CusLabel
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CusLabel_tri
before insert on FullSearch_CusLabel
for each row
begin
select seq_fullSearch_CusLabel.nextval into :new.id from dual;
end ;
/