alter table mode_remindjob add sqlwherejson varchar2(2000)
/

CREATE TABLE mode_reminddata_all(
	id int,
	remindjobid int ,
	modeid int ,
	billid int ,
	subbillid int ,
	lastdate varchar2(20) ,
	lasttime varchar2(20) ,
	isRemindSMS int ,
	isRemindEmail int ,
	isRemindWorkflow int ,
	isRemindWeChat int ,
	isRemindEmobile int 
)
/

create sequence mode_reminddata_all_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_reminddata_all_Tri
before insert on mode_reminddata_all
for each row
begin
select mode_reminddata_all_id.nextval into :new.id from dual;
end;
/