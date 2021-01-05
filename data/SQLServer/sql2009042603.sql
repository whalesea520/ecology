create table CRM_Evaluation_LevelDetail(
	id  int IDENTITY(1,1) primary key CLUSTERED,
	customerID varchar(20) NOT NULL,
	evaluationID varchar(20) NOT NULL,
	levelID varchar(20) NOT NULL
)
GO