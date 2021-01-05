ALTER TABLE Prj_TemplateTask alter column taskmanager varchar(300)
go
DROP INDEX  IX_Prj_TaskProcess_hrmid on Prj_TaskProcess
go
ALTER TABLE Prj_TaskProcess alter column hrmid varchar(300)
go
create nonclustered index IX_Prj_TaskProcess_hrmid on Prj_TaskProcess(prjid,hrmid)
go

 ALTER procedure [Prj_TaskProcess_Insert] 
 (@prjid 	int, @taskid 	int, @wbscoding 	varchar(4000), @subject 	varchar(4000) , @version 	tinyint, 
 @begindate 	varchar(4000), @enddate 	varchar(4000), @workday decimal (10,1), @content 	text, 
 @fixedcost decimal (18,2), @parentid int, @parentids varchar(4000), @parenthrmids varchar(4000), @level_n tinyint, @hrmid varchar(300),
 @prefinish_1 varchar(4000), @realManDays decimal (6,1), @taskIndex int, @flag integer output, @msg varchar(4000) output  ) 
 AS declare @dsporder_9 int, @current_maxid int  select @current_maxid = max(dsporder) from Prj_TaskProcess 
 where prjid = @prjid and version = @version and parentid = @parentid and isdelete<>'1' 
 if @current_maxid is null set @current_maxid = 0 set @dsporder_9 = @current_maxid + 1  INSERT INTO Prj_TaskProcess 
 ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, 
 level_n, hrmid, islandmark, prefinish, dsporder, realManDays, taskIndex ) VALUES ( @prjid, @taskid , @wbscoding, @subject , @version ,
 @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'0',@prefinish_1,@dsporder_9,
 @realManDays,@taskIndex) Declare @id int, @maxid varchar(4000), @maxhrmid varchar(4000) select @id = max(id) 
 from Prj_TaskProcess set @maxid = convert(varchar(4000), @id) + ',' 
 set @maxhrmid = '|' + convert(varchar(4000), @id) + ',' + convert(varchar(4000), @hrmid) + '|' 
 update Prj_TaskProcess set parentids=parentids+@maxid, parenthrmids=parenthrmids+@maxhrmid  where id=@id  set @flag = @@identity set @msg = 'OK!' 
go

ALTER TABLE Prj_TaskModifyLog alter column hrmid varchar(300)
go


 ALTER procedure [Prj_TaskModifyLog_Insert] 
 ( @ProjID_1	   INT , @TaskID_1	   INT , @Subject_1	   varchar(4000), @HrmID_1	   varchar(300) ,
 @BeginDate_1  varchar(4000) , @EndDate_1	   varchar(4000) , @WorkDay_1	   DECIMAL  , @FixedCost_1  DECIMAL (18,2),
 @Finish_1	   TINYINT , @ParentID_1 INT, @Prefinish_1  varchar(4000)  , @IsLandMark_1 Char(1) , @ModifyDate_1 varchar(4000) , 
 @ModifyTime_1 varchar(4000) , @ModifyBy_1   INT , @Status_1	   TINYINT , @OperationType_1	TINYINT, @ClientIP_1	Varchar(20), 
 @realManDays decimal (6,1), @flag integer output, @msg varchar(4000) output  ) AS  INSERT INTO Prj_TaskModifyLog 
 ( ProjID	   , TaskID	   , Subject	   , HrmID	   , BeginDate  , EndDate	   , WorkDay	   , FixedCost  , Finish	   ,
 ParentID   , Prefinish  , IsLandMark , ModifyDate , ModifyTime , ModifyBy   , Status	   , OperationType	, ClientIP, realManDays ) 
 VALUES( @ProjID_1	   , @TaskID_1	   , @Subject_1	   , @HrmID_1	   , @BeginDate_1       , @EndDate_1	   , @WorkDay_1	   , @FixedCost_1       , 
 @Finish_1	   , @ParentID_1        , @Prefinish_1  , @IsLandMark_1 , @ModifyDate_1 , @ModifyTime_1 , @ModifyBy_1   , @Status_1	   ,
 @OperationType_1	, @ClientIP_1, @realManDays )  set @flag = 1 set @msg = 'OK!' 
go


 ALTER procedure [Prj_TaskProcess_Update] 
 (@id	int, @wbscoding varchar(4000), @subject 	varchar(4000) , @begindate 	varchar(4000), @enddate 	varchar(4000),
 @actualbegindate 	varchar(4000), @actualenddate 	varchar(4000), @workday decimal (10,1), @content 	text,  @fixedcost decimal (18,2),
 @hrmid varchar(300), @oldhrmid int, @finish tinyint, @taskconfirm char(1), @islandmark char(1), @prefinish_1 varchar(4000), @realManDays decimal (6,1),
 @flag integer output, @msg varchar(4000) output ) AS UPDATE Prj_TaskProcess SET wbscoding = @wbscoding, subject = @subject , begindate = @begindate, 
 enddate = @enddate 	, actualbegindate = @actualbegindate, actualenddate = @actualenddate 	, workday = @workday, content = @content, 
 fixedcost = @fixedcost, hrmid = @hrmid, finish = @finish , taskconfirm = @taskconfirm, islandmark = @islandmark, prefinish = @prefinish_1, 
 realManDays = @realManDays WHERE ( id	 = @id) if @hrmid<>@oldhrmid begin Declare @currenthrmid varchar(4000), @currentoldhrmid varchar(4000) 
 set @currenthrmid='|' + convert(varchar(4000), @id) + ',' + convert(varchar(4000), @hrmid) + '|' set @currentoldhrmid='|' + convert(varchar(4000), 
 @id) + ',' + convert(varchar(4000), @oldhrmid) + '|' UPDATE Prj_TaskProcess set parenthrmids=replace
 (parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%') end set @flag = 1 set @msg = 'OK!' 
 go

DROP INDEX  IX_Prj_TaskInfo_hrmid on Prj_TaskInfo
go
ALTER TABLE Prj_TaskInfo alter column hrmid varchar(300)
go
create nonclustered index IX_Prj_TaskInfo_hrmid on Prj_TaskInfo(prjid,hrmid)
go

ALTER procedure [Prj_Plan_SaveFromProcess]
(@prjid 	[int], @version	[int],@creater	[int],@createdate	varchar(4000),@createtime	varchar(4000),
@flag integer output, @msg varchar(4000) output  ) AS declare @taskid 	[int], @wbscoding 	varchar(4000), @subject 	varchar(4000),
@begindate 	varchar(4000), @enddate 	varchar(4000), @workday        [decimal] (10,1), @content 	varchar(4000), 
@fixedcost	[decimal](10,2), @parentid	[int], @parentids	varchar(4000), @parenthrmids	varchar(4000), @level_n		[tinyint], 
@hrmid		varchar(300),@taskindex int , @realManDays decimal(6,1),@actualBeginDate varchar(10),@actualEndDate varchar(10),@finish int,
@islandmark char(1) , @begintime 	varchar(20), @endtime 	varchar(20),@actualBegintime varchar(20),@actualEndtime varchar(20),
@all_cursor	cursor SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR 
select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex ,
realManDays,actualBeginDate,actualEndDate,finish,islandmark,begintime,endtime,actualbegintime,actualendtime from [Prj_TaskProcess] 
where prjid = @prjid OPEN @all_cursor FETCH NEXT FROM 
@all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,
@level_n,@hrmid,@taskindex ,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark,@begintime,@endtime,@actualbegintime,
@actualendtime WHILE @@FETCH_STATUS = 0 begin INSERT INTO [Prj_TaskInfo]
( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex ,realManDays,actualBeginDate,actualEndDate,finish,islandmark, isactived, version,creater,createdate,createtime,begintime,endtime,actualbegintime,actualendtime)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,@taskindex ,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark,'1',@version,@creater,@createdate,@createtime,@begintime,@endtime,@actualbegintime,@actualendtime) FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid,@taskindex ,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark,@begintime,@endtime,@actualbegintime,@actualendtime end CLOSE @all_cursor DEALLOCATE @all_cursor
go