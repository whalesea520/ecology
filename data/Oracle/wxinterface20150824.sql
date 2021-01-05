alter table WX_LocationSetting add name varchar(200)
/
update WX_LocationSetting set name = address
/