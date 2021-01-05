CREATE TABLE HistorySearch(
	id int primary key identity(1,1),
	userid varchar(50) NULL,
	searchtext varchar(255) NULL,
	searchdate varchar(10) NULL,
	searchtime varchar(8) NULL,
	searchtype int NULL
)
GO