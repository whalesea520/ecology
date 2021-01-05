alter table Bill_ExpenseDetail add id integer
/
update Bill_ExpenseDetail set id=rownum
/
CREATE OR REPLACE PROCEDURE Bill_ExpenseDetail_init	Authid Current_User
AS
tmp_count integer;
begin
    tmp_count:=0;
	select count(*) INTO tmp_count  from Bill_ExpenseDetail ;
    tmp_count:=tmp_count+1;
    EXECUTE IMMEDIATE ('create sequence Bill_ExpenseDetail_id start with '||tmp_count||' increment by 1 nomaxvalue nocycle');
end;
/
call Bill_ExpenseDetail_init()
/
drop PROCEDURE Bill_ExpenseDetail_init
/
create or replace trigger Bill_ExpenseDetail_Tri
before insert on Bill_ExpenseDetail
for each row
begin
select Bill_ExpenseDetail_id.nextval into :new.id from dual;
end;
/
