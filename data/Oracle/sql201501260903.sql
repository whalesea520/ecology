alter table user_default_col add  onlyWidth integer default 0
/
alter table user_default_col add  width_ varchar2(10)
/
update user_default_col set onlyWidth=0
/