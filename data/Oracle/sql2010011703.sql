alter table HRMSTATUSHISTORY add oldmanagerid integer
/
alter table HRMSTATUSHISTORY add newmanagerid integer
/

CREATE OR REPLACE PROCEDURE HrmResource_DepUpdate(id_1           integer,
                                                  departmentid_2 integer,
                                                  joblevel_3     integer,
                                                  costcenterid_4 integer,
                                                  jobtitle_5     integer,
                                                  newmanagerid_1 integer,
                                                  flag           out integer,
                                                  msg            out varchar2,
                                                  thecursor      IN OUT cursor_define.weavercursor) as
begin
  update HrmResource
     set departmentid = departmentid_2,
         joblevel     = joblevel_3,
         costcenterid = costcenterid_4,
         jobtitle     = jobtitle_5,
         managerid    = newmanagerid_1
   where id = id_1;
end;
/

CREATE OR REPLACE PROCEDURE HrmResource_Redeploy(id_1              integer,
                                                 changedate_2      char,
                                                 changereason_4    clob,
                                                 oldjobtitleid_7   integer,
                                                 oldjoblevel_8     integer,
                                                 newjobtitleid_9   integer,
                                                 newjoblevel_10    integer,
                                                 infoman_6         varchar2,
                                                 type_n_11         integer,
                                                 ischangesalary_12 integer,
                                                 oldmanagerid_1    integer,
                                                 newmanagerid_1    integer,
                                                 flag              out integer,
                                                 msg               out varchar2,
                                                 thecursor         IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO HrmStatusHistory
    (resourceid,
     changedate,
     changereason,
     oldjobtitleid,
     oldjoblevel,
     newjobtitleid,
     newjoblevel,
     infoman,
     type_n,
     ischangesalary,
     oldmanagerid,
     newmanagerid)
  VALUES
    (id_1,
     changedate_2,
     changereason_4,
     oldjobtitleid_7,
     oldjoblevel_8,
     newjobtitleid_9,
     newjoblevel_10,
     infoman_6,
     type_n_11,
     ischangesalary_12,
     oldmanagerid_1,
     newmanagerid_1);
end;
/
