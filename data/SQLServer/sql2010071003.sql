delete from fnaexpenseinfo where requestid not in (select requestid from workflow_requestbase) and requestid > 0 
go
