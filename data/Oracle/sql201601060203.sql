CREATE TABLE Workflow_VersionInfo
	(
	wfid		INTEGER,
	wfversionid	INTEGER
	)
/
create index Workflow_VersionInfo_index on Workflow_VersionInfo(wfid)
/