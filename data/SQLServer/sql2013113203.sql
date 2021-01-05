CREATE PROCEDURE Doc_isUsedCustomSearch (
@id	int, 
@flag	int output, 
@msg	varchar(80)	output) 
as select useCustomSearch from docseccategory where id=@id 
GO