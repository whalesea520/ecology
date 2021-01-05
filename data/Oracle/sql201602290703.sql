CREATE OR REPLACE TRIGGER HrmDepartmentTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmDepartment FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmDepartment';
  elsif :new.id<>:old.id or NVL(:new.departmentname,' ')<>NVL(:old.departmentname,' ') or NVL(:new.supdepid,0)<>NVL(:old.supdepid,0) or NVL(:new.subcompanyid1,0)<>NVL(:old.subcompanyid1,0) or NVL(:new.showorder,0)<>NVL(:old.showorder,0) or NVL(:new.canceled,' ')<>NVL(:old.canceled,' ') then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmDepartment';
  end if;
END;
/