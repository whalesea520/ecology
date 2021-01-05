alter table workflow_formdict add subcompanyid integer
/
alter table workflow_formdictdetail add subcompanyid integer
/
alter table workflow_formbase add subcompanyid integer
/
alter table workflow_base add subcompanyid integer
/

update MainMenuInfo set linkAddress='/workflow/field/managefield_frm.jsp' where id=118
/
update MainMenuInfo set linkAddress='/workflow/form/manageform_frm.jsp' where id=119
/
update MainMenuInfo set linkAddress='/workflow/workflow/managewf_frm.jsp' where id=120
/
