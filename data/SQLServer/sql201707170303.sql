delete from user_default_col where systemid in (select id from system_default_col where pageid='SYS:logList'and text_='��Ŀ')
GO
delete from system_default_col  where pageid='SYS:logList'and text_='��Ŀ'
GO