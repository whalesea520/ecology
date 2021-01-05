alter table votingoption add tmp_description varchar(4000)
/
update votingoption set tmp_description = description
/
update votingoption set description = null 
/
alter table votingoption modify description varchar(4000)
/
update votingoption set description =tmp_description 
/
alter table votingoption drop column  tmp_description
/

alter table votingquestion modify subject  varchar(4000)
/
