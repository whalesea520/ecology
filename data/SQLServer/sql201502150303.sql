CREATE TABLE mobile_sign (
	id int IDENTITY PRIMARY KEY,
	operater INT NOT NULL,
	operate_type VARCHAR(50) NOT NULL,
	operate_date CHAR(10) NOT NULL,
	operate_time CHAR(8) NOT NULL,
	longitude NUMERIC(18,8) NOT NULL,
	latitude NUMERIC(18,8) NOT NULL,
	address VARCHAR(500),
	remark VARCHAR(1000),
	attachment VARCHAR(500)
)
GO