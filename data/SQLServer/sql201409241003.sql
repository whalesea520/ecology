create table HrmCompanyVirtual (
   id                   int                  not null,
   companyname          varchar(200)         null,
   companycode          varchar(200)         null,
   companydesc          varchar(200)         null,
   canceled              int                  null,
   showorder            int                  null,
   virtualType          varchar(200)         null,
   constraint PK_HRMCOMPANYVIRTUAL primary key (id)
)
go

create table HrmSubCompanyVirtual (
   id                   int                  not null,
   subcompanyname       varchar(200)         null,
   subcompanycode       varchar(200)         null,
   subcompanydesc       varchar(200)         null,
   supsubcomid          int                  null,
   companyid            int                  null,
   canceled               int                  null,
   showorder            int                  null,
   constraint PK_HRMSUBCOMPANYVIRTUAL primary key (id)
)
go 

create table HrmDepartmentVirtual (
   id                   int                  not null,
   departmentname       varchar(200)         null,
   departmentcode       varchar(200)         null,
   departmentmark       varchar(200)         null,
   supdepid             int                  null,
   allsupdepid          varchar(60)          null,
   subcompanyid1        int                  null,
   canceled               int                  null,
   showorder            int                  null,
   constraint PK_HRMDEPARTMENTVIRTUAL primary key (id)
)
GO

create table HrmResourceVirtual (
   id                   int                  not null,
   resourceid           int                  null,
   managerid            int                  null,
   subcompanyid         int                  null,
   departmentid         int                  null,
   constraint PK_HRMRESOURCEVIRTUAL primary key (id)
)
go
INSERT INTO SystemLogItem
        ( itemid, lableid, itemdesc, typeid )
VALUES  ( '311',
          140,
          '虚拟总部',
          2
          )
go
INSERT INTO SystemLogItem
        ( itemid, lableid, itemdesc, typeid )
VALUES  ( '312',
          141,
          '虚拟分部',
          2
          )
go          
INSERT INTO SystemLogItem
        ( itemid, lableid, itemdesc, typeid )
VALUES  ( '313',
          124,
          '虚拟部门',
          2
          )
go        
INSERT INTO SystemLogItem
        ( itemid, lableid, itemdesc, typeid )
VALUES  ( '314',
          30042,
          '虚拟人员',
          2
          )
go