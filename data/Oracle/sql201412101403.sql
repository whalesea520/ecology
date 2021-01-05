CREATE OR REPLACE PROCEDURE SystemSet_DftSCUpdate(dftsubcomid_1       integer,
                                                  hrmdftsubcomid_2    integer,
                                                  wfdftsubcomid_3     integer,
                                                  docdftsubcomid_4    integer,
                                                  portaldftsubcomid_5 integer,
                                                  cptdftsubcomid_6    integer,
                                                  mtidftsubcomid_7    integer,
                                                  flag                out integer,
                                                  msg                 out varchar2,
                                                  thecursor           IN OUT cursor_define.weavercursor) AS
begin
  update HrmRoles
     set subcompanyid = dftsubcomid_1
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update HrmCareerApply
     set subCompanyId = dftsubcomid_1
   where subCompanyId is null
      or subCompanyId = 0
      or subCompanyId = -1
      or subCompanyId not in (select id from hrmsubcompany);
  update HrmContractTemplet
     set subcompanyid = dftsubcomid_1
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update HrmContractType
     set subcompanyid = dftsubcomid_1
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update workflow_formdict
     set subcompanyid = wfdftsubcomid_3
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update workflow_formdictdetail
     set subcompanyid = wfdftsubcomid_3
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update workflow_formbase
     set subcompanyid = wfdftsubcomid_3
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update workflow_base
     set subcompanyid = wfdftsubcomid_3
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update cptcapital
     set blongsubcompany = cptdftsubcomid_6
   where blongsubcompany is null
      or blongsubcompany = 0
      or blongsubcompany = -1
      or blongsubcompany not in (select id from hrmsubcompany);
  UPDATE MeetingRoom
     SET subcompanyId = mtidftsubcomid_7
   WHERE subcompanyId IS null
      OR subcompanyId = 0
      OR subcompanyId = -1
      OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany);
  UPDATE Meeting_Type
     SET subcompanyId = mtidftsubcomid_7
   WHERE subcompanyId IS null
      OR subcompanyId = 0
      OR subcompanyId = -1
      OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany);
end;
/