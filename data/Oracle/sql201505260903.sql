update DocSecCategoryShare set operategroup=3,orgid=0,includesub=0 where operategroup is null
/
update DocSecCategoryShare set sharetype=8,custype=-sharetype where sharetype<0
/