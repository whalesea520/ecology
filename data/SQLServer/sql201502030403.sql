CREATE TABLE ModeFieldAuthorize(
	id int IDENTITY(1,1) NOT NULL,
	modeid int NULL,
	formid int NULL,
	fieldid int NULL,
	opttype int NULL,
	layoutid int NULL,
	layoutlevel int NULL
)
GO