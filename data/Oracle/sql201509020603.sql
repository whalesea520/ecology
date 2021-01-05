update CRM_MapReport set sqlstr1 = 'select t2.provincename as province,count(t1.id) as amount from (#crmsql#) t1,HrmProvince t2,HrmCity t3
where t1.city=t3.id and t3.provinceid=t2.id  and (t1.deleted=0 or t1.deleted is null)  and t2.countryid=1
and t1.createdate>=''#datefrom#'' and t1.createdate<=''#dateto#'' and t1.createdate is not null
group by t2.provincename order by amount desc,t2.provincename',
sqlstr2 = 'select t3.cityname as city,t2.provincename as province,count(t1.id) as amount from (#crmsql#) t1,HrmProvince t2,HrmCity t3
where t1.city=t3.id and t3.provinceid=t2.id and (t1.deleted=0 or t1.deleted is null) and t2.countryid=1
and t1.createdate>=''#datefrom#'' and t1.createdate<=''#dateto#'' and t1.createdate is not null
group by t3.id,t3.cityname,t2.provincename order by amount desc,t2.provincename,t3.cityname'
/