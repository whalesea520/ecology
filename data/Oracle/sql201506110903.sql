create or replace procedure int_browermark_Insert ( 
mark_1   varchar2, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
as maxid_ varchar2(4000); 
begin 
insert into int_browermark (mark) values (mark_1); 
select MAX(id) into maxid_  from int_browermark; 
update int_browermark set mark=mark_1||maxid_ where id=maxid_; 
open thecursor for  select mark  from int_browermark where id=maxid_; 
end;
/