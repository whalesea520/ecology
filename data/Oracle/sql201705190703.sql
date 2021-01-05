update CRM_CustomerDefinField set isdisplay=1 where usetable='CRM_CustomerInfo' and fieldname in('name','status','type','manager')
/