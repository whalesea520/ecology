alter table mode_CustomDspField add isadvancedquery char(1) 
go
alter table mode_CustomDspField add advancedqueryorder int default 0 not null
go
create table mode_TemplateDspField
(
    ID INT primary key identity(1,1),
    templateid int,
    fieldid int,
    isshow int,
    fieldorder int,
    topt varchar(10),
    topt1 varchar(10),
    tvalue varchar(100),
    tvalue1 varchar(100),
    tname varchar(100)
)
go
create table mode_TemplateInfo
(
    ID INT primary key identity(1,1),
    customid int,
    templatename varchar(100),
    templatetype char(1),
    displayorder int,
    isdefault int,
    createrid int,
    createdate varchar(50)
)
go