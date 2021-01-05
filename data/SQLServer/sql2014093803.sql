ALTER TRIGGER task_crm_log ON WorkPlan FOR INSERT,
 DELETE AS DECLARE
	@userid INT ,@workdate CHAR (10) ,@taskid VARCHAR (500) ,@logid INT
IF EXISTS (
	SELECT
		1
	FROM
		inserted
	WHERE
		type_n = 3
)
BEGIN
	SELECT
		@userid = createrid ,@workdate = createdate ,@taskid = crmid ,@logid = id
	FROM
		inserted INSERT INTO task_operateLog (
			userid,
			workdate,
			tasktype,
			taskid,
			logid,
			createdate,
			createtime,
			logtype
		) SELECT
			@userid ,@workdate,
			9,
			id ,@logid,
			CONVERT (CHAR(10), GETDATE(), 23),
			CONVERT (CHAR(10), GETDATE(), 24),
			1
		FROM
			CRM_CustomerInfo
		WHERE
			',' +@taskid + ',' LIKE '%,' + CONVERT (VARCHAR(20), id) + ',%'
		END
		ELSE

		IF EXISTS (
			SELECT
				1
			FROM
				deleted
			WHERE
				type_n = 3
		)
		BEGIN
			SELECT
				@userid = createrid ,@workdate = createdate ,@taskid = crmid ,@logid = id
			FROM
				deleted DELETE
			FROM
				task_operateLog
			WHERE
				logid =@logid
			END
GO