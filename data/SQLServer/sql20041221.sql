ALTER TABLE MailResource ADD hasHtmlImage char(1)
GO

ALTER TABLE MailResourceFile ADD isfileattrachment char(1),fileContentId varchar(100)
GO

ALTER    PROCEDURE MailResource_Insert 
	(@resourceid_2 	[int],
	 @priority_3 	[char](1),
	 @sendfrom_4 	[varchar](200),
	 @sendcc_5 	[varchar](200),
	 @sendbcc_6 	[varchar](200),
	 @sendto_7 	[varchar](200),
	 @senddate_8 	[varchar](30),
	 @size_9 	[int],
	 @subject_10 	[varchar](250),
	 @content_11 	[text],
	 @mailtype_12	[char](1) ,
	 @hasHtmlImage_13	[char](1) ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [MailResource] 
	 ([resourceid],
	 [priority],
	 [sendfrom],
	 [sendcc],
	 [sendbcc],
	 [sendto],
	 [senddate],
	 [size_n],
	 [subject],
	 [content],
	 mailtype,
	 [hasHtmlImage]) 
 
VALUES 
	(@resourceid_2,
	 @priority_3,
	 @sendfrom_4,
	 @sendcc_5,
	 @sendbcc_6,
	 @sendto_7,
	 @senddate_8,
	 @size_9,
	 @subject_10,
	 @content_11,
	 @mailtype_12,
	 @hasHtmlImage_13)
	

select max(id) from MailResource

GO


ALTER  PROCEDURE MailResourceFile_Insert
	(@mailid_1 	int,
	 @filename_2 	varchar(100),
	 @filetype_3 	varchar(60),
	 @filerealpath_4 	varchar(255),
         @iszip_5 char(1) ,
	 @isencrypt_6 	char(1) ,
	 @isfileattrachment_7 	char(1) ,
	 @fileContentId_8 	varchar(100) ,
         @flag int output, 
         @msg varchar(80) output)

AS INSERT INTO MailResourceFile 
	 (mailid,
	 filename,
	 filetype,
	 filerealpath,
         iszip,
	 isencrypt,
	 isfileattrachment,
	 fileContentId) 
 
VALUES 
	( @mailid_1,
	 @filename_2,
	 @filetype_3,
	 @filerealpath_4,
         @iszip_5 ,
         @isencrypt_6,
	 @isfileattrachment_7,
	 @fileContentId_8)

GO
