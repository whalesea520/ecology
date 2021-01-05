create sequence social_IMChatResShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMChatResShare_id_tri
before insert on social_IMChatResourceShare
for each row
begin
select social_IMChatResShare_id.nextval into :new.id from dual;
end;
/