CREATE TABLE workflow_texttopdfconfig (
	id integer  not null,
	workflowid integer null,
	topdfnodeid integer  null,
	pdfsavesecid integer null,
	catalogtype2 char(1) null,
	selectcatalog2 integer null,
	pdfdocstatus  integer null,
	pdffieldid  integer null,
	decryptpdfsavesecid integer null,
	decryptcatalogtype2 char(1) null,
	decryptselectcatalog2 integer null,
	decryptpdfdocstatus  integer null,
	decryptpdffieldid  integer null
)
/
create sequence workflow_texttopdfconfig_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger wf_texttopdfconfig_tri
before insert on workflow_texttopdfconfig
for each row
begin
select workflow_texttopdfconfig_id.nextval into :new.id from dual;
end;
/



CREATE TABLE workflow_texttopdf (
	id integer  not null,
	topdfnodeid integer  null,
	pdfsavesecid integer null,
	catalogtype2 char(1) null,
	selectcatalog2 integer null,
	pdfdocstatus  integer null,
	decryptpdfsavesecid integer null,
	decryptcatalogtype2 char(1) null,
	decryptselectcatalog2 integer null,
	decryptpdfdocstatus  integer null
)
/
create sequence workflow_texttopdf_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_texttopdf_tri
before insert on workflow_texttopdf
for each row
begin
select workflow_texttopdf_id.nextval into :new.id from dual;
end;
/