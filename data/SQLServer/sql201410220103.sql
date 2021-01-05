alter table imagefiletemppic add docfiletype varchar(2)
GO
update  imagefiletemppic  set docfiletype='1'
GO
Alter  PROCEDURE DocImageFile_DByDocfileid
	(@docid_1 	int ,
     @imagefileid_2 	int ,
     @flag int output, 
     @msg varchar(80) output)
AS 
delete from DocImageFile where imagefileid=@imagefileid_2 and docid=@docid_1
update ImageFile set imagefileused=imagefileused-1 where imagefileid = @imagefileid_2  
	Declare @AccessoryCount int;
	Select @AccessoryCount = Count(*) From DocImageFile where docid = @docid_1 and docfiletype<>'1'  and docfiletype<>'11' and isextfile = '1'
	Update Docdetail set accessorycount= @AccessoryCount where id = @docid_1 
select filerealpath from  ImageFile where imagefileid=@imagefileid_2 and imagefileused = 0
delete ImageFile where imagefileid=@imagefileid_2 and imagefileused = 0 
GO
Alter PROCEDURE DocImageFile_SelectByDocid 
 (
   @docid_1   int, 
   @flag int output, 
   @msg varchar(80) output
 ) 
  AS   
  select d2.* from DocImageFile d2 
  where  d2.docid= @docid_1 and d2.docfiletype<>'1'  and d2.docfiletype<>'11' and d2.isextfile = '1'
  order by d2.id, versionId desc
GO