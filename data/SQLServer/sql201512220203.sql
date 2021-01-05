CREATE PROCEDURE workflow_RequestLog_Op @requestid INT,
 @workflowid INT,
 @nodeid INT,
 @logtype CHAR (1),
 @operatedate CHAR (10),
 @operatetime CHAR (8),
 @operator INT,
 @remark TEXT,
 @clientip CHAR (15),
 @operatortype INT,
 @destnodeid INT,
 @operate VARCHAR (4000),
 @agentorbyagentid INT ,@agenttype CHAR (1) ,@showorder INT ,@annexdocids VARCHAR (4000),
 @requestLogId INT ,@signdocids VARCHAR (4000) ,@signworkflowids VARCHAR (4000) ,@remarklocation VARCHAR (4000), @clientType CHAR (1),
 @speechAttachment INT ,@handWrittenSign INT ,@flag INTEGER OUTPUT,
 @msg VARCHAR (4000) OUTPUT AS DECLARE
	@COUNT INTEGER,
	@currentdate CHAR (10),
	@currenttime CHAR (8),
	@operatorDept INTEGER
SET @currentdate = CONVERT (CHAR(10), getdate(), 20)
SET @currenttime = CONVERT (CHAR(8), getdate(), 108)
IF @operatortype = '0'
BEGIN
	SELECT
		@operatorDept = departmentid
	FROM
		hrmresource
	WHERE
		id = @operator
	END
	ELSE

	BEGIN

	SET @operatorDept = 0
	END
	IF @logtype = '1'
	BEGIN
		SELECT
			@COUNT = COUNT (*)
		FROM
			workflow_requestlog
		WHERE
			requestid =@requestid
		AND nodeid =@nodeid
		AND logtype =@logtype
		AND operator = @operator
		AND operatortype = @operatortype
		IF @COUNT > 0
		BEGIN
			UPDATE workflow_requestlog
		SET [operatedate] = @currentdate,
		[operatetime] = @currenttime,
		[remark] = @remark,
		[clientip] = @clientip,
		[destnodeid] = @destnodeid,
		annexdocids =@annexdocids,
		requestLogId =@requestLogId,
		signdocids =@signdocids,
		signworkflowids =@signworkflowids,
		remarklocation =@remarklocation,
		isMobile =@clientType,
		SpeechAttachment =@speechAttachment,
		HandWrittenSign =@handWrittenSign
	WHERE
		(
			[requestid] = @requestid
			AND [nodeid] = @nodeid
			AND [logtype] = @logtype
			AND [operator] = @operator
			AND [operatortype] = @operatortype
		)
	END
	ELSE

	BEGIN
		INSERT INTO workflow_requestlog (
			requestid,
			workflowid,
			nodeid,
			logtype,
			operatedate,
			operatetime,
			operator,
			remark,
			clientip,
			operatortype,
			destnodeid,
			receivedPersons,
			agentorbyagentid,
			agenttype,
			showorder,
			annexdocids,
			requestLogId,
			operatorDept,
			signdocids,
			signworkflowids,
			remarklocation,
			isMobile,
			HandWrittenSign,
			SpeechAttachment
		)
	VALUES
		(
			@requestid ,@workflowid ,@nodeid ,@logtype,
			@currentdate ,@currenttime ,@operator,
			@remark ,@clientip ,@operatortype ,@destnodeid ,@operate ,@agentorbyagentid ,@agenttype ,@showorder ,@annexdocids ,@requestLogId ,@operatorDept ,@signdocids ,@signworkflowids,
			@remarklocation ,@clientType ,@handWrittenSign ,@speechAttachment
		)
	END SELECT
		@currentdate ,@currenttime
	FROM
		workflow_requestlog
	WHERE
		requestid =@requestid
	END
	ELSE

	BEGIN
		DELETE workflow_requestlog
	WHERE
		requestid =@requestid
	AND nodeid =@nodeid
	AND (logtype = '1')
	AND operator = @operator
	AND operatortype = @operatortype INSERT INTO workflow_requestlog (
		requestid,
		workflowid,
		nodeid,
		logtype,
		operatedate,
		operatetime,
		operator,
		remark,
		clientip,
		operatortype,
		destnodeid,
		receivedPersons,
		agentorbyagentid,
		agenttype,
		showorder,
		annexdocids,
		requestLogId,
		operatorDept,
		signdocids,
		signworkflowids,
		remarklocation,
		isMobile,
		HandWrittenSign,
		SpeechAttachment
	)
	VALUES
		(
			@requestid ,@workflowid ,@nodeid ,@logtype,
			@currentdate ,@currenttime ,@operator,
			@remark ,@clientip ,@operatortype ,@destnodeid ,@operate ,@agentorbyagentid ,@agenttype ,@showorder ,@annexdocids ,@requestLogId ,@operatorDept ,@signdocids ,@signworkflowids ,@remarklocation, @clientType ,@handWrittenSign ,@speechAttachment
		) SELECT
			@currentdate ,@currenttime
		FROM
			workflow_requestlog
		WHERE
			requestid =@requestid
		END
GO

ALTER PROCEDURE workflow_RequestLog_Insert_New @requestid INT,
 @workflowid INT,
 @nodeid INT,
 @logtype CHAR (1),
 @operatedate CHAR (10),
 @operatetime CHAR (8),
 @operator INT,
 @remark TEXT,
 @clientip CHAR (15),
 @operatortype INT,
 @destnodeid INT,
 @operate VARCHAR (4000),
 @agentorbyagentid INT ,@agenttype CHAR (1) ,@showorder INT ,@annexdocids VARCHAR (4000),
 @requestLogId INT ,@signdocids VARCHAR (4000) ,@signworkflowids VARCHAR (4000),
 @remarklocation VARCHAR (4000),
 @clientType CHAR (1),
 @speechAttachment INT ,@handWrittenSign INT,
 @flag INTEGER OUTPUT,
 @msg VARCHAR (4000) OUTPUT AS EXEC [workflow_RequestLog_Op] @requestid,
 @workflowid,
 @nodeid,
 @logtype,
 @operatedate,
 @operatetime,
 @operator,
 @remark,
 @clientip,
 @operatortype,
 @destnodeid,
 @operate,
 @agentorbyagentid,
 @agenttype,
 @showorder,
 @annexdocids,
 @requestLogId,
 @signdocids,
 @signworkflowids,
 '',
 '0',
 0,
 0,
 @flag,
 @msg
GO