delete from  configXmlFile where configFileid in (select id from configFileManager  WHERE labelid='17')
go
delete from configFileManager  WHERE labelid='17'
go