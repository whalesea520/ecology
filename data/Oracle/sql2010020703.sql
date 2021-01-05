create or replace PROCEDURE tempPrc
AS
maxid integer; 
begin 
maxid := 5000 ;
for i in 1 .. maxid loop
insert into workflow_billfield (billid) values(-1);
end loop;
end;
/
call tempPrc()
/
delete from workflow_billfield where billid=-1
/
drop PROCEDURE tempPrc
/
