CREATE TABLE SysDetachInfo ( 
    id int IDENTITY PRIMARY KEY,
    name varchar(50),
    description varchar(200)
    ) 
GO

CREATE TABLE SysDetachDetail ( 
    id int IDENTITY PRIMARY KEY,
    infoid int,
    sourcetype int,
    [type] int,
    content varchar(50),
    seclevel int
    ) 
GO

CREATE TABLE SysDetachReport ( 
    id int IDENTITY PRIMARY KEY,
    fromid int,
    frominfoid int,
    fromtype int,
    fromcontent varchar(50),
    fromseclevel int,
    toid int,
    toinfoid int,
    totype int,
    tocontent varchar(50),
    toseclevel int
    )
GO
    
alter table SystemSet ADD appdetachable int
GO
