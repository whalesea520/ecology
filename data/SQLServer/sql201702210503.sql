ALTER TABLE datashowset ADD CreateDate varchar(10)
GO
ALTER TABLE datashowset ADD CreateTime varchar(8)
GO
ALTER TABLE datashowset ADD ModifyDate varchar(10)
GO
ALTER TABLE datashowset ADD ModifyTime varchar(8)
GO
UPDATE datashowset SET CreateDate=convert(char(10),GetDate(),120),CreateTime=convert(char(10),GetDate(),8),ModifyDate=convert(char(10),GetDate(),120),ModifyTime=convert(char(10),GetDate(),8)
GO
Create TABLE datashowexecutelog (
id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
datashowName  varchar(200),
datashowCount int,
CreateDate varchar(10),
CreateTime varchar(8),
ModifyDate varchar(10),
ModifyTime varchar(8)
)
GO