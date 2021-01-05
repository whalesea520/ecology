CREATE OR REPLACE TRIGGER OverWorkPlanTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON OverWorkPlan FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='WorkPlanType';
  elsif NVL(:new.workplancolor,' ')<>NVL(:old.workplancolor,' ') or NVL(:new.wavailable,0)<>NVL(:old.wavailable,0) then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='WorkPlanType';
  end if;
END;
/

CREATE OR REPLACE TRIGGER WorkPlanTypeTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON WorkPlanType FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='WorkPlanType';
  elsif :new.workPlanTypeID<>:old.workPlanTypeID or NVL(:new.workPlanTypeName,' ')<>NVL(:old.workPlanTypeName,' ') or NVL(:new.available,'0')<>NVL(:old.available,'0') or NVL(:new.displayOrder,0)<>NVL(:old.displayOrder,0) then
    update mobileSyncInfo set syncLastTime=sysdate where syncTable='WorkPlanType';
  end if;
END;
/
