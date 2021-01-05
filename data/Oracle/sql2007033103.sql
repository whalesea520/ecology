

UPDATE DirAccessPermission SET DocSecCategoryTemplateId = -1 WHERE DocSecCategoryTemplateId is NULL
/


alter table DirAccessPermission add DocSecCategoryTemplateId_temp integer
/
update DirAccessPermission set DocSecCategoryTemplateId_temp=DocSecCategoryTemplateId
/

ALTER TABLE DirAccessPermission 
drop column  DocSecCategoryTemplateId 
/
ALTER TABLE DirAccessPermission 
add  DocSecCategoryTemplateId integer default 0
/
update DirAccessPermission set DocSecCategoryTemplateId=DocSecCategoryTemplateId_temp
/
alter table DirAccessPermission drop column DocSecCategoryTemplateId_temp
/



ALTER TABLE DirAccessPermission 
DROP  primary key 
/

ALTER TABLE DirAccessPermission ADD CONSTRAINT
PK_DirAccessPermission PRIMARY KEY 
(
	dirid,
	dirtype,
	userid,
	usertype,
	DocSecCategoryTemplateId
)
/

delete from DocSecCategoryCusSearch where id in 
(
select id from
(
select max(id) as id,secCategoryId,docPropertyId,DocSecCategoryTemplateId,count(0) as c 
from DocSecCategoryCusSearch
group by secCategoryId,docPropertyId,DocSecCategoryTemplateId
) a where a.c>1
)
/

UPDATE DocSecCategoryCusSearch SET DocSecCategoryTemplateId = 0 WHERE DocSecCategoryTemplateId is NULL
/


alter table DocSecCategoryCusSearch add secCategoryId_temp integer
/
update DocSecCategoryCusSearch set secCategoryId_temp=secCategoryId
/
ALTER TABLE DocSecCategoryCusSearch
drop column  secCategoryId 
/
ALTER TABLE DocSecCategoryCusSearch
add  secCategoryId integer default 0
/
update  DocSecCategoryCusSearch set secCategoryId=secCategoryId_temp
/
alter table DocSecCategoryCusSearch drop column secCategoryId_temp
/


alter table DocSecCategoryCusSearch add docPropertyId_temp integer
/
update DocSecCategoryCusSearch set docPropertyId_temp=docPropertyId
/
ALTER TABLE DocSecCategoryCusSearch
drop column  docPropertyId 
/
ALTER TABLE DocSecCategoryCusSearch
add  docPropertyId integer default 0
/
update  DocSecCategoryCusSearch set docPropertyId=docPropertyId_temp
/
alter table DocSecCategoryCusSearch drop column docPropertyId_temp
/






alter table DocSecCategoryCusSearch add DocSecCategoryTemplateId_temp integer
/
update DocSecCategoryCusSearch set DocSecCategoryTemplateId_temp=DocSecCategoryTemplateId
/

ALTER TABLE DocSecCategoryCusSearch
drop column  DocSecCategoryTemplateId 
/
ALTER TABLE DocSecCategoryCusSearch
add  DocSecCategoryTemplateId integer default 0
/
update  DocSecCategoryCusSearch set DocSecCategoryTemplateId=DocSecCategoryTemplateId_temp
/
alter table DocSecCategoryCusSearch drop column DocSecCategoryTemplateId_temp
/




ALTER TABLE DocSecCategoryCusSearch ADD CONSTRAINT
PK_DocSecCategoryCusSearch PRIMARY KEY 
(
	secCategoryId,
	docPropertyId,
	DocSecCategoryTemplateId
)
/


