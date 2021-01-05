alter table Prj_Settings add tsk_approval char(1)
go
alter table Prj_Settings add tsk_approval_type int
go
update Prj_Settings set tsk_approval='1',tsk_approval_type='1'
go