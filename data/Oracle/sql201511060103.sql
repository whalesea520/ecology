CREATE TABLE social_IMRecentConver (
	id int ,
	userid int NULL ,
	targetid varchar(100) NULL 
)
/
CREATE sequence social_IMRecentConver_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMRecentConver_id_tri
before insert on social_IMRecentConver
for each row
begin
select social_IMRecentConver_id.nextval into :new.id from dual;
end;
/

alter table social_IMConversation add senderid int
/
