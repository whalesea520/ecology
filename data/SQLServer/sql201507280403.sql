create table prj_typecreatelist
(
  id INTEGER IDENTITY(1,1) NOT NULL primary key,
  typeid                    INTEGER not null,
  seclevel                 INTEGER,
  departmentid             INTEGER,
  roleid                   INTEGER,
  rolelevel                INTEGER,
  usertype                 INTEGER,
  permissiontype           INTEGER not null,
  operationcode            INTEGER not null,
  userid                   INTEGER,
  subcompanyid             INTEGER,
  seclevelmax              INTEGER
)
go

insert into prj_typecreatelist(typeid, seclevel, operationcode, permissiontype,seclevelmax) select t.id,0,0,3,100 from prj_projecttype t
go