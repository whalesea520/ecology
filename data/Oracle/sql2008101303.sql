alter table CptCapital 
add frozennum decimal(18,1) default 0.0
/

update CptCapital set frozennum = 0.0
/