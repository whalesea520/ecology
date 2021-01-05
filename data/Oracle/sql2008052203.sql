CREATE TABLE WorkPlanShareSet
(
  ID                INTEGER                     NOT NULL,
  planid            INTEGER,
  SHARETYPE         INTEGER,
  SECLEVEL          INTEGER,
  ROLELEVEL         INTEGER,
  SHARELEVEL        INTEGER,
  USERID            varchar2(4000),
  SUBCOMPANYID      varchar2(4000),
  DEPARTMENTID      varchar2(4000),
  ROLEID            INTEGER,
  FORALLUSER        INTEGER, 
  SSHARETYPE         INTEGER,
  SSECLEVEL          INTEGER,
  SROLELEVEL         INTEGER,
  SUSERID            varchar2(4000),
  SSUBCOMPANYID      varchar2(4000),
  SDEPARTMENTID      varchar2(4000),
  SROLEID            INTEGER,
  SFORALLUSER        INTEGER,
  settype        INTEGER
 
)
/
CREATE OR REPLACE TRIGGER planshare_Trigger before insert on WorkPlanShareSet for each row
begin select WorkPlanShareSet_id.nextval INTO :new.id from dual; end;
/

CREATE SEQUENCE WorkPlanShareSet_id
  START WITH 1
  MINVALUE 1
  increment by 1
  nomaxvalue
  nocycle
  /

CREATE OR REPLACE PROCEDURE WorkPlanShareSet_Insert (reportid_1       integer, sharetype_1	integer, seclevel_1	integer, rolelevel_1	integer, sharelevel_1	integer, userid_1	varchar2, subcompanyid_1	varchar2, departmentid_1	varchar2, roleid_1	integer, foralluser_1	integer,sharetype_2	integer, seclevel_2	integer, rolelevel_2	integer, userid_2	varchar2, subcompanyid_2	varchar2, departmentid_2	varchar2, roleid_2	integer, foralluser_2	integer, settype_1 integer ,flag out 	integer, msg out	varchar2, thecursor IN OUT cursor_define.weavercursor) as begin insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype) values(reportid_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,subcompanyid_1,departmentid_1,roleid_1,foralluser_1,sharetype_2,seclevel_2,rolelevel_2,userid_2,subcompanyid_2,departmentid_2,roleid_2,foralluser_2,settype_1); end;
/

alter table workplansharedetail add  sharesrc varchar2(1)
/
