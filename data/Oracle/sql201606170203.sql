ALTER TABLE CRM_CustomerInfo modify name varchar(200)
/
update CRM_CustomerDefinField set fielddbtype='varchar(200)' where usetable='CRM_CustomerInfo' and fieldname='name'
/