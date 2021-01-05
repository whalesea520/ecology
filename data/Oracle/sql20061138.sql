alter table MailResourceFile add filesize integer
/

create or replace PROCEDURE MailResourceFile_Insert(
mailid_1 	integer,
filename_2 	varchar2,
filetype_3 	varchar2,
filerealpath_4 	varchar2,
iszip_5 char,
isencrypt_6 	char,
isfileattrachment_7 	char,
fileContentId_8 	varchar2,
isEncoded_9 char,
filesize_10 integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin
INSERT INTO MailResourceFile (
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
mailid_1,
filename_2,
filetype_3,
filerealpath_4,
iszip_5 ,
isencrypt_6,
isfileattrachment_7,
fileContentId_8,
isEncoded_9,
filesize_10
);
end;
/
