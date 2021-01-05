alter table CptCapital 
add frozennum decimal(18,1) default 0.0
GO

update CptCapital set frozennum = 0.0
GO