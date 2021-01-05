DROP TABLE HrmCompanyVirtual
/
DROP TABLE HrmSubCompanyVirtual
/
DROP TABLE HrmDepartmentVirtual
/
create table HrmCompanyVirtual (
   id                   int			         null,
   companyname          varchar(200)         null,
   companycode          varchar(200)         null,
   companydesc          varchar(200)         null,
   canceled              int                  null,
   showorder            int                  null,
   virtualType          varchar(200)         null,
   constraint PK_HRMCOMPANYVIRTUAL primary key (id)
)
/
create sequence HrmCompanyVirtual_id
minvalue -99999999999999999
maxvalue -1
start with -1
increment by -1
cache 20
/
CREATE OR REPLACE TRIGGER HrmCompanyVirtual_Trigger before insert on HrmCompanyVirtual for each row begin select HrmCompanyVirtual_id.nextval into :new.id from dual; end;
/
create table HrmSubCompanyVirtual (
   id                   int    not null,
   subcompanyname       varchar(200)         null,
   subcompanycode       varchar(200)         null,
   subcompanydesc       varchar(200)         null,
   supsubcomid          int                  null,
   companyid            int                  null,
   canceled               int                  null,
   showorder            int                  null,
   constraint PK_HRMSUBCOMPANYVIRTUAL primary key (id)
)
/ 
create sequence HrmSubCompanyVirtual_id
minvalue -99999999999999999
maxvalue -1
start with -1
increment by -1
cache 20
/
CREATE OR REPLACE TRIGGER HrmSubCompanyVirtual_Trigger before insert on HrmSubCompanyVirtual for each row begin select HrmSubCompanyVirtual_id.nextval into :new.id from dual; end;
/
create table HrmDepartmentVirtual (
   id                   int            not null,
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
/
create sequence HrmDepartmentVirtual_id
minvalue -99999999999999999
maxvalue -1
start with -1
increment by -1
cache 20
/
CREATE OR REPLACE TRIGGER HrmDepartmentVirtual_Trigger before insert on HrmDepartmentVirtual for each row begin select HrmDepartmentVirtual_id.nextval into :new.id from dual; end;
/
CREATE OR REPLACE PROCEDURE HrmSubCompanyVirtual_Select(flag      out integer,
                                                 msg       out varchar2,
                                                 thecursor IN OUT cursor_define.weavercursor) as
begin
  open thecursor for
    select *
      from HrmSubCompanyVirtual
     order by supsubcomid, showorder, subcompanyname;
end;
/
CREATE OR REPLACE PROCEDURE HrmCompanyVirtual_Select(flag      out integer,
                                              msg       out varchar2,
                                              thecursor IN OUT cursor_define.weavercursor) as
begin
  open thecursor for
    select * from HrmCompanyVirtual;
end;
/
CREATE OR REPLACE PROCEDURE HrmDepartmentVirtual_Select(flag      out integer,
                                                 msg       out varchar2,
                                                 thecursor IN OUT cursor_define.weavercursor) AS
begin
  open thecursor for
    select *
      from HrmDepartmentVirtual
     order by subcompanyid1, supdepid, showorder, departmentname;
end;
/
