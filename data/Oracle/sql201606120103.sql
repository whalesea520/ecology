create table workflow_requestoperatelog_oi (    
    requestid integer, 
    optlogid integer, 
    entitytype integer,
    entityid integer,
    count integer
)
/
CREATE INDEX workflow_requestoperatelog_OIX ON workflow_requestoperatelog_oi (requestid, optlogid)
/