CREATE OR REPLACE TRIGGER HrmSubCompanyTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmSubCompany FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmSubCompany';
  elsif :new.id<>:old.id or NVL(:new.subcompanyname,' ')<>NVL(:old.subcompanyname,' ') or NVL(:new.supsubcomid,0)<>NVL(:old.supsubcomid,0) or NVL(:new.companyid,0)<>NVL(:old.companyid,0) or NVL(:new.showorder,0)<>NVL(:old.showorder,0) or NVL(:new.canceled,' ')<>NVL(:old.canceled,' ') then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmSubCompany';
  end if;
END;
/