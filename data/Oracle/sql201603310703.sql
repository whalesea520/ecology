alter table HistoryMsg add msgid varchar2(100) 
/

create table Social_historyMsgRight(
    id number(10) primary key,
    userId varchar2(100),
    msgId varchar2(100)
) 
/

create sequence SocialHistoryMsgRight_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle 
/

create or replace trigger SocialHistoryMsgRight_trigger 
before insert on Social_historyMsgRight 
for each row 
begin 
	select SocialHistoryMsgRight_seq.nextval into:new.id from sys.dual 
end 
/

CREATE INDEX historyMsgRight_userid_index ON Social_historyMsgRight (userId) 
/

CREATE INDEX historyMsgRight_msgid_index ON Social_historyMsgRight (msgId) 
/