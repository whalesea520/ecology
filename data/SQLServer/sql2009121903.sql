CREATE TABLE Workflow_RequestSign (
	id int IDENTITY,
	requestId int null ,
	nodeId int null ,
	userId int null ,
	loginType int null ,
	signNum int null ,
	signDate char(10) null ,
	signTime char(8) null
)
GO
