CREATE TABLE hpcurrenttab (
	id integer NOT NULL ,
	eid integer NULL ,
	currenttab integer NULL ,
	userid integer NULL ,
	usertype integer NULL 
)
/
create sequence hpcurrenttab_id
start with 1
increment by 1
nomaxvalue
nocycle
/
CREATE or replace TRIGGER hpcurrenttab_Tri
before insert on hpcurrenttab
for each row
begin
select hpcurrenttab_id.nextval into :new.id from dual;
end;
/