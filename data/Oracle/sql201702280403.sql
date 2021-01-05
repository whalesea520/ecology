CREATE TABLE cowork_quiter(
id int primary key NOT NULL ,
itemid int NULL ,
userid int NULL ,
quitdate char(10) NULL ,
quittime char(8) NULL ,
coworkothers varchar2(4000) NULL
) 
/

create sequence coworkquiter_seq 
start with 1 
increment by 1 
nomaxvalue 
/

create or replace trigger coworkquiter_trigger 
before insert on cowork_quiter
for each row 
begin 
	select cowork_quiter_seq.nextval into:new.id from sys.dual; 
end;
/