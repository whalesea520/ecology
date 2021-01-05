alter table configPropertiesFile add isdelete int DEFAULT 0
/
alter table configPropertiesFile add propdetailid int
/
alter table configPropertiesFile modify(attrname VARCHAR(500))
/
alter table configPropertiesFile modify(attrvalue VARCHAR(1000))
/