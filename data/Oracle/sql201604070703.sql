create table Social_IMUserSysConfig(
    id int primary key,
    userId int,
    winConfig varchar2(1000),
  	osxConfig varchar2(1000)
) 
/

create sequence SocialIMUserSysConfig_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger SocialIMUserSysConfig_trigger 
before insert on Social_IMUserSysConfig 
for each row 
begin 
	select SocialIMUserSysConfig_seq.nextval into:new.id from sys.dual;
end;
/