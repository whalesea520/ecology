alter table workflow_base add isneeddelacc varchar2(1)
/
update workflow_base set isneeddelacc='0'
/