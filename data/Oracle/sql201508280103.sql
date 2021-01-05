CREATE OR REPLACE PROCEDURE Prj_ShareInfo_Update 
  (
    typeid_1 integer,
    customerid_1 integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor 
  )
  as theid_1 integer; relateditemid_1 integer; sharetype_1 smallint ; seclevel_1 smallint ; rolelevel_1 smallint ; sharelevel_1 smallint ; userid_1 integer ; departmentid_1 integer ; roleid_1 integer ; foralluser_1 smallint ; crmid_1 integer;subcompanyid_1 integer; begin for all_cursor IN 
  (
    select
      id
    from
      Prj_T_ShareInfo
    WHERE
      relateditemid = typeid_1
  )
  loop theid_1 := all_cursor.id;
select
  sharetype,
  seclevel,
  rolelevel,
  sharelevel,
  userid,
  departmentid,
  roleid,
  foralluser,
  crmid,
  subcompanyid
  INTO sharetype_1,
  seclevel_1,
  rolelevel_1,
  sharelevel_1,
  userid_1,
  departmentid_1,
  roleid_1,
  foralluser_1,
  crmid_1,
  subcompanyid_1
from
  Prj_T_ShareInfo
WHERE
  id = theid_1;
insert INTO
  Prj_ShareInfo 
  (
    relateditemid,
    sharetype,
    seclevel,
    rolelevel ,sharelevel,
    userid,
    departmentid,
    roleid,
    foralluser ,crmid,
    isdefault,
    subcompanyid
  )
  values
  (
      customerid_1,
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
      subcompanyid_1
  )
  ; end loop; end; 

/