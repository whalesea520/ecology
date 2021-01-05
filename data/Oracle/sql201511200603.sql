drop trigger workflow_texttopdf_tri
/
drop sequence workflow_texttopdf_id
/
drop TABLE workflow_texttopdf 
/
CREATE TABLE workflow_texttopdf (
	id integer  not null,
	requestid integer null,
	docId integer  null,
	pdfDocId integer null,
	pdfImageFileId integer null,
	decryptPdfDocId  integer null,
	decryptPdfImageFileId integer null,
	transformDate char(10) null,
	transformTime char(8) null
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
