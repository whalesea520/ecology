CREATE TABLE user_default_col_bak(
	id int IDENTITY(1,1) NOT NULL,
	systemid int NOT NULL,
	col_base_id int NULL,
	pageid varchar(200) NOT NULL,
	userid int NOT NULL,
	orders int NULL,
	onlyWidth int default 0,
	width_ varchar(10)
) 

GO

CREATE TABLE system_default_col_bak(
	id int  NOT NULL,
	isdefault varchar(1) NOT NULL,
	pageid varchar(200) NULL,
	align varchar(10) NULL,
	name varchar(32) NULL,
	column_ varchar(32) NULL,
	orderkey varchar(200) NULL,
	linkvaluecolumn varchar(32) NULL,
	linkkey varchar(32) NULL,
	href varchar(200) NULL,
	target varchar(32) NULL,
	transmethod varchar(100) NULL,
	otherpara varchar(2000) NULL,
	orders int NULL,
	width varchar(30) NULL,
	text_ varchar(400) NULL,
	labelid varchar(50) NULL,
	hide_ varchar(10),
	pkey varchar(100)
) 
GO