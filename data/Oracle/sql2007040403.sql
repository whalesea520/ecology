alter table DocDetail add docstatus_temp integer
/
update DocDetail set docstatus_temp = docstatus
/
alter table DocDetail drop column docstatus
/
alter table DocDetail add docstatus integer null
/
update DocDetail set docstatus = docstatus_temp
/
alter table DocDetail drop column docstatus_temp
/



