alter table configFileManager add isdelete int DEFAULT 0
/
update configFileManager set isdelete = 0
/
