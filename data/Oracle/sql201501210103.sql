alter table prj_prjwfconf add guid1 char(36)
/

create table prj_prjwfactset(
id int  not null,
mainid int null,
fieldid int null,
customervalue int null,
isnode int null,
objid int null,
isTriggerReject int null
)
/
create sequence prj_prjwfactset_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_prjwfactset_TRIGGER before insert on prj_prjwfactset for each row 
begin 
	select prj_prjwfactset_ID.nextval into :new.id from dual; 
end;
/