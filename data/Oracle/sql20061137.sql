alter table hpstyle rename column stylename to stylename_2
/
alter table hpstyle add stylename varchar2(50)  null
/
update  hpstyle set stylename = stylename_2
/
alter table hpstyle drop column stylename_2
/


alter table hpinfo rename column infoname to infoname_2
/
alter table hpinfo add infoname varchar2(50)  null
/
update  hpinfo set infoname = infoname_2
/
alter table hpinfo drop column infoname_2
/
