CREATE OR REPLACE PROCEDURE HrmContract_UpdateByHrm
(id_1 integer,
 contracttypeid_2 integer,
 startdate_3 char,
 enddate_4 char,
 proenddate_5 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmContract set
 contractstartdate = startdate_3,
 contractenddate = enddate_4,
 proenddate = proenddate_5
where
 contractman = id_1 and contracttypeid = contracttypeid_2;
end;
/