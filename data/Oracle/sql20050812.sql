ALTER TABLE workflow_agent ADD agenttype  char(1)
/
ALTER TABLE workflow_agent ADD operatorid  int
/
ALTER TABLE workflow_agent ADD operatordate  char(10)
/
ALTER TABLE workflow_agent ADD operatortime  char(8)
/

INSERT INTO HtmlLabelIndex values(17860,'批量回收') 
/
INSERT INTO HtmlLabelInfo VALUES(17860,'批量回收',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17860,'Countermand Workflow Agent',8) 
/



/*对老数据的处理*/
update workflow_agent set agenttype = 1, operatorid  = workflow_agent.beagenterid
/


CREATE OR REPLACE PROCEDURE Workflow_select_foragent
(userid_1 INTEGER,
usertype_1 INTEGER,
flag OUT INTEGER, msg OUT VARCHAR2,
thecursor IN OUT cursor_define.weavercursor)

AS
   CURRENT_DATE CHAR(10);
   current_time CHAR(8);
BEGIN
   SELECT SUBSTR(TO_CHAR(SYSDATE, 'hh24:mm:ss'), 1, 8) INTO current_time  FROM dual;
   SELECT SUBSTR(TO_CHAR(SYSDATE, 'yyyy-mm-dd'), 1, 10) INTO CURRENT_DATE  FROM dual;
   OPEN thecursor FOR 
   SELECT DISTINCT a.workflowid 
   FROM workflow_createrlist a 
   WHERE (a.isagenter = 0 
   OR a.isagenter IS NULL)
   UNION SELECT DISTINCT a.workflowid 
   FROM workflow_createrlist a, workflow_agent b 
   WHERE a.isagenter = 1 
   AND a.workflowid = b.workflowid 
   AND b.iscreateagenter = 1 
   AND ( (b.begindate IS NULL 
    AND b.enddate IS NULL) 
   OR (b.begindate IS NOT NULL 
    AND b.enddate IS NULL 
   AND b.begindate < CURRENT_DATE ) 
   OR (b.begindate IS NOT NULL 
    AND b.enddate IS NULL 
   AND b.begindate = CURRENT_DATE 
   AND b.begintime IS NULL) 
   OR (b.begindate IS NOT NULL 
    AND b.enddate IS NULL 
   AND b.begindate = CURRENT_DATE 
   AND b.begintime IS NOT NULL 
   AND b.begintime <= current_time) 
   OR (b.enddate IS NOT NULL 
    AND b.begindate IS NULL 
   AND b.enddate > CURRENT_DATE ) 
   OR (b.enddate IS NOT NULL 
    AND b.begindate IS NULL 
   AND b.enddate = CURRENT_DATE 
   AND b.endtime IS NULL ) 
   OR (b.enddate IS NOT NULL 
    AND b.begindate IS NULL 
   AND b.enddate = CURRENT_DATE 
   AND b.endtime IS NOT NULL 
   AND b.endtime >= current_time) 
   OR (b.begindate IS NOT NULL 
    AND b.enddate IS NOT NULL 
   AND b.begindate <= CURRENT_DATE 
   AND CURRENT_DATE <= b.enddate 
   AND b.begintime IS NULL 
   AND b.endtime IS NULL) 
   OR (b.begindate IS NOT NULL 
    AND b.enddate IS NOT NULL 
   AND b.begindate <= CURRENT_DATE 
   AND CURRENT_DATE <= b.enddate 
   AND b.begintime IS NOT NULL 
   AND b.endtime IS NULL 
   AND b.begintime <= current_time) 
   OR (b.begindate IS NOT NULL 
    AND b.enddate IS NOT NULL 
   AND b.begindate <= CURRENT_DATE 
   AND CURRENT_DATE <= b.enddate 
   AND b.begintime IS NULL 
   AND b.endtime IS NOT NULL 
   AND b.endtime >= current_time) 
   OR (b.begindate IS NOT NULL 
    AND b.enddate IS NOT NULL 
   AND b.begindate <= CURRENT_DATE 
   AND CURRENT_DATE <= b.enddate 
   AND b.begintime IS NOT NULL 
   AND b.endtime IS NOT NULL 
   AND b.begintime <= current_time 
   AND current_time <= b.endtime) );
END;
/



