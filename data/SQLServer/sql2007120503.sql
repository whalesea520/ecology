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

  @flag int output, @msg varchar(80) output) 
  
  
  
  AS INSERT INTO DocImageFile ( docid, imagefileid, imagefilename, imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, docfiletype,versionId,versionDetail,id)  VALUES ( @docid_1, @imagefileid_2, @imagefilename_3, @imagefiledesc_4, @imagefilewidth_5, @imagefileheight_6, @imagefielsize_7, @docfiletype_8,@versionId_9,@versionDetail_10,@docImageId_11)

GO

  alter PROCEDURE DocImageFile_UpdateByDocid (@docid_1 	int, @imagefileid_2 	int, @imagefilename_3 	varchar(200), @imagefiledesc_4 	varchar(200), @imagefilewidth_5 	int, @imagefileheight_6 	int, @imagefielsize_7 	int, @docfiletype_8 	char(1),@versionId_9	int,@versionDetail_10	varchar(100) , @flag int output, @msg varchar(80) output)  AS UPDATE DocImageFile set imagefileid=@imagefileid_2, imagefilename=@imagefilename_3, imagefiledesc=@imagefiledesc_4, imagefilewidth=@imagefilewidth_5, imagefileheight=@imagefileheight_6, imagefielsize=@imagefielsize_7, docfiletype=@docfiletype_8,versionId=@versionId_9,versionDetail=@versionDetail_10 where docid=@docid_1 and versionId=(select max(versionId) from DocImageFile where docid=@docid_1)
GO


  alter PROCEDURE DocImageFile_UpdateByDocidVid (@docid_1 	int, @imagefileid_2 	
  int, @imagefilename_3 	varchar(200), @imagefiledesc_4 	varchar(200), 
  @imagefilewidth_5 	int, @imagefileheight_6 	int, 
  @imagefielsize_7 	int, @docfiletype_8 	char(1),@versionId_9 int, @versionDetail_10	varchar(100) , @flag int output, @msg varchar(80)   output)  AS UPDATE DocImageFile set imagefileid=@imagefileid_2,   imagefilename=@imagefilename_3, imagefiledesc=@imagefiledesc_4,   imagefilewidth=@imagefilewidth_5, imagefileheight=@imagefileheight_6,   imagefielsize=@imagefielsize_7,   docfiletype=@docfiletype_8,versionId=@versionId_9,versionDetail=@versionDetail_10 where docid=@docid_1 and versionId=@versionId_9 
  GO
