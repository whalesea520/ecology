alter table workflow_nodehtmllayout add version int default 0
/
update workflow_nodehtmllayout set version=0
/
alter table workflow_nodehtmllayout add operuser int
/
alter table workflow_nodehtmllayout add opertime varchar(50)
/
alter table workflow_nodehtmllayout add datajson clob
/
alter table workflow_nodehtmllayout add pluginjson clob
/
alter table workflow_nodehtmllayout add scripts clob
/