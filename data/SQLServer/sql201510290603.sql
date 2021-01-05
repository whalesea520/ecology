CREATE TABLE mobile_rongGroupNotice (
	id int IDENTITY PRIMARY KEY,
	targetid  VARCHAR(100),
	sendid INT NOT NULL,
	content VARCHAR(4000),
	operate_date VARCHAR(50) NOT NULL
)
GO