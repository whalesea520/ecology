alter table MailResourceFile add filesize int
go

ALTER PROCEDURE MailResourceFile_Insert(
@mailid_1 	int,
@filename_2 	varchar(100),
@filetype_3 	varchar(60),
@filerealpath_4 	varchar(255),
@iszip_5 char(1) ,
@isencrypt_6 	char(1) ,
@isfileattrachment_7 	char(1) ,
@fileContentId_8 	varchar(100) ,
@isEncoded_9 char(1),
@filesize_10 int,
@flag int output, 
@msg varchar(80) output
)
AS INSERT INTO MailResourceFile (
mailid,
filename,
filetype,
filerealpath,
iszip,
isencrypt,
isfileattrachment,
fileContentId,
isEncoded,
filesize
)VALUES( 
@mailid_1,
@filename_2,
@filetype_3,
@filerealpath_4,
@iszip_5 ,
@isencrypt_6,
@isfileattrachment_7,
@fileContentId_8,
@isEncoded_9,
@filesize_10
)

GO
