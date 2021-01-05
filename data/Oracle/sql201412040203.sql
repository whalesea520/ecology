BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE mobileSyncInfo';
EXCEPTION
   WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE mobileSyncInfo(syncTable CHAR(100), syncLastTime INT)
/

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmResource')
/

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmDepartment')
/

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmSubCompany')
/

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmCompany')
/

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmGroupMember')
/

INSERT INTO mobileSyncInfo(syncTable) VALUES('WorkPlanType')
/

INSERT INTO mobileSyncInfo(syncTable) VALUES('WorkFlowType')
/

update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable in ('HrmResource','HrmDepartment','HrmSubCompany','HrmCompany','HrmGroupMember','WorkPlanType','WorkFlowType')
/

CREATE OR REPLACE TRIGGER HrmCompanyTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmCompany FOR EACH ROW 
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmCompany';
  elsif :new.id<>:old.id or nvl(:new.companyname,' ')<>NVL(:old.companyname,' ') then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmCompany';
  end if;
END;
/

CREATE OR REPLACE TRIGGER HrmDepartmentTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmDepartment FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmDepartment';
  elsif :new.id<>:old.id or NVL(:new.departmentname,' ')<>NVL(:old.departmentname,' ') or NVL(:new.supdepid,0)<>NVL(:old.supdepid,0) or NVL(:new.subcompanyid1,0)<>NVL(:old.subcompanyid1,0) then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmDepartment';
  end if;
END;
/

CREATE OR REPLACE TRIGGER HrmGroupMemberTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmGroupMembers FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmGroupMember';
  elsif NVL(:new.groupid,0)<>NVL(:old.groupid,0) or NVL(:new.userid,0)<>NVL(:old.userid,0) then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmGroupMember';
  end if;
END;
/

CREATE OR REPLACE TRIGGER HrmResourceTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmResource FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmResource';
  elsif :new.id<>:old.id or NVL(:new.lastname,' ')<>NVL(:old.lastname,' ') or NVL(:new.pinyinlastname,' ')<>NVL(:old.pinyinlastname,' ') or NVL(:new.messagerurl,' ')<>NVL(:old.messagerurl,' ') or NVL(:new.subcompanyid1,0)<>NVL(:old.subcompanyid1,0) or NVL(:new.departmentid,0)<>NVL(:old.departmentid,0) or NVL(:new.mobile,' ')<>NVL(:old.mobile,' ') or NVL(:new.telephone,' ')<>NVL(:old.telephone,' ') or NVL(:new.email,' ')<>NVL(:old.email,' ') or NVL(:new.jobtitle,0)<>NVL(:old.jobtitle,0) or NVL(:new.managerid,0)<>NVL(:old.managerid,0) or NVL(:new.status,0)<>NVL(:old.status,0) or NVL(:new.loginid,' ')<>NVL(:old.loginid,' ') or NVL(:new.account,' ')<>NVL(:old.account,' ') then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmResource';
  end if;
END;
/

CREATE OR REPLACE TRIGGER HrmSubCompanyTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmSubCompany FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmSubCompany';
  elsif :new.id<>:old.id or NVL(:new.subcompanyname,' ')<>NVL(:old.subcompanyname,' ') or NVL(:new.supsubcomid,0)<>NVL(:old.supsubcomid,0) or NVL(:new.companyid,0)<>NVL(:old.companyid,0) then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmSubCompany';
  end if;
END;
/

CREATE OR REPLACE TRIGGER OverWorkPlanTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON OverWorkPlan FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='WorkPlanType';
  elsif NVL(:new.workplancolor,' ')<>NVL(:old.workplancolor,' ') or NVL(:new.wavailable,0)<>NVL(:old.wavailable,0) then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='WorkPlanType';
  end if;
END;
/

CREATE OR REPLACE TRIGGER WorkFlowBaseTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON workflow_base FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='WorkFlowType';
  elsif :new.id<>:old.id or NVL(:new.workflowname,' ')<>NVL(:old.workflowname,' ') or :new.workflowtype<>:old.workflowtype or NVL(:new.isvalid,'0')<>NVL(:old.isvalid,'0') or NVL(:new.isbill,'0')<>NVL(:old.isbill,'0') then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='WorkFlowType';
  end if;
END;
/

CREATE OR REPLACE TRIGGER WorkFlowTypeTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON workflow_type FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='WorkFlowType';
  elsif :new.id<>:old.id or NVL(:new.typename,' ')<>NVL(:old.typename,' ') or :new.dsporder<>:old.dsporder then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='WorkFlowType';
  end if;
END;
/

CREATE OR REPLACE TRIGGER WorkPlanTypeTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON WorkPlanType FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='WorkPlanType';
  elsif :new.workPlanTypeID<>:old.workPlanTypeID or NVL(:new.workPlanTypeName,' ')<>NVL(:old.workPlanTypeName,' ') or NVL(:new.available,'0')<>NVL(:old.available,'0') or NVL(:new.displayOrder,0)<>NVL(:old.displayOrder,0) then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='WorkPlanType';
  end if;
END;
/
