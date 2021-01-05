ALTER TABLE mode_customsearch ADD customsearchcode VARCHAR(32)
go
update mode_customsearch set customsearchcode = dbo.fun_getUUID32(NEWID()) where customsearchcode is null or customsearchcode=''
go