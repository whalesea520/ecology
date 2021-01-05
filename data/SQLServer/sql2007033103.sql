UPDATE DirAccessPermission SET DocSecCategoryTemplateId = -1 WHERE DocSecCategoryTemplateId is NULL
GO

ALTER TABLE DirAccessPermission 
ALTER COLUMN DocSecCategoryTemplateId int NOT NULL
GO

ALTER TABLE DirAccessPermission 
DROP CONSTRAINT PK_DirAccessPermission
GO

ALTER TABLE DirAccessPermission ADD CONSTRAINT
PK_DirAccessPermission PRIMARY KEY CLUSTERED
(
	dirid,
	dirtype,
	userid,
	usertype,
	DocSecCategoryTemplateId
)
GO

delete from DocSecCategoryCusSearch where id in 
(
select id from
(
select max(id) as id,secCategoryId,docPropertyId,DocSecCategoryTemplateId,count(0) as c 
from DocSecCategoryCusSearch
group by secCategoryId,docPropertyId,DocSecCategoryTemplateId
) a where a.c>1
)
GO

UPDATE DocSecCategoryCusSearch SET DocSecCategoryTemplateId = 0 WHERE DocSecCategoryTemplateId is NULL
GO

ALTER TABLE DocSecCategoryCusSearch 
ALTER COLUMN secCategoryId int NOT NULL
GO

ALTER TABLE DocSecCategoryCusSearch 
ALTER COLUMN docPropertyId int NOT NULL
GO

ALTER TABLE DocSecCategoryCusSearch 
ALTER COLUMN DocSecCategoryTemplateId int NOT NULL
GO

ALTER TABLE DocSecCategoryCusSearch ADD CONSTRAINT
PK_DocSecCategoryCusSearch PRIMARY KEY CLUSTERED
(
	secCategoryId,
	docPropertyId,
	DocSecCategoryTemplateId
)
GO
