If exists(Select * from SysObjects where name = 'ImageFile_Insert_New' and xtype = 'P')
  drop PROCEDURE ImageFile_Insert_New;
  
GO 

Create PROCEDURE [dbo].ImageFile_Insert_New 
(@imagefileid_1   int, @imagefilename_2   varchar(200), @imagefiletype_3   varchar(200), 
 @imagefileused_4   int, @filerealpath_5   varchar(255), @iszip_6 char(1) , 
 @isencrypt_7   char(1) , @fileSize_8  varchar(20) , @isaesencrypt_9 int, 
 @aescode_10 varchar(200),  @flag int output, @msg varchar(80) output)  
AS 
 INSERT INTO ImageFile ( imagefileid, imagefilename, imagefiletype, imagefileused, 
 filerealpath, iszip, isencrypt, filesize, isaesencrypt, aescode)  VALUES ( @imagefileid_1, @imagefilename_2, 
 @imagefiletype_3, @imagefileused_4, @filerealpath_5, @iszip_6, @isencrypt_7, @fileSize_8, 
 @isaesencrypt_9, @aescode_10);
 
GO