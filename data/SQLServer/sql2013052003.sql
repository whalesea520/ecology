CREATE TABLE HrmRefuseCount
	(
	id           INT IDENTITY NOT NULL,
	refuse_date  VARCHAR (10) NULL,
	refuse_year  INT NULL,
	refuse_month INT NULL,
	refuse_hour  INT NULL,
	refuse_loginid   varchar(100) NULL
	)
GO

CREATE INDEX HrmRefuseCount_index1 ON HrmRefuseCount (refuse_date)
GO
CREATE INDEX HrmRefuseCount_index2 ON HrmRefuseCount (refuse_year)
GO
CREATE INDEX HrmRefuseCount_index3 ON HrmRefuseCount (refuse_date,refuse_hour)
GO 

CREATE TABLE HrmRefuseAvg
	(
	id           INT IDENTITY NOT NULL,
	refuse_date  VARCHAR (10) NULL,
	refuse_year  int NULL,
	refuse_month INT NULL,
	refuse_hour   INT NULL,
	refuse_num   INT NULL
	)
GO

CREATE INDEX HrmRefuseAvg_index1 ON HrmRefuseAvg (refuse_date)
GO
CREATE INDEX HrmRefuseAvg_index2 ON HrmRefuseAvg (refuse_year)
GO
CREATE INDEX HrmRefuseAvg_index3 ON HrmRefuseAvg (refuse_date,refuse_hour)
GO 
CREATE INDEX HrmRefuseAvg_index4 ON HrmRefuseAvg (refuse_year,refuse_month)
GO




