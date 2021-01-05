create table mode_customSearchButton(
	id int primary key,
	objid int,
	buttonname varchar2(100),
	hreftype int,
	hreftargetParid varchar2(100),
	hreftargetParval varchar2(100),
	hreftarget varchar2(1000),
	jsmethodname varchar2(100),
	jsParameter varchar2(1000),
	jsmethodbody clob,
	isshow int,
	describe varchar2(4000),
    showorder float
)
/
create sequence mode_customSearchButton_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_customSearchButton_id_Tri
before insert on mode_customSearchButton
for each row
begin
select mode_customSearchButton_id.nextval into :new.id from dual;
end
/