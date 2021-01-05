alter table mode_reminddata_all rename column billid to billid_tmp
/
alter table mode_reminddata_all add billid varchar2(100)
/
update mode_reminddata_all set billid=trim(billid_tmp)
/
alter table mode_reminddata_all drop column billid_tmp
/