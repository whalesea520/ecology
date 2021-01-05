CREATE or replace PROCEDURE FnaCurrency_SelectAll 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for select * from FnaCurrency order by id asc;  
end;
/