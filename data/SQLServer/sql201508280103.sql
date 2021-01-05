ALTER procedure Prj_ShareInfo_Update 
  (
    @typeid_1 int,
    @prjid_1 int,
    @flag integer output,
    @msg varchar(4000) output
  )
  as declare
  @theid_1 int,
  @all_cursor cursor,
  @relateditemid_1 int,
  @sharetype_1 tinyint,
  @seclevel_1 tinyint,
  @rolelevel_1 tinyint,
  @sharelevel_1 tinyint,
  @userid_1 int,
  @departmentid_1 int,
  @roleid_1 int,
  @foralluser_1 tinyint,
  @crmid_1 int ,
  @subcompanyid_1 int 
  SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
select
  id
from
  Prj_T_ShareInfo
WHERE
  relateditemid = @typeid_1 OPEN @all_cursor FETCH NEXT
FROM
  @all_cursor INTO @theid_1 WHILE @@FETCH_STATUS = 0 begin
select
  @sharetype_1 =sharetype,
  @seclevel_1 =seclevel,
  @rolelevel_1= rolelevel,
  @sharelevel_1 =sharelevel,
  @userid_1 =userid,
  @departmentid_1 =departmentid,
  @roleid_1 =roleid,
  @foralluser_1 =foralluser,
  @crmid_1 =crmid,
  @subcompanyid_1 =subcompanyid
from
  Prj_T_ShareInfo
WHERE
  id = @theid_1
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
      @prjid_1,
      @sharetype_1,
      @seclevel_1,
      @rolelevel_1,
      @sharelevel_1,
      @userid_1,
      @departmentid_1,
      @roleid_1,
      @foralluser_1,
      @crmid_1,
      1,
      @subcompanyid_1
  )
  FETCH NEXT
FROM
  @all_cursor INTO @theid_1 end CLOSE @all_cursor DEALLOCATE @all_cursor 

GO
