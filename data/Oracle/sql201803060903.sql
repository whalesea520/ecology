CREATE OR REPLACE PROCEDURE CptUseLogInStock_Insert(capitalid_1       integer,
                                                    usedate_2         char,
                                                    usedeptid_3       in out integer,
                                                    useresourceid_4   in out integer,
                                                    checkerid         integer,
                                                    usecount_5        number,
                                                    useaddress_6      varchar2,
                                                    userequest_7      integer,
                                                    maintaincompany_8 varchar2,
                                                    fee_9             number,
                                                    usestatus_10      varchar2,
                                                    remark_11         varchar2,
                                                    mark_1            varchar2,
                                                    datatype_1        integer,
                                                    startdate_1       char,
                                                    enddate_1         char,
                                                    deprestartdate_1  char,
                                                    depreenddate_1    char,
                                                    manudate_1        char,
                                                    lastmoderid_1     integer,
                                                    lastmoddate_1     char,
                                                    lastmodtime_1     char,
                                                    inprice_1         number,
                                                    crmid_1           integer,
                                                    counttype_1       char,
                                                    isinner_1         char,
                                                    flag              out integer,
                                                    msg               out varchar2,
                                                    thecursor         IN OUT cursor_define.weavercursor) AS
  num number(18, 3);
begin
  if usestatus_10 = '2' then
    INSERT INTO CptUseLog
      (capitalid,
       usedate,
       usedeptid,
       useresourceid,
       usecount,
       useaddress,
       userequest,
       maintaincompany,
       fee,
       usestatus,
       remark)
    VALUES
      (capitalid_1,
       usedate_2,
       usedeptid_3,
       checkerid,
       usecount_5,
       useaddress_6,
       userequest_7,
       maintaincompany_8,
       fee_9,
       '1',
       remark_11);
  end if;
  INSERT INTO CptUseLog
    (capitalid,
     usedate,
     usedeptid,
     useresourceid,
     usecount,
     useaddress,
     userequest,
     maintaincompany,
     fee,
     usestatus,
     remark)
  VALUES
    (capitalid_1,
     usedate_2,
     usedeptid_3,
     useresourceid_4,
     usecount_5,
     useaddress_6,
     userequest_7,
     maintaincompany_8,
     fee_9,
     usestatus_10,
     remark_11);
  select capitalnum INTO num from CptCapital where id = capitalid_1;
  if usestatus_10 = '1' then
    useresourceid_4 := 0;
  end if;
  if usedeptid_3 = 0 then
    usedeptid_3 := null;
  end if;
  Update CptCapital
     Set mark           = mark_1,
         capitalnum     = usecount_5 + num,
         location       = useaddress_6,
         departmentid   = usedeptid_3,
         resourceid     = useresourceid_4,
         stateid        = usestatus_10,
         datatype       = datatype_1,
         isdata         = '2',
         startdate      = startdate_1,
         enddate        = enddate_1,
         deprestartdate = deprestartdate_1,
         depreenddate   = depreenddate_1,
         manudate       = manudate_1,
         lastmoderid    = lastmoderid_1,
         lastmoddate    = lastmoddate_1,
         lastmodtime    = lastmodtime_1,
         startprice     = inprice_1,
         customerid     = crmid_1,
         counttype      = counttype_1,
         isinner        = isinner_1
   where id = capitalid_1;
end;
/