alter table mailresourcefile add mrf_uuid varchar(50)
GO

update mailresourcefile set mrf_uuid = cast(cast(timeMillis as decimal(20,0)) as varchar(50))
GO

CREATE INDEX mailresourcefile_mrf_uuid ON mailresourcefile(mrf_uuid)
GO

declare @name varchar(50)
select  @name =b.name from sysobjects b join syscolumns a on b.id = a.cdefault 
	where a.id = object_id('mailresourcefile') 
and a.name ='timeMillis'
if(@@rowcount > 0)
exec('alter table mailresourcefile drop constraint ' + @name)
GO

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'mr_file_times_idx')
drop index mr_file_times_idx on mailresourcefile
GO

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'MailResourceFile_timeMillis')
drop index MailResourceFile_timeMillis on mailresourcefile
GO

ALTER TABLE mailresourcefile DROP COLUMN timeMillis
GO

ALTER PROCEDURE MailResourceFile_Insert (
	@mailid_1 INT,
	@filename_2 VARCHAR (600),
	@filetype_3 VARCHAR (60),
	@filerealpath_4 VARCHAR (255),
	@iszip_5 CHAR (1),
	@isencrypt_6 CHAR (1),
	@isfileattrachment_7 CHAR (1),
	@fileContentId_8 VARCHAR (100),
	@isEncoded_9 CHAR (1),
	@filesize_10 INT,
	@mrf_uuid_11 varchar(50),
	@flag INT output,
	@msg VARCHAR (80) output
) AS 
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
		@mailid_1,
		@filename_2,
		@filetype_3,
		@filerealpath_4,
		@iszip_5,
		@isencrypt_6,
		@isfileattrachment_7,
		@fileContentId_8,
		@isEncoded_9,
		@filesize_10,
		@mrf_uuid_11
	)
GO

alter table maildeletefile add mdf_uuid varchar(50)
GO

update maildeletefile set mdf_uuid = timeMillis
GO

ALTER TABLE maildeletefile DROP COLUMN timeMillis
GO

create index maildeletefile_mdf_uuid on maildeletefile(mdf_uuid)
GO