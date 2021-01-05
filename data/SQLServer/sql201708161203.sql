alter table configXmlFile add xpath VARCHAR(500) 
GO
alter table configXmlFile add isdelete int DEFAULT 0
GO
alter table configXmlFile add xmldetailid int
GO