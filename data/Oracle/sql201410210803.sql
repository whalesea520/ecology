DROP PROCEDURE HrmCheckPost_Insert
/
CREATE PROCEDURE HrmCheckPost_Insert ( checktypeid_2 integer, jobid_3 integer,  deptid_4 integer,  subcid_5 integer, flag out integer  , msg  out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS begin insert into HrmCheckPost (checktypeid,jobid) values (checktypeid_2,jobid_3,deptid_4,subcid_5); end;
/