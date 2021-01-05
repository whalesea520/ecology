CREATE TABLE excelStyleDec(
	id int IDENTITY(1,1) NOT NULL,
	stylename varchar(500) NULL,
	mainrowheight int NULL,
	mainlblwidth int NULL,
	mainlblwidthselect int NULL,
	mainfieldwidth int NULL,
	mainfieldwidthselect int NULL,
	mainborder varchar(10) NULL,
	mainlblbgcolor varchar(10) NULL,
	mainfieldbgcolor varchar(10) NULL,
	detailrowheight int NULL,
	detailcolwidth int NULL,
	detailcolwidthselect int NULL,
	detailborder varchar(10) NULL,
	detaillblbgcolor varchar(10) NULL,
	detailfieldbgcolor varchar(10) NULL
)
GO