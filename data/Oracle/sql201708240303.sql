create table remindfornewDoc (
  urltype integer,
  titlemessage varchar2(4000),
  bodymessage varchar2(4000),
  secid integer
)
/
create table remind_formfield(
  ID number(11) primary key, 
  field varchar2(2000),
  value varchar2(2000),
  urltype integer
)
/
create sequence AutoID start with 1 increment by 1 minvalue 1 nomaxvalue 
/
create trigger AutoID_Trigger before insert on remind_formfield for each row 
begin select AutoID.nextval into :new.ID from dual; 
end AutoID_Trigger; 
/

insert into remind_formfield (field,value,urltype)values ('16398','$DOC_SecCategory',1)
/
insert into remind_formfield (field,value,urltype)values ('27142','$DOC_SubjectByLink',1)
/
insert into remind_formfield (field,value,urltype)values ('19225','$DOC_Department',1)
/
insert into remind_formfield (field,value,urltype)values ('16228','$DOC_Content',1)
/
insert into remind_formfield (field,value,urltype)values ('16229','$DOC_CreatedByFull',1)
/
insert into remind_formfield (field,value,urltype)values ('722','$DOC_CreatedDate',1)
/
insert into remind_formfield (field,value,urltype)values ('16232','$DOC_ModifiedDate',1)
/
insert into remind_formfield (field,value,urltype)values ('16235','$DOC_Status',1)
/
insert into remind_formfield (field,value,urltype)values ('19541','$DOC_Subject',1)
/
insert into remind_formfield (field,value,urltype)values ('16237','$DOC_Publish',1)
/
insert into remind_formfield (field,value,urltype)values ('1425','$DOC_ApproveDate',1)
/
insert into remind_formfield (field,value,urltype)values ('16398','$DOC_SecCategory',2)
/
insert into remind_formfield (field,value,urltype)values ('19225','$DOC_Department',2)
/
insert into remind_formfield (field,value,urltype)values ('16228','$DOC_Content',2)
/
insert into remind_formfield (field,value,urltype)values ('16229','$DOC_CreatedByFull',2)
/
insert into remind_formfield (field,value,urltype)values ('722','$DOC_CreatedDate',2)
/
insert into remind_formfield (field,value,urltype)values ('16232','$DOC_ModifiedDate',2)
/
insert into remind_formfield (field,value,urltype)values ('16235','$DOC_Status',2)
/
insert into remind_formfield (field,value,urltype)values ('19541','$DOC_Subject',2)
/
insert into remind_formfield (field,value,urltype)values ('16237','$DOC_Publish',2)
/
insert into remind_formfield (field,value,urltype)values ('1425','$DOC_ApproveDate',2)
/