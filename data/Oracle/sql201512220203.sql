create or replace
PROCEDURE workflow_RequestLog_Op(
    requestid1   INTEGER,
    workflowid1  INTEGER,
    nodeid1      INTEGER,
    logtype1     CHAR ,
    operatedate1 CHAR,
    operatetime1 CHAR,
    operator1    INTEGER,
    remark_1 LONG,
    clientip1     CHAR,
    operatortype1 INTEGER,
    destnodeid1   INTEGER,
    operate1 CLOB,
    agentorbyagentid1 INTEGER,
    agenttype1        CHAR,
    showorder1        INTEGER,
    annexdocids1      VARCHAR2,
    requestLogId1     INTEGER,
    signdocids1       VARCHAR2,
    signworkflowids1  VARCHAR2,
    remarklocation    varchar2,
    clientType1       CHAR,
    speechAttachment1 INTEGER,
    handWrittenSign1  INTEGER,
    flag OUT INTEGER ,
    msg OUT VARCHAR2,
    thecursor IN OUT cursor_define.weavercursor )
AS
  count1        INTEGER;
  count2        INTEGER;
  currentdate   CHAR(10);
  currenttime   CHAR(8);
  operatorDept1 INTEGER;
BEGIN
  SELECT TO_CHAR(sysdate,'yyyy-mm-dd') INTO currentdate FROM dual;
  SELECT TO_CHAR(sysdate,'hh24:mi:ss') INTO currenttime FROM dual;
  IF operatortype1 = '0' THEN
    SELECT COUNT(*) INTO count2 FROM hrmresource WHERE id = operator1;
    IF count2 > 0 THEN
      SELECT departmentid INTO operatorDept1 FROM hrmresource WHERE id = operator1;
    ELSE
      SELECT DISTINCT 0 INTO operatorDept1 FROM hrmresource;
    END IF;
  ELSE
    SELECT DISTINCT 0 INTO operatorDept1 FROM hrmresource;
  END IF;
  IF logtype1 = '1' THEN
    SELECT COUNT(*)
    INTO count1
    FROM workflow_requestlog
    WHERE requestid  =requestid1
    AND nodeid       =nodeid1
    AND logtype      =logtype1
    AND operator     = operator1
    AND operatortype = operatortype1;
    IF count1        > 0 THEN
      UPDATE workflow_requestlog
      SET operatedate   = currentdate,
        operatetime     = currenttime,
        remark          = remark_1,
        clientip        = clientip1,
        destnodeid      = destnodeid1,
        annexdocids     =annexdocids1,
        requestLogId    =requestLogId1,
        signdocids      =signdocids1,
        signworkflowids =signworkflowids1,
        remarklocation  =remarklocation,
        isMobile        =clientType1,
        SpeechAttachment=speechAttachment1,
        HandWrittenSign =handWrittenSign1
      WHERE ( requestid =requestid1
      AND nodeid        =nodeid1
      AND logtype       =logtype1
      AND operator      = operator1
      AND operatortype  = operatortype1);
    ELSE
      INSERT
      INTO workflow_requestlog
        (
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
          requestid1,
          workflowid1,
          nodeid1,
          logtype1,
          currentdate,
          currenttime,
          operator1,
          remark_1,
          clientip1,
          operatortype1,
          destnodeid1,
          operate1,
          agentorbyagentid1,
          agenttype1,
          showorder1,
          annexdocids1,
          requestLogId1,
          operatorDept1,
          signdocids1,
          signworkflowids1,
          remarklocation,
          clientType1,
          handWrittenSign1,
          speechAttachment1
        );
    END IF;
    OPEN thecursor FOR SELECT currentdate,
    currenttime FROM dual;
  ELSE
    DELETE workflow_requestlog
    WHERE requestid  =requestid1
    AND nodeid       =nodeid1
    AND (logtype     ='1')
    AND operator     = operator1
    AND operatortype = operatortype1;
    INSERT
    INTO workflow_requestlog
      (
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
        requestid1,
        workflowid1,
        nodeid1,
        logtype1,
        currentdate,
        currenttime,
        operator1,
        remark_1,
        clientip1,
        operatortype1,
        destnodeid1,
        operate1,
        agentorbyagentid1,
        agenttype1,
        showorder1,
        annexdocids1,
        requestLogId1,
        operatorDept1,
        signdocids1,
        signworkflowids1,
        remarklocation,
        clientType1,
        handWrittenSign1,
        speechAttachment1
      );
    OPEN thecursor FOR SELECT currentdate,
    currenttime FROM dual;
  END IF;
END;
/

create or replace
PROCEDURE workflow_RequestLog_Insert_New(
    requestid1   INTEGER,
    workflowid1  INTEGER,
    nodeid1      INTEGER,
    logtype1     CHAR ,
    operatedate1 CHAR,
    operatetime1 CHAR,
    operator1    INTEGER,
    remark_1 LONG,
    clientip1     CHAR,
    operatortype1 INTEGER,
    destnodeid1   INTEGER,
    operate1 CLOB,
    agentorbyagentid1 INTEGER,
    agenttype1        CHAR,
    showorder1        INTEGER,
    annexdocids1      VARCHAR2,
    requestLogId1     INTEGER,
    signdocids1       VARCHAR2,
    signworkflowids1  VARCHAR2,
    clientType1       CHAR,
    speechAttachment1 INTEGER,
    handWrittenSign1  INTEGER,
    flag OUT INTEGER ,
    msg OUT VARCHAR2,
    thecursor IN OUT cursor_define.weavercursor )
AS
BEGIN
  workflow_RequestLog_Op(requestid1, workflowid1, nodeid1, logtype1, operatedate1, operatetime1, operator1, remark_1, clientip1, operatortype1, destnodeid1, operate1, agentorbyagentid1, agenttype1, showorder1, annexdocids1, requestLogId1, signdocids1, signworkflowids1,'', '0', 0, 0, flag, msg, thecursor);

END;
/