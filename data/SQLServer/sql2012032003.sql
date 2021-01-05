update SystemLoginTemplate set iscurrent=0 where iscurrent=1
GO
update SystemLoginTemplate set iscurrent=1 where logintemplateid=3
GO
UPDATE SystemTemplate SET extendtempletid=3
GO
