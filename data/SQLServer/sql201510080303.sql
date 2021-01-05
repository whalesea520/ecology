CREATE TABLE mobile_ding (
	id int IDENTITY PRIMARY KEY,
	sendid INT NOT NULL,
	content VARCHAR(1000),
	scopeid VARCHAR(100),
	messageid VARCHAR(100),
	udid VARCHAR(100),
	operate_date CHAR(20) NOT NULL
)
GO

CREATE TABLE mobile_dingReciver (
	id int IDENTITY PRIMARY KEY,
	dingid INT NOT NULL,
	userid INT NOT NULL,
	confirm CHAR(20) NOT NULL
)
GO

CREATE TABLE mobile_dingReply (
	id int IDENTITY PRIMARY KEY,
	dingid INT NOT NULL,
	userid INT NOT NULL,
	content VARCHAR(1000),
	operate_date CHAR(20) NOT NULL
)
GO

CREATE TABLE mobile_rongGroup (
	id int IDENTITY PRIMARY KEY,
	userid INT NOT NULL,
	group_id VARCHAR(200)
)
GO