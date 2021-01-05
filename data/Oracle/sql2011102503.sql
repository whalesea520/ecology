alter table workflow_requestbase add ismultiprint integer default 0
/
update workflow_requestbase set ismultiprint=0
/