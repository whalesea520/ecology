CREATE TABLE hpsysremind (
	id     integer      NOT NULL,
	eid int not NULL ,
	orderid int NULL 
) 
/


CREATE SEQUENCE hpsysremind_id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER hpsysremind_Id_Trigger
	before insert on hpsysremind
	for each row
	begin
	select hpsysremind_id.nextval into :new.id from dual;
	end ;
/
