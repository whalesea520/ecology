alter table cowork_items add remark_1 clob
/
update cowork_items set remark_1 = remark
/
alter table cowork_items drop column remark
/
alter table cowork_items  rename column remark_1 to remark
/