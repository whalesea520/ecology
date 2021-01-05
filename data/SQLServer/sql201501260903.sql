alter table user_default_col add  onlyWidth int default 0
GO
alter table user_default_col add  width_ varchar(10)
GO
update user_default_col set onlyWidth=0
GO