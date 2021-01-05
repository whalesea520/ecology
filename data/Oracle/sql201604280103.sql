CREATE OR REPLACE TRIGGER Prj_ProjectInfo_getCrm
  after insert or update ON Prj_ProjectInfo
  FOR each row

Declare
  relateditemid_1 integer;
  managerview_1   integer;
  description_1   varchar2(4000);
  crmid_1         integer;
  managerview_2   integer;
begin
  managerview_1 := :old.managerview;
  managerview_2 := :new.managerview;
  if managerview_1 = 1 and managerview_2 = 0 then
    relateditemid_1 := :old.id;
    delete from Prj_ShareInfo
     where relateditemid = relateditemid_1
       and sharetype = 9;
  
  elsif managerview_2 = 1 then
    relateditemid_1 := :new.id;
    description_1   := :new.description;
    delete from Prj_ShareInfo
     where relateditemid = relateditemid_1
       and sharetype = 9;
    for crmid_1 in (select to_number(strvalue) as Value
                      from table(fn_split(description_1, ','))) loop
      insert into Prj_ShareInfo
        (relateditemid, sharetype, crmid,sharelevel)
      values
        (relateditemid_1, 9,crmid_1.value,1);
    end loop;
  
  elsif managerview_2 = 0 then
    relateditemid_1 := :new.id;
    delete from Prj_ShareInfo
     where relateditemid = relateditemid_1
       and sharetype = 9;
  end if;
end;
/