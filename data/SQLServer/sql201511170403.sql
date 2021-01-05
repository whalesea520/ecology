alter table FnaSystemSet add ifbudgetmove2 int
go

alter table FnaSystemSet add ifbudgetmoveRepeat int
go

update FnaSystemSet set ifbudgetmove2 = 0, ifbudgetmoveRepeat = 0
go