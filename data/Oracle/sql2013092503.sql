CREATE or REPLACE PROCEDURE workflow_CurrentOperator_I2(
    requestid1 INTEGER,
    userid1    INTEGER,
    groupid1 IN OUT INTEGER,
    workflowid1      INTEGER,
    workflowtype1    INTEGER,
    usertype1        INTEGER,
    isremark1        CHAR ,
    nodeid           INTEGER,
    agentorbyagentid INTEGER,
    agenttype        CHAR,
    showorder        INTEGER,
    groupdetailid_1  INTEGER,
    currentdate CHAR,
    currenttime CHAR,
    flag OUT INTEGER ,
    msg OUT VARCHAR2,
    thecursor IN OUT cursor_define.weavercursor )
AS
  workflowtype2 INTEGER;
BEGIN
  IF groupid1 IS NULL THEN
    groupid1  := 0 ;
  END IF ;
  UPDATE workflow_currentoperator
  SET islasttimes  =0
  WHERE requestid  =requestid1
  AND userid       =userid1
  AND usertype     = usertype1;
  IF workflowtype1 = '' OR workflowtype1 IS NULL THEN
    SELECT workflowtype
    INTO workflowtype2
    FROM workflow_base
    WHERE id = workflowid1;
    INSERT
    INTO workflow_currentoperator
      (
        requestid,
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
        needwfback
      )
      VALUES
      (
        requestid1,
        userid1,
        groupid1,
        workflowid1,
        workflowtype2,
        usertype1,
        isremark1,
        nodeid,
        agentorbyagentid,
        agenttype,
        showorder,
        currentdate,
        currenttime,
        0,0,1,
        groupdetailid_1,
        isremark1,
        '1'
      );
  ELSE
    INSERT
    INTO workflow_currentoperator
      (
        requestid,
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
        needwfback
      )
      VALUES
      (
        requestid1,
        userid1,
        groupid1,
        workflowid1,
        workflowtype1,
        usertype1,
        isremark1,
        nodeid,
        agentorbyagentid,
        agenttype,
        showorder,
        currentdate,
        currenttime,
        0,0,1,
        groupdetailid_1,
        isremark1,
        '1'
      );
  END IF ;
END;
/