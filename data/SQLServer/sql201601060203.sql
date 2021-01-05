CREATE TABLE Workflow_VersionInfo
	(
	wfid		INT,
	wfversionid	INT
	)
GO
create index Workflow_VersionInfo_index on Workflow_VersionInfo(wfid)
GO