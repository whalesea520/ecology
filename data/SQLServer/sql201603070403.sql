update hpBaseElement set title='��ģ��ѯ����' where id='FormModeCustomSearch'
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