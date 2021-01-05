create table mode_layout_querySql
(
id INTEGER not null,
modeid INTEGER,
formid INTEGER,
layoutid INTEGER,
detailtype INTEGER,
queryType INTEGER default 0 not null,
sqlConetent varchar2(3000),
javaFileName varchar2(200)
)
/
Create Sequence layout_querySql_set_id Start With 1 Increment By 1 Nocycle Nocache
/
create or replace trigger layout_querySql_id_trigger
before insert
on mode_layout_querySql
for each row
declare
newid number(18,0);
begin
select layout_querySql_set_id.nextval into newid from dual;
:new.id:=newid;
end;
/
create table mode_layout_sortfield
(
 id INTEGER not null,
 modeid INTEGER,
 formid INTEGER,
 layoutid INTEGER,
 fieldid INTEGER,
 issort INTEGER default 0
)
/ 
Create Sequence layout_sortfield_set_id Start With 1 Increment By 1 Nocycle Nocache
/
create or replace trigger layout_sortfield_id_trigger
before insert
on mode_layout_sortfield
for each row
declare
newid number(18,0);
begin
select layout_sortfield_set_id.nextval into newid from dual;
:new.id:=newid;
end;
/