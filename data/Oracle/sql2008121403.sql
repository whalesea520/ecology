
CREATE TABLE workflow_shortNameSetting (
	id integer  not null,
	workflowId integer null ,
	formId integer null ,
	isBill char(1) null ,
	fieldId integer null ,
	fieldValue integer null ,
	shortNameSetting varchar2(100) null 
)
/

create sequence wf_shortNameSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger wf_shortNameSetting_Tri
before insert on workflow_shortNameSetting
for each row
begin
select wf_shortNameSetting_id.nextval into :new.id from dual;
end;
/

alter table workflow_code add fieldSequenceAlone char(1)  null
/
alter table workflow_codeSeq add fieldId integer  null
/
alter table workflow_codeSeq add fieldValue integer  null
/

update workflow_codeSeq set fieldId=-1
/
update workflow_codeSeq set fieldValue=-1
/

insert into workflow_codeSet values(15,261,'5')
/
