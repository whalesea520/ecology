CREATE TABLE mode_reminddata_error(
	id int  ,
	remindjobid int ,
	modeid int ,
	billid int ,
	subbillid int ,
	createdate varchar(20) ,
	createtime varchar(20) ,
	remindway int,
	remindwaydesc varchar(50),
	msg varchar2(4000),
	lastdate varchar2(20) ,
	lasttime varchar2(20) 
)
/

create sequence mode_reminddata_error_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_reminddata_error_Tri
before insert on mode_reminddata_error
for each row
begin
select mode_reminddata_error_id.nextval into :new.id from dual;
end;
/