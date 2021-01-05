alter table Bill_FnaPayApply alter COLUMN reason varchar(4000)
GO

update workflow_billfield 
set fielddbtype = 'varchar(4000)' 
where billid = 156 and fieldname = 'reason'
GO