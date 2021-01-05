update hrmsalaryitem set applyscope=0,subcompanyid=(select min(id) from hrmsubcompany) where subcompanyid is null or subcompanyid=0
/