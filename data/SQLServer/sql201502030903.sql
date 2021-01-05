alter procedure [Prj_Plan_SaveFromProcess] 
(@prjid 	[int], @version	[int],@creater	[int],@createdate	varchar(4000),@createtime	varchar(4000), @flag integer output, @msg varchar(4000) output  ) 
AS declare 
@taskid 	[int], @wbscoding 	varchar(4000), @subject 	varchar(4000), @begindate 	varchar(4000), @enddate 	varchar(4000), @workday        [decimal] (10,1), @content 	varchar(4000), @fixedcost	[decimal](10,2), @parentid	[int], @parentids	varchar(4000), @parenthrmids	varchar(4000), @level_n		[tinyint], @hrmid		[int],@taskindex int
, @realManDays decimal(6,1),@actualBeginDate varchar(10),@actualEndDate varchar(10),@finish int, @islandmark char(1)
,@all_cursor	cursor SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex
,realManDays,actualBeginDate,actualEndDate,finish,islandmark 
from [Prj_TaskProcess] where prjid = @prjid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid,@taskindex
,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark WHILE @@FETCH_STATUS = 0 begin INSERT INTO [Prj_TaskInfo] ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex
,realManDays,actualBeginDate,actualEndDate,finish,islandmark, isactived, version,creater,createdate,createtime)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,@taskindex
,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark,'1',@version,@creater,@createdate,@createtime) FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid,@taskindex
,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark end CLOSE @all_cursor DEALLOCATE @all_cursor
GO


CREATE FUNCTION getPrjTaskInfoBeginDate
(@prjid int,@version varchar(100))
RETURNS char(10) AS
BEGIN
Return (SELECT MIN(begindate)  FROM Prj_TaskInfo WHERE prjid=@prjid and version=@version)
END
go
CREATE FUNCTION getPrjTaskInfoEndDate
(@prjid int,@version varchar(100))
RETURNS char(10) AS
BEGIN
Return (SELECT MAX(enddate)  FROM Prj_TaskInfo WHERE prjid=@prjid and version=@version)
END
go
CREATE FUNCTION getPrjTaskInfoFinish
(@prjid int,@version varchar(100))
RETURNS int AS
BEGIN
DECLARE @sumWorkday decimal(9)
DECLARE @finish int
set @finish=0
SELECT @sumWorkday=SUM(workday) FROM Prj_TaskInfo WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1' and version=@version) ;
IF @sumWorkday<>0 
	SELECT @finish= (sum(finish*workday)/sum(workday))  FROM Prj_TaskInfo WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1' and version=@version) 
Return @finish
END
go
alter procedure [Prj_Plan_Approve] 
(@prjid 	[int],@creater	[int],@createdate	varchar(4000),@createtime	varchar(4000), @flag integer output, @msg varchar(4000) output  ) 
AS declare @taskid 	[int], @wbscoding 	varchar(4000), @subject 	varchar(4000), @begindate 	varchar(4000), @enddate 	varchar(4000), @workday        [decimal] (10,1), @content 	varchar(4000), @fixedcost	[decimal](18,2), @parentid	[int], @parentids	varchar(4000), @parenthrmids	varchar(4000), @level_n		[tinyint]
, @hrmid		[int],@taskindex int, @realManDays decimal(6,1),@actualBeginDate varchar(10),@actualEndDate varchar(10),@finish int,@islandmark char(1), @all_cursor	cursor SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n
, hrmid,taskindex,realManDays,actualBeginDate,actualEndDate,finish,islandmark from [Prj_TaskProcess] where prjid = @prjid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n
,@hrmid,@taskindex,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark WHILE @@FETCH_STATUS = 0 begin INSERT INTO [Prj_TaskInfo] (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n
, hrmid,taskindex,realManDays,actualBeginDate,actualEndDate,finish,islandmark,isactived, version,creater,createdate,createtime)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n
, @hrmid,@taskindex,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark,'2','1',@creater,@createdate,@createtime) FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n
,@hrmid,@taskindex,@realManDays,@actualBeginDate,@actualEndDate,@finish,@islandmark end CLOSE @all_cursor DEALLOCATE @all_cursor
GO