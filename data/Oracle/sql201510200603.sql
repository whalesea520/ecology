alter table RTXSetting add userattr varchar2(400)
/
alter table RTXSetting add username varchar2(400)
/
alter table RTXSetting add rtxLoginToOA char(1)
/
 create table imsynlog
 (
	id int not null,
	syntype char(1),
	syndata varchar2(500),
	opertype char(1),
	operresult char(1),
	reason varchar2(800),
	operdate varchar2(10),
	opertime varchar2(8)
 )
 /
create sequence imsynlog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger imsynlog_Tri
before insert on imsynlog
for each row
begin
select imsynlog_id.nextval into :new.id from dual;
end;
/