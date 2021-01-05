exec sp_rename 'system_default_col._column','column_'
GO
exec sp_rename 'system_default_col._text','text_'
GO
alter table system_default_col add hide_ varchar(10)
GO