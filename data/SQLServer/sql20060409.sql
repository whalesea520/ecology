Alter  PROCEDURE DocImageFile_DByDocfileid
	(@docid_1 	int ,
     @imagefileid_2 	int ,
     @flag int output, 
     @msg varchar(80) output)

AS 
delete from DocImageFile where imagefileid=@imagefileid_2 and docid=@docid_1
update ImageFile set imagefileused=imagefileused-1 where imagefileid = @imagefileid_2  
delete ImageFile where imagefileid=@imagefileid_2 and imagefileused = 0

	Declare @AccessoryCount int;
	Select @AccessoryCount = Count(*) From DocImageFile where docid = @docid_1 and docfiletype<>'1'
	Update Docdetail set accessorycount= @AccessoryCount where id = @docid_1 

GO

