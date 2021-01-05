alter table CRM_CustomerDefinField add isexport number
/
update CRM_CustomerDefinField set isexport=isopen where usetable='CRM_CustomerInfo' and fieldhtmltype<6
/