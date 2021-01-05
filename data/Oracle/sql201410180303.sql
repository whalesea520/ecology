UPDATE CRM_CustomerDefinField SET issearch = 1 WHERE usetable = 'CRM_CustomerInfo'
and fieldname IN ('name','address1','city','county','introduction','status',
'type','description','size_n','source','sector','manager','agent','parentid','firstname','phone','mobilephone'
)
/

UPDATE CRM_CustomerDefinField SET issearch = 1 WHERE usetable = 'CRM_CustomerContacter'
and fieldname IN ('firstname','title','lastName','jobtitle','email','phoneoffice',
'phonehome','mobilephone','fax','imcode','main','isperson')
/