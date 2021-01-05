CREATE TABLE PluginLicenseUser ( 
    id integer not null,
    plugintype varchar(20),
    sharetype varchar(20),
    sharevalue varchar(200),
    seclevel varchar(50)
) 
/
create sequence PluginLicenseUser_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PluginLicenseUser_id_trigger
before insert on PluginLicenseUser
for each row
begin
select PluginLicenseUser_id.nextval into :new.id from dual;
end;
/