ALTER TABLE WorkPlanShareSet ADD seclevelMax INT
/
ALTER TABLE WorkPlanShareSet ADD sseclevelMax INT
/

UPDATE WorkPlanShareSet SET seclevelMax = 255 WHERE seclevelMax IS NULL
/
UPDATE WorkPlanShareSet SET sseclevelMax = 255 WHERE sseclevelMax IS NULL
/

ALTER TABLE WorkPlanShare ADD securityLevelMax INT
/

UPDATE WorkPlanShare SET securityLevelMax = 255 WHERE securityLevelMax IS NULL
/


create table workplan_disremindtime (
       userid integer,
       usertype integer,
       remindtime VARCHAR(19)
)
/


CREATE OR REPLACE PROCEDURE WorkPlanShare_Ins(workPlanId_1    integer,
                                              shareType_1     char,
                                              userId_1        varchar2,
                                              subCompanyID_1  varchar2,
                                              deptId_1        varchar2,
                                              roleId_1        varchar2,
                                              forAll_1        char,
                                              roleLevel_1     char,
                                              securityLevel_1 smallint,
                                              shareLevel_1    char,
                                              securityLevelMax_1 smallint,
                                              flag            out integer,
                                              msg             out varchar2,
                                              thecursor       IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO WorkPlanShare
    (workPlanId,
     shareType,
     userId,
     subCompanyID,
     deptId,
     roleId,
     forAll,
     roleLevel,
     securityLevel,
     shareLevel,
     securityLevelMax)
  VALUES
    (workPlanId_1,
     shareType_1,
     userId_1,
     subCompanyID_1,
     deptId_1,
     roleId_1,
     forAll_1,
     roleLevel_1,
     securityLevel_1,
     shareLevel_1,
     securityLevelMax_1);
end
/
CREATE OR REPLACE PROCEDURE WorkPlanShareSet_Insert(reportid_1     integer,
                                                    sharetype_1    integer,
                                                    seclevel_1     integer,
                                                    rolelevel_1    integer,
                                                    sharelevel_1   integer,
                                                    userid_1       varchar2,
                                                    subcompanyid_1 varchar2,
                                                    departmentid_1 varchar2,
                                                    roleid_1       integer,
                                                    foralluser_1   integer,
                                                    sharetype_2    integer,
                                                    seclevel_2     integer,
                                                    rolelevel_2    integer,
                                                    userid_2       varchar2,
                                                    subcompanyid_2 varchar2,
                                                    departmentid_2 varchar2,
                                                    roleid_2       integer,
                                                    foralluser_2   integer,
                                                    settype_1      integer,
						    seclevelMax_1	integer, 
						    sseclevelMax_1	integer, 
                                                    flag           out integer,
                                                    msg            out varchar2,
                                                    thecursor      IN OUT cursor_define.weavercursor) as
begin
  insert into WorkPlanShareSet
    (planid,
     sharetype,
     seclevel,
     rolelevel,
     sharelevel,
     userid,
     subcompanyid,
     departmentid,
     roleid,
     foralluser,
     ssharetype,
     sseclevel,
     srolelevel,
     suserid,
     ssubcompanyid,
     sdepartmentid,
     sroleid,
     sforalluser,
     settype,
     seclevelMax,
     sseclevelMax)
  values
    (reportid_1,
     sharetype_1,
     seclevel_1,
     rolelevel_1,
     sharelevel_1,
     userid_1,
     subcompanyid_1,
     departmentid_1,
     roleid_1,
     foralluser_1,
     sharetype_2,
     seclevel_2,
     rolelevel_2,
     userid_2,
     subcompanyid_2,
     departmentid_2,
     roleid_2,
     foralluser_2,
     settype_1,
     seclevelMax_1,
     sseclevelMax_1);
end
/