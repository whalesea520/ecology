CREATE TABLE WFOpinionTableNames
(
	id int IDENTITY,
	name varchar(40) null
)
GO

ALTER TABLE WORKFLOW_REQUESTLOG ADD LOGID INT IDENTITY
GO
