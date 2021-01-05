create table workflow_requestoperatelog(    
    id int primary key identity(1, 1),
    requestid int, 
    nodeid int, 
    isremark int, 
    operatorid int, 
    operatortype int, 
    operatedate varchar(10), 
    operatetime varchar(8), 
    operatetype varchar(25), 
    operatename varchar(100), 
    operatecode int, 
    isinvalid char(1), 
    invalidid int,
    invaliddate varchar(10), 
    invalidtime varchar(8)
)
go
create table workflow_requestoperatelog_dtl (    
    requestid int, 
    optlogid int, 
    entitytype int,
    entityid int,
    ismodify char(1),
    fieldname nvarchar(100), 
    ovalue nvarchar(100), 
    nvalue nvarchar(100)
)
go
CREATE INDEX workflow_requestoperatelog_IX ON workflow_requestoperatelog (requestid, isinvalid)
go
CREATE INDEX workflow_requestoperatelog_DIX ON workflow_requestoperatelog_dtl (requestid, optlogid)
go