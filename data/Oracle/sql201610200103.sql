alter   table   FullSearch_FixedInst   add( showorder1  number(4,1))     
/
update FullSearch_FixedInst set showorder1 = showorder 
/
update FullSearch_FixedInst set showorder = '' 
/
ALTER TABLE FullSearch_FixedInst modify showorder  number(4,1)
/
update FullSearch_FixedInst set showorder = showorder1 
/
alter table FullSearch_FixedInst drop column showorder1
/