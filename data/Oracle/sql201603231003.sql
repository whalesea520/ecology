CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type7(
 dirid_1 integer,
  dirtype_1 integer,
  permissiontype_1 integer,
  operationcode_1 integer,
  jobids_1 integer,
  joblevel_1 integer,
  jobdepartment_1 integer,
  jobsubcompany_1 integer,                                                                                                
  flag            out integer,
  msg             out varchar2,
  thecursor       IN OUT cursor_define.weavercursor) AS
begin
  insert into DirAccessControlList
    ( dirid,
  dirtype,
  permissiontype,
  operationcode,
  jobids,
  joblevel,
  jobdepartment,
  jobsubcompany)
  values
    ( dirid_1,
    dirtype_1,
    permissiontype_1,
    operationcode_1,
    jobids_1,
    joblevel_1,
    jobdepartment_1,
    jobsubcompany_1);
end;
/