CREATE TABLE HrmResourceSelectRecord (
id int primary key,
selectid int,
resourceid int
)
/
create sequence HrmSelectRecord_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER HrmSelectRecord_Trigger before insert on HrmResourceSelectRecord for each row begin select HrmSelectRecord_id.nextval into :new.id from dual; end;
/