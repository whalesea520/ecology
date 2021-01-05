CREATE PROCEDURE Workflow_currentoperator_I2(
						   @requestid        INT,
                                                   @userid           INT,
                                                   @groupid          INT,
                                                   @workflowid       INT,
                                                   @workflowtype     INT,
                                                   @usertype         INT,
                                                   @isremark         CHAR(1),
                                                   @nodeid           INT,
                                                   @agentorbyagentid INT,
                                                   @agenttype        CHAR(1),
                                                   @showorder        INT,
                                                   @groupdetailid    INT,
                                                   @currentdate      CHAR(10),
                                                   @currenttime      CHAR(8),
                                                   @flag             INTEGER output,
                                                   @msg              VARCHAR(80) output)
AS
  DECLARE @workflowtype1 INTEGER
  
  UPDATE workflow_currentoperator
  SET    islasttimes = 0
  WHERE  requestid = @requestid
         AND userid = @userid
         AND usertype = @usertype

  IF @workflowtype = ''
    BEGIN
        SELECT @workflowtype1 = workflowtype
        FROM   workflow_base
        WHERE  id = @workflowid

        INSERT INTO workflow_currentoperator
                    (requestid,
                     userid,
                     groupid,
                     workflowid,
                     workflowtype,
                     usertype,
                     isremark,
                     nodeid,
                     agentorbyagentid,
                     agenttype,
                     showorder,
                     receivedate,
                     receivetime,
                     viewtype,
                     iscomplete,
                     islasttimes,
                     groupdetailid,
                     preisremark,
                     needwfback)
        VALUES      (@requestid,
                     @userid,
                     @groupid,
                     @workflowid,
                     @workflowtype1,
                     @usertype,
                     @isremark,
                     @nodeid,
                     @agentorbyagentid,
                     @agenttype,
                     @showorder,
                     @currentdate,
                     @currenttime,
                     0,
                     0,
                     1,
                     @groupdetailid,
                     @isremark,
                     '1')
    END
  ELSE
    BEGIN
        INSERT INTO workflow_currentoperator
                    (requestid,
                     userid,
                     groupid,
                     workflowid,
                     workflowtype,
                     usertype,
                     isremark,
                     nodeid,
                     agentorbyagentid,
                     agenttype,
                     showorder,
                     receivedate,
                     receivetime,
                     viewtype,
                     iscomplete,
                     islasttimes,
                     groupdetailid,
                     preisremark,
                     needwfback)
        VALUES      (@requestid,
                     @userid,
                     @groupid,
                     @workflowid,
                     @workflowtype,
                     @usertype,
                     @isremark,
                     @nodeid,
                     @agentorbyagentid,
                     @agenttype,
                     @showorder,
					 @currentdate,
                     @currenttime,
                     0,
                     0,
                     1,
                     @groupdetailid,
                     @isremark,
                     '1')
    END 

GO