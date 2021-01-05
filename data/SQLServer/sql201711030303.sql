alter table configFileManager add isdelete int DEFAULT 0
GO
update configFileManager set isdelete = 0
GO