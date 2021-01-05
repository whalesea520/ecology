ALTER TABLE ImageFile 
	Add fileSize varchar(20) DEFAULT '0' /*文件大小，bytes*/
GO


ALTER TABLE ImageFile 
	Add downloads INT DEFAULT 0 NOT NULL/* 下载次数*/
GO


alter PROCEDURE ImageFile_Insert
	(@imagefileid_1 	int,
	 @imagefilename_2 	varchar(200),
	 @imagefiletype_3 	varchar(50),
	 @imagefileused_4 	int,
	 @filerealpath_5 	varchar(255),
     @iszip_6 char(1) ,
	 @isencrypt_7 	char(1) ,
     @fileSize_8  varchar(20) ,
     @flag int output, 
     @msg varchar(80) output)

AS INSERT INTO ImageFile 
	 ( imagefileid,
	 imagefilename,
	 imagefiletype,
	 imagefileused,
	 filerealpath,
     iszip,
	 isencrypt,
     filesize) 
 
VALUES 
	( @imagefileid_1,
	 @imagefilename_2,
	 @imagefiletype_3,
	 @imagefileused_4,
	 @filerealpath_5,
     @iszip_6,
	 @isencrypt_7,
     @fileSize_8)
GO
