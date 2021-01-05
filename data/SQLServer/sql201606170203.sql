ALTER TABLE CRM_CustomerInfo ALTER COLUMN name varchar(200)
go
update CRM_CustomerDefinField set fielddbtype='varchar(200)' where usetable='CRM_CustomerInfo' and fieldname='name'
go