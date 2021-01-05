alter table workflow_nodehtmllayout add version int default 0
GO
update workflow_nodehtmllayout set version=0
GO
alter table workflow_nodehtmllayout add operuser int
GO
alter table workflow_nodehtmllayout add opertime varchar(50)
GO
alter table workflow_nodehtmllayout add datajson text
GO
alter table workflow_nodehtmllayout add pluginjson text
GO
alter table workflow_nodehtmllayout add scripts text
GO