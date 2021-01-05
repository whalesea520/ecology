CREATE OR REPLACE PROCEDURE FnaBudgetfeeType_Select (flag	out integer, msg	varchar2, thecursor IN OUT cursor_define.weavercursor) as begin open thecursor for  select * from fnaBudgetfeetype order by  name;  end;
/
