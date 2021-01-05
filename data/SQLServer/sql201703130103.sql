alter table CRM_CustomerDefinField add isexport int
go
update CRM_CustomerDefinField set isexport=isopen where usetable='CRM_CustomerInfo' and fieldhtmltype<6
go