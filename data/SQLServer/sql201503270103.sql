CREATE TABLE message_log (
	loginid VARCHAR(1000) NOT NULL,
	operation_time DATETIME NOT NULL,
	client_type INT NOT NULL,
	operation_type INT NOT NULL
)
GO