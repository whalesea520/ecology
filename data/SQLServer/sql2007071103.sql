update CptCapital set olddepartment=(select distinct usedeptid from cptuselog where usestatus=1 and capitalid=CptCapital.id) 
go