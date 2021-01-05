alter table  SysFavourite add favouriteObjId int default 0
GO
update SysFavourite set  favouriteObjId=0 where Favouritetype=1
GO