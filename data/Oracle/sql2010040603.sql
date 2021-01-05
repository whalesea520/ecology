CREATE OR REPLACE PROCEDURE DocShare_IFromDocSecCategoryDL(
    docid_1        integer,
    sharetype_2    integer,
    seclevel_3     smallint,
    rolelevel_4    smallint,
    sharelevel_5   smallint,
    userid_6       integer,
    subcompanyid_7 integer,
    departmentid_8 integer,
    roleid_9       integer,
    foralluser_10  smallint,
    crmid_11       integer,
    orgGroupId_12	integer,
    downloadlevel_12 integer,
    flag           out integer,
    msg            out varchar2,
    thecursor      IN OUT cursor_define.weavercursor) 
as
begin
  insert into DocShare
    (docid,
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
     downloadlevel)
  values
    (docid_1,
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
     downloadlevel_12);
  open thecursor for
    select max(id) from DocShare;
end;
/
