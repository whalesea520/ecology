DROP TABLE HrmCompanyVirtual
GO
DROP TABLE HrmSubCompanyVirtual
GO
DROP TABLE HrmDepartmentVirtual
GO
create table HrmCompanyVirtual (
   id                   int  IDENTITY(-1,-1)                not null,
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
   id                   int         IDENTITY(-1,-1)          not null,
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
   id                   int        IDENTITY(-1,-1)           not null,
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

ALTER PROCEDURE HrmCompanyVirtual_Select
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(80) OUTPUT
AS 
    SELECT  *
    FROM    HrmCompanyVirtual
    ORDER BY id desc
    SET @flag = 0
    SET @msg = '操作成功完成'
GO
 
ALTER PROCEDURE HrmSubCompanyVirtual_Select
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(80) OUTPUT
AS 
    SELECT  *
    FROM    HrmSubCompanyVirtual
    ORDER BY showorder ASC, id desc
    SET @flag = 0
    SET @msg = '操作成功完成' 
GO   
 
ALTER PROCEDURE HrmDepartmentVirtual_Select
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(80) OUTPUT
AS 
    SELECT  *
    FROM    HrmDepartmentVirtual
    ORDER BY showorder ASC, id desc
    SET @flag = 0
    SET @msg = '操作成功完成'

GO