CREATE or REPLACE  TRIGGER Tri_CRM_CustomerInfoShare after update ON  CRM_CustomerInfo
FOR each row
Declare 
	crmid_1 integer;
	oldmanagerstr_1 varchar2(200);
	managerstr_1 varchar2(200);
begin

crmid_1 := :new.id;
oldmanagerstr_1 := :old.manager;
managerstr_1 := :new.manager;

if (managerstr_1 <> oldmanagerstr_1 )
then   
	update shareinnerdoc set content=managerstr_1 where srcfrom=-81 and opuser = crmid_1;
end if;
end;
/