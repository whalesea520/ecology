CREATE OR REPLACE PROCEDURE WorkflowReportShare_Insert 
(reportid_1 INTEGER, sharetype_1 INTEGER, seclevel_1 INTEGER, seclevel_2 INTEGER, 
rolelevel_1 SMALLINT, sharelevel_1 SMALLINT, userid_1 VARCHAR2, subcompanyid_1 VARCHAR2, 
departmentid_1 VARCHAR2, roleid_1 VARCHAR2, foralluser_1 SMALLINT, crmid_1 INTEGER, 
mutidepartmentid_1 VARCHAR2, allowlook_1 INTEGER, flag OUT INTEGER, msg OUT VARCHAR2, 
thecursor IN OUT cursor_define.weavercursor) AS BEGIN
INSERT INTO WorkflowReportShare 
(reportid, sharetype, seclevel, seclevel2, rolelevel, sharelevel, userid, 
subcompanyid, departmentid, roleid, foralluser, crmid, mutidepartmentid, allowlook)
VALUES (reportid_1,
        sharetype_1,
        seclevel_1,
        seclevel_2 ,
        rolelevel_1,
        sharelevel_1,
        userid_1,
        subcompanyid_1,
        departmentid_1,
        roleid_1,
        foralluser_1,
        crmid_1,
        mutidepartmentid_1,
        allowlook_1); END;
/