alter table CRM_CustomerDefinField add isdisplay int
GO
update CRM_CustomerDefinField set isdisplay=1 where usetable='CRM_CustomerInfo' and fieldname in (select name from system_default_col where pageid ='CRM:CustomerList' and isdefault=1)
GO