alter table Networkfileshare rename column tosharerid to tosharerid_tmp
/
alter table Networkfileshare add tosharerid varchar2(200)
/
update Networkfileshare set tosharerid=tosharerid_tmp
/
alter table Networkfileshare drop column tosharerid_tmp
/