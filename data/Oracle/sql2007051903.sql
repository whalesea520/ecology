CREATE OR REPLACE PROCEDURE workplan_insertplus (
   type_n_1                                 INTEGER,
   name_1                                   VARCHAR2,
   resourceid_1                             VARCHAR2,
   begindate_1                              CHAR,
   begintime_1                              CHAR,
   enddate_1                                CHAR,
   endtime_1                                CHAR,
   description_1                            CLOB,
   requestid_1                              VARCHAR2,
   projectid_1                              VARCHAR2,
   crmid_1                                  VARCHAR2,
   docid_1                                  VARCHAR2,
   meetingid_1                              VARCHAR2,
   isremind_1                               INTEGER,
   waketime_1                               INTEGER,
   createrid_1                              INTEGER,
   creatertype_1                            CHAR,
   createdate_1                             CHAR,
   createtime_1                             CHAR,
   taskid_1                                 VARCHAR2,
   urgentlevel_1                            CHAR,
   status_1                                 CHAR,
   relatedprj_1                             VARCHAR2,
   relatedcus_1                             VARCHAR2,
   relatedwf_1                              VARCHAR2,
   relateddoc_1                             VARCHAR2,
   remindtype_1                             CHAR,
   remindbeforestart_1                      CHAR,
   remindbeforeend_1                        CHAR,
   remindtimesbeforestart_1                 INTEGER,
   remindtimesbeforeend_1                   INTEGER,
   reminddatebeforestart_1                  CHAR,
   remindtimebeforestart_1                  CHAR,
   reminddatebeforeend_1                    CHAR,
   remindtimebeforeend_1                    CHAR,
   hrmperformancecheckdetailid_1            INTEGER,
   flag                            OUT      INTEGER,
   msg                             OUT      VARCHAR2,
   thecursor                       IN OUT   cursor_define.weavercursor
)
AS
   m_id_1        INTEGER;
   m_deptid_1    INTEGER;
   m_subcoid_1   INTEGER;
BEGIN
   INSERT INTO workplan
               (type_n, NAME, resourceid, begindate, begintime,
                enddate, endtime, description, requestid,
                projectid, crmid, docid, meetingid, status,
                isremind, waketime, createrid, createdate,
                createtime, deleted, taskid, urgentlevel, creatertype,
                relatedprj, relatedcus, relatedwf, relateddoc,
                remindtype, remindbeforestart, remindbeforeend,
                remindtimesbeforestart, remindtimesbeforeend,
                reminddatebeforestart, remindtimebeforestart,
                reminddatebeforeend, remindtimebeforeend,
                hrmperformancecheckdetailid
               )
        VALUES (type_n_1, name_1, resourceid_1, begindate_1, begintime_1,
                enddate_1, endtime_1, description_1, requestid_1,
                projectid_1, crmid_1, docid_1, meetingid_1, status_1,
                isremind_1, waketime_1, createrid_1, createdate_1,
                createtime_1, '0', taskid_1, urgentlevel_1, creatertype_1,
                relatedprj_1, relatedcus_1, relatedwf_1, relateddoc_1,
                remindtype_1, remindbeforestart_1, remindbeforeend_1,
                remindtimesbeforestart_1, remindtimesbeforeend_1,
                reminddatebeforestart_1, remindtimebeforestart_1,
                reminddatebeforeend_1, remindtimebeforeend_1,
                hrmperformancecheckdetailid_1
               );

   SELECT MAX (ID)
     INTO m_id_1
     FROM workplan;

   IF '1' <> resourceid_1
   THEN
      SELECT departmentid
        INTO m_deptid_1
        FROM hrmresource
       WHERE ID = createrid_1;

      SELECT subcompanyid1
        INTO m_subcoid_1
        FROM hrmresource
       WHERE ID = createrid_1;
   ELSE
      m_deptid_1 := 0;
      m_subcoid_1 := 0;
   END IF;

   UPDATE workplan
      SET deptid = m_deptid_1,
          subcompanyid = m_subcoid_1
    WHERE ID = m_id_1;

   OPEN thecursor FOR
      SELECT m_id_1 ID
        FROM DUAL;
END;
/
