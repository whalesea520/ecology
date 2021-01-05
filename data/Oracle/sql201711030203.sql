CREATE TABLE autoConfigKey(
id INTEGER PRIMARY key not null,
time varchar(200) NOT NULL
)
/
CREATE SEQUENCE autoConfigKey_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger autoConfigKey_Tri
before insert on autoConfigKey
for each row
begin
select autoConfigKey_seq.nextval into :new.id from dual;
end;
/
