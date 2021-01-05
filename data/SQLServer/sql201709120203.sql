alter table configFileManager add configtype int DEFAULT 1
GO
update configFileManager set configtype=1
GO
ALTER PROCEDURE updateconfigFileManager @labelid INT ,@type INT ,@configtype INT ,@filename VARCHAR (200) ,@filepath VARCHAR (200) ,@fileinfo VARCHAR (500),
 @qcnumber VARCHAR (15) ,@KBversion VARCHAR (30) AS
BEGIN
IF EXISTS (
	SELECT
		1
	FROM
		configFileManager
	WHERE
		labelid =@labelid
) UPDATE configFileManager
SET filetype =@type,
 configtype =@configtype,
 filename =@filename,
 filepath =@filepath,
 qcnumber =@qcnumber,
 fileinfo =@fileinfo,
 kbversion =@KBversion,
 createdate = CONVERT (VARCHAR(10), getdate(), 120),
 createtime = CONVERT (VARCHAR(8), getdate(), 114)
WHERE
	labelid =@labelid
ELSE
	INSERT INTO configFileManager (
		labelid,
		filetype,
		configtype,
		filename,
		filepath,
		qcnumber,
		fileinfo,
		kbversion,
		createdate,
		createtime
	)
VALUES
	(
		@labelid ,@type ,@configtype ,@filename ,@filepath ,@qcnumber ,@fileinfo ,@KBversion,
		CONVERT (VARCHAR(10), getdate(), 120),
		CONVERT (VARCHAR(8), getdate(), 114)
	)
END
GO