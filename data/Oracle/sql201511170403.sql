alter table FnaSystemSet add ifbudgetmove2 integer
/

alter table FnaSystemSet add ifbudgetmoveRepeat integer
/

update FnaSystemSet set ifbudgetmove2 = 0, ifbudgetmoveRepeat = 0
/