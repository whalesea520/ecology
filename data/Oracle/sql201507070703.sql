alter table Prj_Settings add tsk_approval char(1)
/
alter table Prj_Settings add tsk_approval_type int
/
update Prj_Settings set tsk_approval='1',tsk_approval_type='1'
/