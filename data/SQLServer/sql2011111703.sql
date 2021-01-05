CREATE PROCEDURE Doc_SecCategoryByID (
@id	int, 
@flag	int output, 
@msg	varchar(80)	output) 
as select useCustomSearch from docseccategory where id=@id 
GO