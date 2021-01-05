insert into DocSecCategoryDocProperty
(secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput,isCustom,scope,scopeid,fieldid)
(select distinct secCategoryId,22,22,19547,1,'',1,0,0,'',0,0 from DocSecCategoryDocProperty where seccategoryid in (select id from docseccategory))
GO

insert into DocSecCategoryDocProperty
(secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput,isCustom,scope,scopeid,fieldid,DocSecCategoryTemplateId)
(select distinct 0,22,22,19547,1,'',1,0,0,'',0,0,DocSecCategoryTemplateId from DocSecCategoryDocProperty where DocSecCategoryTemplateId in (select id from DocSecCategoryTemplate))
GO

ALTER TABLE DocDetail ADD	invalidationdate char(10) NULL
GO