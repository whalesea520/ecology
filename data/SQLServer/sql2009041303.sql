update workflow_billfield set fielddbtype = 'decimal(15,2)' where billid = 180 and fieldname = 'leaveDays'
go
alter table Bill_BoHaiLeave alter column leavedays decimal(15,2)
go


