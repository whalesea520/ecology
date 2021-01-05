create table ecologypackageinfo(
  id INT NOT NULL,
  label VARCHAR(10),
  name VARCHAR(200),
  type VARCHAR(1),
  lastDate VARCHAR(200),
  lastTime VARCHAR(200),
  status  VARCHAR(1)
)
/
create sequence ecologypackageinfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ecologypackageinfo_trigger
before insert on ecologypackageinfo
for each row
begin
select ecologypackageinfo_id.nextval into :new.id from dual;
end;
/
alter table ecologypackageinfo add content varchar(2000)
/
alter table ecologypackageinfo add downloadid varchar(100)
/
alter table ecologypackageinfo add description varchar(2000)
/