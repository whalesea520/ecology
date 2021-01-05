
ALTER PROCEDURE DocDetail_SelectCountByOwner 
(@id_1  int, @flag    integer output, @msg   varchar(80) output ) 
AS 
select count(*) from DocDetail where ownerid = @id_1 and  maincategory!=0  and subcategory!=0 and seccategory!=0
GO

