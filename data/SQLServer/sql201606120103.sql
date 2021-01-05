create table workflow_requestoperatelog_oi (    
    requestid int, 
    optlogid int, 
    entitytype int,
    entityid int,
    count int
)
go
CREATE INDEX workflow_requestoperatelog_OIX ON workflow_requestoperatelog_oi (requestid, optlogid)
go