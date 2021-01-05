create table workflow_specialfield(
    id int identity not null,
    fieldid int null,
    displayname varchar(1000),
    linkaddress varchar(1000),
    descriptivetext text,
    isbill int null,
    isform int null
)
GO
