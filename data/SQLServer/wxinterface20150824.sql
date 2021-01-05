alter table WX_LocationSetting add name varchar(200)
go
update WX_LocationSetting set name = address
go