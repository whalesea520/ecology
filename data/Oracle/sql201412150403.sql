alter table votingresource add tmp_optionid varchar(100)
/
update votingresource set tmp_optionid = optionid
/
update votingresource set optionid = null 
/
alter table votingresource modify optionid varchar(100)
/
update votingresource set optionid =tmp_optionid 
/
alter table votingresource drop column  tmp_optionid
/