CREATE TABLE workflow_reqbrowextrainfo (
	id INT PRIMARY KEY IDENTITY,
	requestid INT,
	fieldid VARCHAR(255),
	type INT,
	typeid INT,
	ids TEXT,
	md5 VARCHAR(255)
)
GO