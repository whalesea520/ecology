CREATE TABLE Social_AllGroupInfos(
	id int primary key,
	groupId varchar2(100),
	groupName varchar2(1000),
	createUserId varchar2(100),
	members varchar2(4000)
)
/
create or replace trigger social_allgrpinf_trigger 
before insert on Social_AllGroupInfos
for each row 
begin 
	select social_allgrpinf_seq.nextval into:new.id from sys.dual;
end;
/
create sequence social_allgrpinf_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/