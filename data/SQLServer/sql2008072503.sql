alter table docimagefile add isextfile char(1) default '1' null
GO
update docimagefile set isextfile=1
GO
update docimagefile set isextfile=0 where docid in (select id as docid from docdetail where doctype <> 1)
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
	Select @AccessoryCount = Count(*) From DocImageFile where docid = @docid_1 and docfiletype<>'1' and isextfile = '1'
	Update Docdetail set accessorycount= @AccessoryCount where id = @docid_1 

select filerealpath from  ImageFile where imagefileid=@imagefileid_2 and imagefileused = 0
delete ImageFile where imagefileid=@imagefileid_2 and imagefileused = 0 
GO

ALTER PROCEDURE DocImageFile_DByDocid
	(@docid_1 	int ,
     @flag int output, 
     @msg varchar(80) output)

AS 
declare @imagefileid_2 int
declare imagefileid_cursor cursor for 
select imagefileid from DocImageFile where docid=@docid_1 and isextfile = '1'
open imagefileid_cursor 
fetch next from imagefileid_cursor into @imagefileid_2 
while @@fetch_status=0 
begin 
    update ImageFile set imagefileused=imagefileused-1 where imagefileid = @imagefileid_2  
    fetch next from imagefileid_cursor into @imagefileid_2 
end 
close imagefileid_cursor 
deallocate imagefileid_cursor
delete from DocImageFile where docid=@docid_1
select filerealpath from ImageFile where imagefileused = 0 
delete ImageFile where imagefileused = 0

GO

alter  PROCEDURE DocImageFile_Insert (
  @docid_1 	int, 
  @imagefileid_2 	int, 
  @imagefilename_3 	varchar(200),
  @imagefiledesc_4 	varchar(200),
  @imagefilewidth_5 	int,
  @imagefileheight_6 	int,
  @imagefielsize_7 	int,
  @docfiletype_8 	char(1),
  @versionId_9	int,
  @versionDetail_10	varchar(100) ,
  @docImageId_11	int,
  @isextfile_12		varchar(1),

  @flag int output, @msg varchar(80) output) 
  
  
  
  AS INSERT INTO DocImageFile ( docid, imagefileid, imagefilename, imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, docfiletype,versionId,versionDetail,id, isextfile)  VALUES ( @docid_1, @imagefileid_2, @imagefilename_3, @imagefiledesc_4, @imagefilewidth_5, @imagefileheight_6, @imagefielsize_7, @docfiletype_8,@versionId_9,@versionDetail_10,@docImageId_11, @isextfile_12)

GO

Alter PROCEDURE DocImageFile_SelectByDocid 
 (
 @docid_1   int, 
 @flag int output, 
 @msg varchar(80) output
 ) 
  AS   
  select d2.* from DocImageFile d2 
  where  d2.docid= @docid_1 and d2.docfiletype<>'1' and d2.isextfile = '1'
  order by d2.id, versionId desc
GO
