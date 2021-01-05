alter table workflow_SelectItem add id integer
/
create sequence workflow_SelectItem_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           
create or replace trigger workflow_SelectItem_Tri
before insert on workflow_SelectItem
for each row
begin
select workflow_SelectItem_id.nextval into :new.id from dual;
end;
/

create or replace  PROCEDURE workflow_SelectItemSelectByid 
(id_1 varchar2, 
isbill_1 varchar2, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select * from workflow_SelectItem where fieldid = id_1 and isbill = isbill_1
order by id;
end;
/
