update HrmResource set dsporder = id where dsporder is null
go
ALTER table  HrmResource  ADD demandnumcc FLOAT
go
update   HrmResource set demandnumcc = dsporder
go
ALTER table  HrmResource  drop column dsporder
go
EXEC   sp_rename   'HrmResource.[demandnumcc]',   'dsporder',   'COLUMN'   
go