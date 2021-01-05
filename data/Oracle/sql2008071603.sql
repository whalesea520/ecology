alter table hpelement add isFixationRowHeight char(1) default '0'
/
alter table hpelement add background varchar(200) default ''
/
update hpelement set isFixationRowHeight='0',background=''
/
