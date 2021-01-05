CREATE TABLE hrm_password_protection_set(
	id bigint IDENTITY(1,1) NOT NULL primary key,
	user_id bigint NOT NULL,
	enabled int NOT NULL
)
GO
CREATE TABLE hrm_protection_question(
	id bigint IDENTITY(1,1) NOT NULL primary key,
	user_id bigint NOT NULL,
	question varchar(100) NOT NULL,
	answer varchar(500) NOT NULL,
	delflag int NOT NULL
)
GO