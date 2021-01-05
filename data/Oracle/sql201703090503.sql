alter table mailresourcefile add mrf_uuid varchar2(50)
/

update mailresourcefile set mrf_uuid = timeMillis
/

CREATE INDEX mailresourcefile_mrf_uuid ON mailresourcefile(mrf_uuid)
/

drop index MailResourceFile_timeMillis
/

ALTER TABLE mailresourcefile DROP COLUMN timeMillis
/

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
 mrf_uuid_11 VARCHAR2,
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
  mrf_uuid
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
  mrf_uuid_11
 );
END;
/

alter table maildeletefile add mdf_uuid varchar2(50)
/

update maildeletefile set mdf_uuid = timeMillis
/

ALTER TABLE maildeletefile DROP COLUMN timeMillis
/

create index maildeletefile_mdf_uuid on maildeletefile(mdf_uuid)
/