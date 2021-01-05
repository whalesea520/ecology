alter table cowork_discuss add tmp_c varchar2(4000) null
/
update cowork_discuss set tmp_c=remark
/
alter table cowork_discuss drop column remark
/
alter table cowork_discuss add remark clob null
/
update cowork_discuss set remark=tmp_c
/
alter table cowork_discuss drop column tmp_c
/