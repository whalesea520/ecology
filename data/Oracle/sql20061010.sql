update DocSecCategoryDocProperty set viewindex = viewindex + 1 where viewindex > 8
/
insert into DocSecCategoryDocProperty
(secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput,isCustom,scope,scopeid,fieldid)
(select distinct secCategoryId,9,21,2094,1,'',1,1,0,'',0,0 from DocSecCategoryDocProperty where seccategoryid in (select id from docseccategory))
/

insert into DocSecCategoryDocProperty
(secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput,isCustom,scope,scopeid,fieldid,DocSecCategoryTemplateId)
(select distinct 0,9,21,2094,1,'',1,1,0,'',0,0,DocSecCategoryTemplateId from DocSecCategoryDocProperty where DocSecCategoryTemplateId in (select id from DocSecCategoryTemplate))
/
