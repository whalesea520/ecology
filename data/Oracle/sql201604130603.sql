create table Social_IMSysBroadcast(
	id int primary key,
	permissionType integer,
	contents integer,
	seclevel integer,
	seclevelMax integer DEFAULT 100,
	jobtitleid varchar2(1000),
    joblevel integer DEFAULT 0,
    scopeid varchar2(100)
)
/

create sequence SocialIMSysBroadcast_seq start with 1 increment by 1 nomaxvalue nocycle
/

create or replace trigger SocialIMSysBroadcast_trigger 
before insert on Social_IMSysBroadcast
for each row 
begin 
	select SocialIMSysBroadcast_seq.nextval into:new.id from sys.dual
end
/


Delete from MainMenuInfo where id=10251
/