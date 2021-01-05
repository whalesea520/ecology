update DocMould set mouldtype='0' where mouldType is null
GO
update DocMouldFile set mouldtype='0' where mouldType is null
GO

ALTER PROCEDURE imagefile_DeleteByDoc (
@fileid 	int, 
@flag	[int]	output, 
@msg	[varchar](80)	output)  
AS 

update imagefile set imagefileused=imagefileused-1 where imagefileid= @fileid 
select filerealpath from  ImageFile where imagefileid=@fileid and imagefileused = 0
delete ImageFile where imagefileid=@fileid and imagefileused = 0 

GO
