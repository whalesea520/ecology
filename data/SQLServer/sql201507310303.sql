ALTER procedure [Prj_TaskProcess_Update] 
 (@id	int, @wbscoding varchar(4000), @subject 	varchar(4000) , @begindate 	varchar(4000),
 @enddate 	varchar(4000), @actualbegindate 	varchar(4000), @actualenddate 	varchar(4000), 
 @workday decimal (15,2), @content 	text,  @fixedcost decimal (18,2), @hrmid varchar(300), @oldhrmid varchar(300),
 @finish tinyint, @taskconfirm char(1), @islandmark char(1), @prefinish_1 varchar(4000), @realManDays decimal (15,2), 
 @flag integer output, @msg varchar(4000) output ) AS UPDATE Prj_TaskProcess SET wbscoding = @wbscoding, subject = @subject , 
 begindate = @begindate, enddate = @enddate 	, actualbegindate = @actualbegindate, actualenddate = @actualenddate 	, 
 workday = @workday, content = @content, fixedcost = @fixedcost, hrmid = @hrmid, finish = @finish , taskconfirm = @taskconfirm, 
 islandmark = @islandmark, prefinish = @prefinish_1, realManDays = @realManDays WHERE ( id	 = @id) 
 if @hrmid<>@oldhrmid begin Declare @currenthrmid varchar(4000),
 @currentoldhrmid varchar(4000) 
 set @currenthrmid='|' + convert(varchar(4000), @id) + ',' + convert(varchar(4000), @hrmid) + '|' 
 set @currentoldhrmid='|' + convert(varchar(4000), @id) + ',' + convert(varchar(4000), @oldhrmid) + '|' 
 UPDATE Prj_TaskProcess set parenthrmids=replace 
 (parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%') end set @flag = 1 set @msg = 'OK!'
 go

  ALTER procedure [Prj_TaskProcess_Insert] 
  (@prjid 	int, @taskid 	int, @wbscoding 	varchar(4000), @subject 	varchar(4000) , 
  @version 	tinyint, @begindate 	varchar(4000), @enddate 	varchar(4000), @workday decimal (15,2), 
  @content 	text, @fixedcost decimal (18,2), @parentid int, @parentids varchar(4000), 
  @parenthrmids varchar(4000), @level_n tinyint, @hrmid varchar(300), @prefinish_1 varchar(4000), 
  @realManDays decimal (15,2), @taskIndex int, @flag integer output, @msg varchar(4000) output  ) 
  AS declare @dsporder_9 int, @current_maxid int  select @current_maxid = max(dsporder) 
  from Prj_TaskProcess where prjid = @prjid and version = @version and parentid = @parentid and isdelete<>'1' 
  if @current_maxid is null set @current_maxid = 0 set @dsporder_9 = @current_maxid + 1  
  INSERT INTO Prj_TaskProcess 
  ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, 
  level_n, hrmid, islandmark, prefinish, dsporder, realManDays, taskIndex ) VALUES 
  ( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, 
  @parenthrmids, @level_n, @hrmid,'0',@prefinish_1,@dsporder_9, @realManDays,@taskIndex) Declare @id int, @maxid varchar(4000), 
  @maxhrmid varchar(4000) select @id = max(id) from Prj_TaskProcess set @maxid = convert(varchar(4000), @id) + ',' 
  set @maxhrmid = '|' + convert(varchar(4000), @id) + ',' + convert(varchar(4000), @hrmid) + '|' 
  update Prj_TaskProcess set parentids=parentids+@maxid, parenthrmids=parenthrmids+@maxhrmid  where id=@id  set @flag = @@identity set @msg = 'OK!'
  go
 ALTER procedure [Prj_TaskInfo_Sum] 
 (@prjid [int], @version [int], @flag	[int]	output, @msg	varchar(4000)	output)
 AS 
 SELECT sum(workday) as workday, min(begindate) as begindate, max(enddate) as enddate ,min(actualBeginDate)  actualBeginDate, max(actualEndDate)   actualEndDate
 FROM [Prj_TaskInfo] 
 WHERE ( prjid = @prjid and parentid = '0' and version = @version  and isdelete<>'1') set @flag = 1 set @msg = 'OK!' 
 go

 ALTER TABLE Prj_TaskInfo  alter COLUMN realmandays DECIMAL(15,2)
GO
ALTER TABLE Prj_TaskInfo  alter COLUMN workday DECIMAL(15,2)
GO


ALTER procedure [Prj_Plan_SaveFromProcess]
(@prjid 	[int], @version	[int],@creater	[int],@createdate	varchar(4000),@createtime	varchar(4000),
@flag integer output, @msg varchar(4000) output  ) AS declare @taskid 	[int], @wbscoding 	varchar(4000), @subject 	varchar(4000),
@begindate 	varchar(4000), @enddate 	varchar(4000), @workday        [decimal] (15,2), @content 	varchar(4000), 
@fixedcost	[decimal](10,2), @parentid	[int], @parentids	varchar(4000), @parenthrmids	varchar(4000), @level_n		[tinyint], 
@hrmid		varchar(300),@taskindex int , @realManDays decimal(15,2),@actualBeginDate varchar(10),@actualEndDate varchar(10),@finish int,
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