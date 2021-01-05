
alter table WorkflowReportShare add mutidepartmentid VARCHAR2(1000) null
/
alter table WorkflowReportShareDetail add mutidepartmentid VARCHAR2(1000) null
/

CREATE or replace PROCEDURE WorkflowReportShare_Insert
(reportid_1       integer, 
sharetype_1	integer,
seclevel_1	smallint,
rolelevel_1	smallint,
sharelevel_1	smallint,
userid_1	integer, 
subcompanyid_1	integer,
departmentid_1	integer, 
roleid_1	integer, 
foralluser_1	smallint,
crmid_1	integer,
mutidepartmentid_1 varchar2,
flag out 	integer, 
msg out	varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert into WorkflowReportShare(reportid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,mutidepartmentid) values(reportid_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,subcompanyid_1,departmentid_1,roleid_1,foralluser_1,crmid_1,mutidepartmentid_1);
end;
/
CREATE OR REPLACE PROCEDURE WkfReportShareDetail_Insert (reportid_1 	integer, userid_2 	integer, usertype_3 	integer, sharelevel_4 	integer ,mutidepartmentid_5 varchar2, flag out 	integer, msg out	varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO WorkflowReportShareDetail ( reportid, userid, usertype, sharelevel,mutidepartmentid)  VALUES ( reportid_1, userid_2, usertype_3, sharelevel_4,mutidepartmentid_5); end;
/
INSERT INTO HtmlLabelIndex values(18512,'同分部') 
/
INSERT INTO HtmlLabelIndex values(18513,'同部门下级部门') 
/
INSERT INTO HtmlLabelIndex values(18511,'同部门') 
/
INSERT INTO HtmlLabelInfo VALUES(18511,'同部门',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18511,'in the same department',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18512,'同分部',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18512,'in the same SubCompany',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18513,'同部门下级部门',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18513,'in the same Department of lower',8) 
/