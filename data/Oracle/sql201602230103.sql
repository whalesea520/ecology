ALTER TABLE Prj_T_ShareInfo ADD jobtitleid INT DEFAULT 0
/
ALTER TABLE Prj_T_ShareInfo ADD joblevel INT DEFAULT 0
/
ALTER TABLE Prj_T_ShareInfo ADD scopeid varchar2(100) DEFAULT '0'
/
ALTER TABLE Prj_ShareInfo ADD jobtitleid INT DEFAULT 0
/
ALTER TABLE Prj_ShareInfo ADD joblevel INT DEFAULT 0
/
ALTER TABLE Prj_ShareInfo ADD scopeid varchar2(100) DEFAULT '0'
/
ALTER TABLE prj_typecreatelist ADD jobtitleid INT DEFAULT 0
/
ALTER TABLE prj_typecreatelist ADD joblevel INT DEFAULT 0
/
ALTER TABLE prj_typecreatelist ADD scopeid varchar2(100) DEFAULT '0'
/
ALTER TABLE Prj_TaskShareInfo ADD jobtitleid INT DEFAULT 0
/
ALTER TABLE Prj_TaskShareInfo ADD joblevel INT DEFAULT 0
/
ALTER TABLE Prj_TaskShareInfo ADD scopeid varchar2(100) DEFAULT '0'
/
ALTER TABLE CptAssortmentShare ADD seclevelMax INT DEFAULT 100
/
ALTER TABLE CptAssortmentShare ADD jobtitleid INT DEFAULT 0
/
ALTER TABLE CptAssortmentShare ADD joblevel INT DEFAULT 0
/
ALTER TABLE CptAssortmentShare ADD scopeid varchar2(100) DEFAULT '0'
/
ALTER TABLE CptCapitalShareInfo ADD seclevelMax INT DEFAULT 100
/
ALTER TABLE CptCapitalShareInfo ADD jobtitleid INT DEFAULT 0
/
ALTER TABLE CptCapitalShareInfo ADD joblevel INT DEFAULT 0
/
ALTER TABLE CptCapitalShareInfo ADD scopeid varchar2(100) DEFAULT '0'
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authPrjD511',class_name='weaver.hrm.authority.manager.HrmPrjCptShifter' where code_name = 'D511'
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authPrjC511',class_name='weaver.hrm.authority.manager.HrmPrjCptShifter' where code_name = 'C511'
/


CREATE OR REPLACE PROCEDURE Prj_ShareInfo_Update(typeid_1     integer,
                                                 customerid_1 integer,
                                                 flag         out integer,
                                                 msg          out varchar2,
                                                 thecursor    IN OUT cursor_define.weavercursor) as
  theid_1         integer;
  relateditemid_1 integer;
  sharetype_1     smallint;
  seclevel_1      smallint;
  rolelevel_1     smallint;
  sharelevel_1    smallint;
  userid_1        integer;
  departmentid_1  integer;
  roleid_1        integer;
  foralluser_1    smallint;
  crmid_1         integer;
  subcompanyid_1  integer;
  jobtitleid_1    integer;
  joblevel_1      integer;
  scopeid_1       varchar2(100);
begin
  for all_cursor IN (select id
                       from Prj_T_ShareInfo
                      WHERE relateditemid = typeid_1) loop
    theid_1 := all_cursor.id;
    select sharetype,
           seclevel,
           rolelevel,
           sharelevel,
           userid,
           departmentid,
           roleid,
           foralluser,
           crmid,
           subcompanyid,
           jobtitleid,
           joblevel,
           scopeid
      INTO sharetype_1,
           seclevel_1,
           rolelevel_1,
           sharelevel_1,
           userid_1,
           departmentid_1,
           roleid_1,
           foralluser_1,
           crmid_1,
           subcompanyid_1,
           jobtitleid_1,
           joblevel_1,
           scopeid_1
      from Prj_T_ShareInfo
     WHERE id = theid_1;
    insert INTO Prj_ShareInfo
      (relateditemid,
       sharetype,
       seclevel,
       rolelevel,
       sharelevel,
       userid,
       departmentid,
       roleid,
       foralluser,
       crmid,
       isdefault,
       subcompanyid,
       jobtitleid,
       joblevel,
       scopeid)
    values
      (customerid_1,
       sharetype_1,
       seclevel_1,
       rolelevel_1,
       sharelevel_1,
       userid_1,
       departmentid_1,
       roleid_1,
       foralluser_1,
       crmid_1,
       1,
       subcompanyid_1,
       jobtitleid_1,
       joblevel_1,
       scopeid_1);
  end loop;
end;
/

CREATE OR REPLACE PROCEDURE CptAstShareInfo_Insert_dft(relateditemid_1 integer,
                                                       sharetype_2     int,
                                                       seclevel_3      smallint,
                                                       rolelevel_4     smallint,
                                                       sharelevel_5    smallint,
                                                       userid_6        integer,
                                                       departmentid_7  integer,
                                                       roleid_8        integer,
                                                       foralluser_9    smallint,
                                                       sharefrom_10    integer,
                                                       subcompanyid_11 integer,
                                                       seclevelmax_12  integer,
                                                       jobtitleid_13   integer,
                                                       joblevel_14     integer,
                                                       scopeid_15      varchar2,
                                                       flag            out integer,
                                                       msg             out varchar2,
                                                       thecursor       IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO CptCapitalShareInfo
    (relateditemid,
     sharetype,
     seclevel,
     rolelevel,
     sharelevel,
     userid,
     departmentid,
     roleid,
     foralluser,
     sharefrom,
     subcompanyid,
     isdefault,
     seclevelmax,
     jobtitleid,
     joblevel,
     scopeid)
  VALUES
    (relateditemid_1,
     sharetype_2,
     seclevel_3,
     rolelevel_4,
     sharelevel_5,
     userid_6,
     departmentid_7,
     roleid_8,
     foralluser_9,
     sharefrom_10,
     subcompanyid_11,
     1,
     seclevelmax_12,
     jobtitleid_13,
     joblevel_14,
     scopeid_15);
end;
/