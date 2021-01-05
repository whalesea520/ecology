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
