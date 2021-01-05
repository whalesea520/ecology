alter table hpelement add isFixationRowHeight char(1) default '0'
GO
alter table hpelement add background varchar(200) default ''
GO
update hpelement set isFixationRowHeight='0',background =''
GO
