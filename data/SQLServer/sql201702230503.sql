Create TABLE ActionExecuteLog (
id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
actionid varchar(8000) ,
actiontype int,
datashowCount int,
CreateDate varchar(10),
CreateTime varchar(8)
)
GO
ALTER TABLE actionsetting ADD CreateDate varchar(10)
GO
ALTER TABLE actionsetting ADD CreateTime varchar(8)
GO
ALTER TABLE actionsetting ADD ModifyDate varchar(10)
GO
ALTER TABLE actionsetting ADD ModifyTime varchar(8)
GO
update actionsetting set CreateDate=convert(char(10),getdate(),120),ModifyDate=convert(char(10),getdate(),120),CreateTime=convert(char(8),getdate(),108),ModifyTime=convert(char(8),getdate(),108)
GO


ALTER TABLE formactionset ADD CreateDate varchar(10)
GO
ALTER TABLE formactionset ADD CreateTime varchar(8)
GO
ALTER TABLE formactionset ADD ModifyDate varchar(10)
GO
ALTER TABLE formactionset ADD ModifyTime varchar(8)
GO
update formactionset set CreateDate=convert(char(10),getdate(),120),ModifyDate=convert(char(10),getdate(),120),CreateTime=convert(char(8),getdate(),108),ModifyTime=convert(char(8),getdate(),108)
GO
ALTER TABLE wsformactionset ADD CreateDate varchar(10)
GO
ALTER TABLE wsformactionset ADD CreateTime varchar(8)
GO
ALTER TABLE wsformactionset ADD ModifyDate varchar(10)
GO
ALTER TABLE wsformactionset ADD ModifyTime varchar(8)
GO
update wsformactionset set CreateDate=convert(char(10),getdate(),120),ModifyDate=convert(char(10),getdate(),120),CreateTime=convert(char(8),getdate(),108),ModifyTime=convert(char(8),getdate(),108)
GO
