update hpBaseElement set title='建模查询中心' where id='FormModeCustomSearch'
go
CREATE TABLE formmodeelement(
	id int IDENTITY(1,1) NOT NULL,
	eid int NULL,
	reportId int NULL,
	isshowunread int NULL,
	fields varchar(400) NULL,
	fieldsWidth varchar(400) NULL,
	disorder float NULL,
	searchtitle varchar(400) NULL
)
GO