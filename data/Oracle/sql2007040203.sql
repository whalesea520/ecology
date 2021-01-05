
ALTER TABLE DirAccessPermission 
DROP  primary key 
/
ALTER TABLE DirAccessPermission 
drop column  DocSecCategoryTemplateId 
/
ALTER TABLE DirAccessPermission 
add  DocSecCategoryTemplateId integer default -1
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