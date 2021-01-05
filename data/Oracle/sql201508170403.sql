CREATE OR REPLACE PROCEDURE MailResourceFile_Insert (
 mailid_1 INTEGER,
 filename_2 VARCHAR2,
 filetype_3 VARCHAR2,
 filerealpath_4 VARCHAR2,
 iszip_5 CHAR,
 isencrypt_6 CHAR,
 isfileattrachment_7 CHAR,
 fileContentId_8 VARCHAR2,
 isEncoded_9 CHAR,
 filesize_10 INTEGER,
  timeMillis_11 FLOAT,
 flag out INTEGER,
 msg out VARCHAR2,
 thecursor IN OUT cursor_define.weavercursor
) AS
BEGIN
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
  filesize,
  timeMillis
 )
VALUES
 (
  mailid_1,
  filename_2,
  filetype_3,
  filerealpath_4,
  iszip_5,
  isencrypt_6,
  isfileattrachment_7,
  fileContentId_8,
  isEncoded_9,
  filesize_10,
  timeMillis_11
 ) ;
END ;
/