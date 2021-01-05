alter table workflow_formdict add subcompanyid int
go
alter table workflow_formdictdetail add subcompanyid int
go
alter table workflow_formbase add subcompanyid int
go
alter table workflow_base add subcompanyid int
go


update MainMenuInfo set linkAddress='/workflow/field/managefield_frm.jsp' where id=118
go
update MainMenuInfo set linkAddress='/workflow/form/manageform_frm.jsp' where id=119
go
update MainMenuInfo set linkAddress='/workflow/workflow/managewf_frm.jsp' where id=120
go
