alter table workflow_base add isSignMustInput char(1) null
/
update workflow_base set isSignMustInput='0'
/
