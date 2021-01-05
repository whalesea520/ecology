alter table configPropertiesFile add isdelete int DEFAULT 0
GO
alter table configPropertiesFile add propdetailid int
GO
alter table configPropertiesFile alter column attrname VARCHAR(500)
GO
alter table configPropertiesFile alter column attrvalue VARCHAR(1000)
GO