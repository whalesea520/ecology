create table fnaFccDimension(
	id int IDENTITY(1,1) not null primary key, 
	name VARCHAR(4000), 
	type VARCHAR(50), 
	fielddbtype VARCHAR(500), 
	displayOrder DECIMAL(6,3) 
)
GO

CREATE INDEX idx_fnaFccDimension_1 ON fnaFccDimension (displayOrder)
GO

alter table FnaCostCenterDtl add objValue varchar(100)
GO

update FnaCostCenterDtl set objValue = convert(varchar, objId) where objId is not null
GO

CREATE INDEX idx_FnaCostCenterDtl_3 ON FnaCostCenterDtl (objId)
GO
CREATE INDEX idx_FnaCostCenterDtl_4 ON FnaCostCenterDtl (objValue)
GO