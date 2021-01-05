CREATE TABLE message_log (
	loginid VARCHAR2(1000) NOT NULL,
	operation_time DATE NOT NULL,
	client_type INT NOT NULL,
	operation_type INT NOT NULL
)
/