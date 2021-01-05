CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Delete
(id_1 integer,
flag out integer,
msg  out  varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
typeId integer;
count_1 integer;
count_2 integer;
count_3 integer;
count_4 integer;
count_5 integer;
count_6 integer;
count_7 integer;
count_8 integer;
begin
SELECT count(feetypeid) into count_1 FROM bill_expensedetail WHERE feetypeid = id_1;
SELECT count(id) into count_2 FROM FnaBudgetInfoDetail WHERE budgettypeid = id_1;
SELECT count(id) into count_3 FROM FnaBudgetCheckDetail WHERE budgettypeid = id_1;
SELECT count(id) into count_4 FROM FnaBudgetfeeType WHERE supsubject = id_1;
SELECT count(id) into count_5 FROM FnaExpenseInfo WHERE subject = id_1;
SELECT count(id) into count_7 FROM Bill_FnaWipeApplyDetail WHERE subject = id_1;
SELECT count(id) into count_8 FROM Bill_FnaBudgetChgApplyDetail WHERE subject=id_1;
if count_1>0 or count_2>0 or count_3>0 or count_4>0 or count_5>0 or count_7>0 or count_8>0 then
open thecursor for
select -1 from dual;
return;
end if;
delete from fnaBudgetfeetype where id= id_1;
end;
/
