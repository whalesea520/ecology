alter table FnaSystemSet add enableDispalyAll int
GO
alter table FnaSystemSet add separator VARCHAR(15)
GO
update FnaSystemSet set enableDispalyAll=0
GO