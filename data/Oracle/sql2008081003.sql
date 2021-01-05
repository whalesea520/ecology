alter table workflow_bill
add formdes varchar(500) null
/

alter table workflow_bill
add subcompanyid integer null
/

alter table workflow_billfield
add textheight integer null
/

delete from MainMenuInfo where id=423
/
