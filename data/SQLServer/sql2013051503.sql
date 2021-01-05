CREATE TABLE HrmOnlineAvg
	(
	id           INT IDENTITY NOT NULL,
	online_year  int NULL,
	online_month INT NULL,
	online_date  VARCHAR (10) NULL,
	point_time   INT NULL,
	online_num   INT NULL
	)
GO

CREATE INDEX HrmOnlineAvg_index1 ON HrmOnlineAvg (online_date)
GO

CREATE INDEX HrmOnlineAvg_index2 ON HrmOnlineAvg (online_year)
GO

CREATE TABLE HrmOnlineCount
	(
	id           INT IDENTITY NOT NULL,
	online_date  VARCHAR (10) NULL,
	online_time  VARCHAR (8) NULL,
	online_num   INT NULL,
	online_month INT NULL,
	online_year  INT NULL
	)
GO

CREATE INDEX HrmOnlineCount_index1 ON HrmOnlineCount (online_date)
GO

CREATE INDEX HrmOnlineCount_index2 ON HrmOnlineCount (online_year)
GO
