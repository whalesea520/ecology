alter table VOTINGOPTION rename  column remark to remark_tmp
/
alter table VOTINGOPTION add remark clob
/
update VOTINGOPTION set remark=remark_tmp
/
alter table VOTINGOPTION drop column remark_tmp
/