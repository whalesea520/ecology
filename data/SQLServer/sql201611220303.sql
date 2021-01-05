alter table SOCIAL_IMCONVERSATION add msgcontent_bk nvarchar(4000)
GO
update SOCIAL_IMCONVERSATION set msgcontent_bk = msgcontent
GO
alter table SOCIAL_IMCONVERSATION drop column msgcontent
GO
EXEC sp_rename 'SOCIAL_IMCONVERSATION.[msgcontent_bk]', 'msgcontent', 'COLUMN'
GO