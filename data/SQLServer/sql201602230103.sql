ALTER TABLE Prj_T_ShareInfo ADD jobtitleid INT DEFAULT 0
go
ALTER TABLE Prj_T_ShareInfo ADD joblevel INT DEFAULT 0
go
ALTER TABLE Prj_T_ShareInfo ADD scopeid varchar(100) DEFAULT '0'
go
ALTER TABLE Prj_ShareInfo ADD jobtitleid INT DEFAULT 0
go
ALTER TABLE Prj_ShareInfo ADD joblevel INT DEFAULT 0
go
ALTER TABLE Prj_ShareInfo ADD scopeid varchar(100) DEFAULT '0'
go
ALTER TABLE prj_typecreatelist ADD jobtitleid INT DEFAULT 0
go
ALTER TABLE prj_typecreatelist ADD joblevel INT DEFAULT 0
go
ALTER TABLE prj_typecreatelist ADD scopeid varchar(100) DEFAULT '0'
go
ALTER TABLE Prj_TaskShareInfo ADD jobtitleid INT DEFAULT 0
go
ALTER TABLE Prj_TaskShareInfo ADD joblevel INT DEFAULT 0
go
ALTER TABLE Prj_TaskShareInfo ADD scopeid varchar(100) DEFAULT '0'
go
ALTER TABLE CptAssortmentShare ADD seclevelMax INT DEFAULT 100
GO
ALTER TABLE CptAssortmentShare ADD jobtitleid INT DEFAULT 0
go
ALTER TABLE CptAssortmentShare ADD joblevel INT DEFAULT 0
go
ALTER TABLE CptAssortmentShare ADD scopeid varchar(100) DEFAULT '0'
go
ALTER TABLE CptCapitalShareInfo ADD seclevelMax INT DEFAULT 100
GO
ALTER TABLE CptCapitalShareInfo ADD jobtitleid INT DEFAULT 0
go
ALTER TABLE CptCapitalShareInfo ADD joblevel INT DEFAULT 0
go
ALTER TABLE CptCapitalShareInfo ADD scopeid varchar(100) DEFAULT '0'
go
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authPrjD511',class_name='weaver.hrm.authority.manager.HrmPrjCptShifter' where code_name = 'D511'
go
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authPrjC511',class_name='weaver.hrm.authority.manager.HrmPrjCptShifter' where code_name = 'C511'
go

ALTER procedure [dbo].[Prj_ShareInfo_Update] 
 ( @typeid_1 int, @prjid_1 int, @flag integer output, @msg varchar(4000) output ) as 
 declare 
 @theid_1 int, @all_cursor cursor, @relateditemid_1 int, @sharetype_1 tinyint, @seclevel_1 tinyint,
  @rolelevel_1 tinyint, @sharelevel_1 tinyint, @userid_1 int, @departmentid_1 int,
   @roleid_1 int, @foralluser_1 tinyint, @crmid_1 int , @subcompanyid_1 int ,@jobtitleid int,@joblevel int,@scopeid varchar(100)
   SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR 
   select id from Prj_T_ShareInfo WHERE relateditemid = @typeid_1 
   OPEN @all_cursor 
   FETCH NEXT FROM @all_cursor 
   INTO @theid_1 
   WHILE @@FETCH_STATUS = 0 
   begin 
   select @sharetype_1 =sharetype, @seclevel_1 =seclevel, @rolelevel_1= rolelevel, @sharelevel_1 =sharelevel, 
   @userid_1 =userid, @departmentid_1 =departmentid, @roleid_1 =roleid, @foralluser_1 =foralluser,
   @crmid_1 =crmid, @subcompanyid_1 =subcompanyid,@jobtitleid=jobtitleid,@joblevel = joblevel,@scopeid=scopeid 
   from Prj_T_ShareInfo WHERE id = @theid_1 
   insert INTO Prj_ShareInfo 
   ( relateditemid, sharetype, seclevel, rolelevel ,sharelevel, userid, departmentid, roleid, foralluser ,crmid,
   isdefault, subcompanyid,jobtitleid,joblevel,scopeid ) values
   ( @prjid_1, @sharetype_1, @seclevel_1, @rolelevel_1, @sharelevel_1, @userid_1, @departmentid_1, @roleid_1,
   @foralluser_1, @crmid_1, 1, @subcompanyid_1,@jobtitleid,@joblevel,@scopeid ) 
   FETCH NEXT FROM @all_cursor INTO @theid_1 end CLOSE @all_cursor DEALLOCATE @all_cursor 

   go


ALTER procedure [dbo].[CptAstShareInfo_Insert_dft] (
 @relateditemid_1 [int], @sharetype_2 [tinyint], @seclevel_3 [tinyint], @rolelevel_4 [tinyint],
  @sharelevel_5 [tinyint], @userid_6 [int], @departmentid_7 [int], @roleid_8 [int], 
  @foralluser_9 [tinyint], @sharefrom_10 int ,
  @subcompanyid_11 int ,@seclevelmax_12 int ,@jobtitleid_13 int,@joblevel_14 int,@scopeid_15 varchar(100), 
  @flag integer output, @msg varchar(4000) output) AS 
  INSERT INTO [CptCapitalShareInfo] 
  ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], 
  [departmentid], [roleid], [foralluser], sharefrom,[subcompanyid],isdefault,seclevelmax,jobtitleid,joblevel,scopeid)  
  VALUES 
  ( @relateditemid_1, @sharetype_2, @seclevel_3, @rolelevel_4,
   @sharelevel_5, @userid_6, @departmentid_7, @roleid_8, @foralluser_9,
   @sharefrom_10,@subcompanyid_11,1,@seclevelmax_12,@jobtitleid_13,@joblevel_14,@scopeid_15)
   go