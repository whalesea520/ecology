ALTER TABLE FnaSystemSet ADD fnaWfSysWf int
go

ALTER TABLE FnaSystemSet ADD fnaWfCustom int
go


update FnaSystemSet set fnaWfSysWf = 1, fnaWfCustom = 1 
go