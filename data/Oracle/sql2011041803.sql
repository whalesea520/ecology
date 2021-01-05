ALTER TABLE DocFrontpage ADD checkOutStatus INTEGER
/

ALTER TABLE DocFrontpage ADD checkOutUserId INTEGER 
/

CREATE OR REPLACE PROCEDURE docfrontpage_update (
   id_1                          INTEGER,
   frontpagename_2               VARCHAR2,
   frontpagedesc_3               VARCHAR2,
   isactive_4                    CHAR,
   departmentid_5                INTEGER,
   hasdocsubject_7               CHAR,
   hasfrontpagelist_8            CHAR,
   newsperpage_9                 SMALLINT,
   titlesperpage_10              SMALLINT,
   defnewspicid_11               INTEGER,
   backgroundpicid_12            INTEGER,
   importdocid_13                VARCHAR2,
   headerdocid_14                INTEGER,
   footerdocid_15                INTEGER,
   secopt_16                     VARCHAR2,
   seclevelopt_17                SMALLINT,
   departmentopt_18              INTEGER,
   dateopt_19                    INTEGER,
   languageopt_20                INTEGER,
   clauseopt_21                  CLOB,
   newsclause_22                 CLOB,
   languageid_23                 INTEGER,
   publishtype_24                INTEGER,
   newstypeid_25                 INTEGER,
   typeordernum_26               INTEGER,
   checkOutStatus_27              INTEGER,
   checkOutUserId_28              INTEGER,
   flag                 OUT      INTEGER,
   msg                  OUT      VARCHAR2,
   thecursor            IN OUT   cursor_define.weavercursor
)
AS
BEGIN
   UPDATE docfrontpage
      SET frontpagename = frontpagename_2,
          frontpagedesc = frontpagedesc_3,
          isactive = isactive_4,
          departmentid = departmentid_5,
          hasdocsubject = hasdocsubject_7,
          hasfrontpagelist = hasfrontpagelist_8,
          newsperpage = newsperpage_9,
          titlesperpage = titlesperpage_10,
          defnewspicid = defnewspicid_11,
          backgroundpicid = backgroundpicid_12,
          importdocid = importdocid_13,
          headerdocid = headerdocid_14,
          footerdocid = footerdocid_15,
          secopt = secopt_16,
          seclevelopt = seclevelopt_17,
          departmentopt = departmentopt_18,
          dateopt = dateopt_19,
          languageopt = languageopt_20,
          clauseopt = clauseopt_21,
          newsclause = newsclause_22,
          languageid = languageid_23,
          publishtype = publishtype_24,
          newstypeid = newstypeid_25,
          typeordernum = typeordernum_26,
          checkOutStatus = checkOutStatus_27,
          checkOutUserId = checkOutUserId_28
    WHERE (ID = id_1);
END;
/
