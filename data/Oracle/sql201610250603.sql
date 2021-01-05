CREATE OR REPLACE PROCEDURE workflow_Rbase_UpdateLevel(requestid1 integer,
                                                       level_n1   integer,
                                                       flag       out integer,
                                                       msg        out varchar2,
                                                       thecursor  IN OUT cursor_define.weavercursor) AS
begin
  if level_n1 is null or level_n1 = '' then
    Update workflow_requestbase
       set requestlevel = 0
     where requestid = requestid1;
  else
    Update workflow_requestbase
       set requestlevel = level_n1
     where requestid = requestid1;
  end if;
end;
/