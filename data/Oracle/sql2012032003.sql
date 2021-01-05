update SystemLoginTemplate set iscurrent=0 where iscurrent=1
/
update SystemLoginTemplate set iscurrent=1 where logintemplateid=3
/
UPDATE SystemTemplate SET extendtempletid=3
/