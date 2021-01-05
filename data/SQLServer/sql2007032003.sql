insert into DocSecCategoryDocProperty(secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput,isCustom,scope,scopeid,fieldid)
select 
a.id as secCategoryId,
23+isnull(b.fieldorder,0) as viewindex,
0 as type,
-1 as labelid,
1 as visible,
b.fieldlable+'(×Ô¶¨Òå)' as customName,
1 as columnWidth,
b.ismand as mustInput,
1 as isCustom,
'DocCustomFieldBySecCategory' as scope,
a.id as scopeid,
b.fieldid as fieldid
from DocSecCategory a,
(
select t1.fieldid,t1.fieldlable,t1.ismand,t2.fielddbtype,t2.fieldhtmltype,t2.type,t1.scopeid,t1.fieldorder
from cus_formfield t1, cus_formdict t2
where t1.scope='DocCustomFieldBySecCategory' 
and t1.fieldid=t2.id
) b
where a.id = b.scopeid
and not exists (
select 1 from DocSecCategoryDocProperty where secCategoryId = a.id and isCustom = 1 and scope = 'DocCustomFieldBySecCategory' and scopeid = a.id and fieldid = b.fieldid
)
order by secCategoryId
go