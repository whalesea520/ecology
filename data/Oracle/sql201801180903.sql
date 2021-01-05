delete from  configXmlFile where configFileid in (select id from configFileManager  WHERE labelid='17')
/
delete from configFileManager  WHERE labelid='17'
/