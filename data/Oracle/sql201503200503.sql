alter table sysfavourite add url_bak varchar2(1000)
/
update sysfavourite set url_bak = url
/
update sysfavourite set url = null
/
alter table sysfavourite modify url long
/
update sysfavourite set url = url_bak
/
update sysfavourite set url_bak = null
/
alter table sysfavourite drop column url_bak
/