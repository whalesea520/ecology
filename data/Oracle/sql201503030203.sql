CREATE TABLE cpt_oauth(
id int  not null,
auth_flag_ varchar2(200) not null,
auth_clazz_ varchar2(200) not null
)
/
create sequence cpt_oauth_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cpt_oauth_TRIGGER before insert on cpt_oauth for each row 
begin select cpt_oauth_ID.nextval into :new.id from dual; end;
/