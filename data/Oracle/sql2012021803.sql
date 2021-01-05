alter table workflow_nodefieldattr add caltype integer null
/
update workflow_nodefieldattr set caltype=1 where attrcontent like '%doFieldSQL%'
/
update workflow_nodefieldattr set caltype=2 where attrcontent like '%doFieldMath%'
/
alter table workflow_nodefieldattr add othertype integer null
/
alter table workflow_nodehtmllayout add cssfile integer null
/
create table workflow_crmcssfile(
	id integer,
	cssname varchar2(200),
	realfilename varchar2(200),
	realpath varchar2(2000)
)
/

create sequence workflow_crmcssfile_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_crmcssfile_id_Tri
before insert on workflow_crmcssfile
for each row
begin
select workflow_crmcssfile_id.nextval into :new.id from dual;
end;
/