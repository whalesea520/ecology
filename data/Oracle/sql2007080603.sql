declare
f_id FnaBudgetInfo.Id%Type;
f_budgetorganizationid FnaBudgetInfo.Budgetorganizationid%Type;
f_organizationtype FnaBudgetInfo.Organizationtype%Type;
f_budgetperiods FnaBudgetInfo.budgetperiods%Type;
f_o_budgetorganizationid FnaBudgetInfo.Budgetorganizationid%Type;
f_o_organizationtype FnaBudgetInfo.Organizationtype%Type;
f_o_budgetperiods FnaBudgetInfo.budgetperiods%Type;
i integer;
CURSOR c_FnaBudgetInfo IS
SELECT id,budgetorganizationid,organizationtype,budgetperiods
FROM FnaBudgetInfo
WHERE STATUS in (1,2,3) and REVISION is null
ORDER BY budgetorganizationid,organizationtype,budgetperiods,id;
begin
delete from FnaBudgetInfo where id not in (select budgetinfoid from FnaBudgetInfoDetail) and (STATUS=0 or STATUS is null);
i:=1;
f_o_budgetorganizationid:=0;
f_o_organizationtype:=0;
f_o_budgetperiods:=0;
open c_FnaBudgetInfo;
loop
fetch c_FnaBudgetInfo into f_id,f_budgetorganizationid,f_organizationtype,f_budgetperiods;
exit when c_FnaBudgetInfo%notFound;
if f_o_budgetorganizationid=f_budgetorganizationid and f_o_organizationtype=f_organizationtype and f_o_budgetperiods=f_budgetperiods then
i:=i+1;
else
f_o_budgetorganizationid:=f_budgetorganizationid;
f_o_organizationtype:=f_organizationtype;
f_o_budgetperiods:=f_budgetperiods;
i:=1;
end if;
update FnaBudgetInfo set REVISION = i where id = f_id;
end loop;
close c_FnaBudgetInfo;
commit;
end;
/