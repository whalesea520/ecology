alter table  SysFavourite add favouriteObjId integer default 0
/
update SysFavourite set  favouriteObjId=0 where Favouritetype=1
/