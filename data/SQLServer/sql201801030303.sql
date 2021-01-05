alter table Networkfileshare add tosharerid_tmp varchar(200)
GO
update Networkfileshare set tosharerid_tmp=tosharerid
GO
alter table Networkfileshare drop column tosharerid
GO
alter table Networkfileshare add tosharerid varchar(200)
GO
update Networkfileshare set tosharerid=tosharerid_tmp
GO
alter table Networkfileshare drop column tosharerid_tmp
GO
