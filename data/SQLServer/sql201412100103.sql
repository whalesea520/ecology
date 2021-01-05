alter table prj_taskinfo add taskIndex int
go

drop procedure Prj_Plan_SaveFromProcess
GO
CREATE PROCEDURE Prj_Plan_SaveFromProcess 
(@prjid 	[int], @version	[int],@creater	[int],@createdate	varchar(50),@createtime	varchar(50), @flag integer output, @msg varchar(80) output  ) 
AS declare @taskid 	[int], @wbscoding 	[varchar](20), @subject 	[varchar](50), @begindate 	[varchar](10), @enddate 	[varchar](10), @workday        [decimal] (10,1), @content 	[varchar](255), @fixedcost	[decimal](10,2), @parentid	[int], @parentids	[varchar](255), @parenthrmids	[varchar](255), @level_n		[tinyint], @hrmid		[int],@taskindex int, @all_cursor	cursor SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex from [Prj_TaskProcess] where prjid = @prjid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid,@taskindex WHILE @@FETCH_STATUS = 0 begin INSERT INTO [Prj_TaskInfo] ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex, isactived, version,creater,createdate,createtime)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,@taskindex,'1',@version,@creater,@createdate,@createtime) FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid,@taskindex end CLOSE @all_cursor DEALLOCATE @all_cursor
go