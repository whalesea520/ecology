CREATE OR REPLACE PROCEDURE DocSecCategoryShare_Ins_G(secid_1          integer,
                                                      sharetype_2      integer,
                                                      seclevel_3       smallint,
                                                      rolelevel_4      smallint,
                                                      sharelevel_5     smallint,
                                                      userid_6         integer,
                                                      subcompanyid_7   integer,
                                                      departmentid_8   integer,
                                                      roleid_9         integer,
                                                      foralluser_10    smallint,
                                                      crmid_11         integer,
                                                      orgGroupId_12    integer,
                                                      downloadlevel_13 integer,
                                                      operategroup_14  smallint,
                                                      orgid_15         smallint,
                                                      seclevelmax_16   smallint,
                                                      includesub_17    smallint,
                                                      custype_18       smallint,
                                                      isolddate_19     smallint,
                                                      jobids_20        smallint,
                                                      joblevel_21      smallint,
                                                      jobdepartment_22 smallint,
                                                      jobsubcompany_23 smallint,
                                                      flag             out integer,
                                                      msg              out varchar2,
                                                      thecursor        IN OUT cursor_define.weavercursor) as
begin
  insert into DocSecCategoryShare
    (seccategoryid,
     sharetype,
     seclevel,
     rolelevel,
     sharelevel,
     userid,
     subcompanyid,
     departmentid,
     roleid,
     foralluser,
     crmid,
     orgGroupId,
     downloadlevel,
     operategroup,
     orgid,
     seclevelmax,
     includesub,
     custype,
     isolddate,
     jobids,
     joblevel,
     jobdepartment,
     jobsubcompany)
  values
    (secid_1,
     sharetype_2,
     seclevel_3,
     rolelevel_4,
     sharelevel_5,
     userid_6,
     subcompanyid_7,
     departmentid_8,
     roleid_9,
     foralluser_10,
     crmid_11,
     orgGroupId_12,
     downloadlevel_13,
     operategroup_14,
     orgid_15,
     seclevelmax_16,
     includesub_17,
     custype_18,
     isolddate_19,
     jobids_20,
     joblevel_21,
     jobdepartment_22,
     jobsubcompany_23);
end;
/