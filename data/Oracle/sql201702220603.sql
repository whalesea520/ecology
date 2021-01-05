CREATE TABLE cowork_base_set(
id int  primary key NOT NULL ,
itemstate varchar2(2) NULL ,
infostate varchar2(2) NULL ,
userid int NULL ,
createdate char(10) NULL ,
createtime char(8) NULL ,
dealchangeminute varchar2(200) NULL

) 
/
 
create sequence coworkbaseset_seq 
start with 1 
increment by 1 
nomaxvalue 
/

create or replace trigger coworkbaseset_trigger 
before insert on cowork_base_set
for each row 
begin 
	select coworkbaseset_seq.nextval into:new.id from sys.dual; 
end;
/

CREATE TABLE cowork_votes(
id int primary key NOT NULL ,
itemid int NULL ,
discussID int NULL ,
userid int NULL ,
createdate char(10) NULL ,
createtime char(5) NULL ,
status varchar2(2) NULL

) 
/

 
create sequence coworkvotes_seq 
start with 1 
increment by 1 
nomaxvalue 
/

create or replace trigger coworkvotes_trigger 
before insert on cowork_votes
for each row 
begin 
	select coworkvotes_seq.nextval into:new.id from sys.dual; 
end;
/


CREATE TABLE cowork_collect(
id int primary key NOT NULL ,
itemid int NULL ,
discussID int NULL ,
userid int NULL ,
createdate char(10) NULL ,
createtime char(8) NULL ,
iscollect varchar2(2) NULL 

) 
/

create sequence coworkcollect_seq 
start with 1 
increment by 1 
nomaxvalue 
/

create or replace trigger coworkcollect_trigger 
before insert on cowork_collect
for each row 
begin 
	select coworkcollect_seq.nextval into:new.id from sys.dual; 
end;
/