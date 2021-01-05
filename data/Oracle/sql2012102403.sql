CREATE OR REPLACE PROCEDURE CptUseLogBack_Insert(capitalid_1       integer,
                                                 usedate_2         char,
                                                 usedeptid_3       integer,
                                                 useresourceid_4   integer,
                                                 usecount_5        integer,
                                                 useaddress_6      varchar2,
                                                 userequest_7      integer,
                                                 maintaincompany_8 varchar2,
                                                 fee_9             decimal,
                                                 usestatus_10      varchar2,
                                                 remark_11         varchar2,
                                                 costcenterid_12   integer,
                                                 sptcount_13       char,
                                                 flag              out integer,
                                                 msg               out varchar2,
                                                 thecursor         IN OUT cursor_define.weavercursor) AS
  num_1 integer;
begin
  if sptcount_13 <> '1' then
    select capitalnum into num_1 from CptCapital where id = capitalid_1;
  end if;
  INSERT INTO CptUseLog
    (capitalid, usedate, usedeptid, useresourceid, usecount, useaddress,
     userequest, maintaincompany, fee, usestatus, remark)
  VALUES
    (capitalid_1, usedate_2, usedeptid_3, useresourceid_4, usecount_5,
     useaddress_6, userequest_7, maintaincompany_8, fee_9, '0', remark_11);
  if sptcount_13 = '1' then
    Update CptCapital
       Set departmentid = olddepartment
     where id = capitalid_1;
    Update CptCapital
       Set costcenterid = null, resourceid = null, stateid = usestatus_10,deprestartdate = null
     where id = capitalid_1;
  else
    Update CptCapital
       Set capitalnum = num_1 + usecount_5
     where id = capitalid_1;
  end if;
  open thecursor for
    select 1 from dual;
  return;
end;

/