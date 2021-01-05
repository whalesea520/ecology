ALTER PROCEDURE updateconfigFileManager @labelid INT ,@type INT ,@configtype INT ,@filename VARCHAR (200) ,@filepath VARCHAR (200) ,@fileinfo VARCHAR (500),
 @qcnumber VARCHAR (15) ,@KBversion VARCHAR (30),@isdelete INT AS
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
 isdelete =@isdelete,
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
		isdelete,
		createdate,
		createtime
	)
VALUES
	(
		@labelid ,@type ,@configtype ,@filename ,@filepath ,@qcnumber ,@fileinfo ,@KBversion,@isdelete,
		CONVERT (VARCHAR(10), getdate(), 120),
		CONVERT (VARCHAR(8), getdate(), 114)
	)
END
GO