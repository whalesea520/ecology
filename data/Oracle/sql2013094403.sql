create table mobileSyncInfo(syncTable char(100), syncLastTime date)
/

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmResource', sysdate)
/

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmDepartment', sysdate)
/

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmSubCompany', sysdate)
/

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmCompany', sysdate)
/

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmGroupMember', sysdate)
/

update mobileSyncInfo set syncLastTime=sysdate where syncTable in ('HrmResource','HrmDepartment','HrmSubCompany','HrmCompany','HrmGroupMember')
/

CREATE OR REPLACE TRIGGER HrmCompanyTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmCompany FOR EACH ROW 
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmCompany';
  elsif :new.id<>:old.id or nvl(:new.companyname,' ')<>NVL(:old.companyname,' ') then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmCompany';
  end if;
END;
/

CREATE OR REPLACE TRIGGER HrmDepartmentTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmDepartment FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmDepartment';
  elsif :new.id<>:old.id or NVL(:new.departmentname,' ')<>NVL(:old.departmentname,' ') or NVL(:new.supdepid,0)<>NVL(:old.supdepid,0) or NVL(:new.subcompanyid1,0)<>NVL(:old.subcompanyid1,0) then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmDepartment';
  end if;
END;
/

CREATE OR REPLACE TRIGGER HrmGroupMemberTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmGroupMembers FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmGroupMember';
  elsif NVL(:new.groupid,0)<>NVL(:old.groupid,0) or NVL(:new.userid,0)<>NVL(:old.userid,0) then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmGroupMember';
  end if;
END;
/

CREATE OR REPLACE TRIGGER HrmResourceTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmResource FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmResource';
  elsif :new.id<>:old.id or NVL(:new.lastname,' ')<>NVL(:old.lastname,' ') or NVL(:new.pinyinlastname,' ')<>NVL(:old.pinyinlastname,' ') or NVL(:new.messagerurl,' ')<>NVL(:old.messagerurl,' ') or NVL(:new.subcompanyid1,0)<>NVL(:old.subcompanyid1,0) or NVL(:new.departmentid,0)<>NVL(:old.departmentid,0) or NVL(:new.mobile,' ')<>NVL(:old.mobile,' ') or NVL(:new.telephone,' ')<>NVL(:old.telephone,' ') or NVL(:new.email,' ')<>NVL(:old.email,' ') or NVL(:new.jobtitle,0)<>NVL(:old.jobtitle,0) or NVL(:new.managerid,0)<>NVL(:old.managerid,0) or NVL(:new.status,0)<>NVL(:old.status,0) or NVL(:new.loginid,' ')<>NVL(:old.loginid,' ') or NVL(:new.account,' ')<>NVL(:old.account,' ') then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmResource';
  end if;
END;
/

CREATE OR REPLACE TRIGGER HrmSubCompanyTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmSubCompany FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmSubCompany';
  elsif :new.id<>:old.id or NVL(:new.subcompanyname,' ')<>NVL(:old.subcompanyname,' ') or NVL(:new.supsubcomid,0)<>NVL(:old.supsubcomid,0) or NVL(:new.companyid,0)<>NVL(:old.companyid,0) then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='HrmSubCompany';
  end if;
END;
/
