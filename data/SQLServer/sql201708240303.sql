create table remindfornewDoc (
	urltype integer,
	titlemessage varchar(4000),
	bodymessage varchar(4000),
	secid integer
)
go
create table remind_formfield(
	id int primary key identity(1,1),
	field varchar(2000),
	value varchar(2000),
	urltype integer
)
go
insert into remind_formfield (field,value,urltype)values ('16398','$DOC_SecCategory',1)
go
insert into remind_formfield (field,value,urltype)values ('27142','$DOC_SubjectByLink',1)
go
insert into remind_formfield (field,value,urltype)values ('19225','$DOC_Department',1)
go
insert into remind_formfield (field,value,urltype)values ('16228','$DOC_Content',1)
go
insert into remind_formfield (field,value,urltype)values ('16229','$DOC_CreatedByFull',1)
go
insert into remind_formfield (field,value,urltype)values ('722','$DOC_CreatedDate',1)
go
insert into remind_formfield (field,value,urltype)values ('16232','$DOC_ModifiedDate',1)
go
insert into remind_formfield (field,value,urltype)values ('16235','$DOC_Status',1)
go
insert into remind_formfield (field,value,urltype)values ('19541','$DOC_Subject',1)
go
insert into remind_formfield (field,value,urltype)values ('16237','$DOC_Publish',1)
go
insert into remind_formfield (field,value,urltype)values ('1425','$DOC_ApproveDate',1)
go
insert into remind_formfield (field,value,urltype)values ('16398','$DOC_SecCategory',2)
go
insert into remind_formfield (field,value,urltype)values ('19225','$DOC_Department',2)
go
insert into remind_formfield (field,value,urltype)values ('16228','$DOC_Content',2)
go
insert into remind_formfield (field,value,urltype)values ('16229','$DOC_CreatedByFull',2)
go
insert into remind_formfield (field,value,urltype)values ('722','$DOC_CreatedDate',2)
go
insert into remind_formfield (field,value,urltype)values ('16232','$DOC_ModifiedDate',2)
go
insert into remind_formfield (field,value,urltype)values ('16235','$DOC_Status',2)
go
insert into remind_formfield (field,value,urltype)values ('19541','$DOC_Subject',2)
go
insert into remind_formfield (field,value,urltype)values ('16237','$DOC_Publish',2)
go
insert into remind_formfield (field,value,urltype)values ('1425','$DOC_ApproveDate',2)
go