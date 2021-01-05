ALTER procedure [Prj_TaskProcess_Update] 
 (@id	int, @wbscoding varchar(4000), @subject 	varchar(4000) , @begindate 	varchar(4000), @enddate 	varchar(4000),
 @actualbegindate 	varchar(4000), @actualenddate 	varchar(4000), @workday decimal (10,1), @content 	text,  @fixedcost decimal (18,2),
 @hrmid varchar(300), @oldhrmid varchar(300), @finish tinyint, @taskconfirm char(1), @islandmark char(1), @prefinish_1 varchar(4000), @realManDays decimal (6,1),
 @flag integer output, @msg varchar(4000) output ) AS UPDATE Prj_TaskProcess SET wbscoding = @wbscoding, subject = @subject , begindate = @begindate, 
 enddate = @enddate 	, actualbegindate = @actualbegindate, actualenddate = @actualenddate 	, workday = @workday, content = @content, 
 fixedcost = @fixedcost, hrmid = @hrmid, finish = @finish , taskconfirm = @taskconfirm, islandmark = @islandmark, prefinish = @prefinish_1, 
 realManDays = @realManDays WHERE ( id	 = @id) if @hrmid<>@oldhrmid begin Declare @currenthrmid varchar(4000), @currentoldhrmid varchar(4000) 
 set @currenthrmid='|' + convert(varchar(4000), @id) + ',' + convert(varchar(4000), @hrmid) + '|' set @currentoldhrmid='|' + convert(varchar(4000), 
 @id) + ',' + convert(varchar(4000), @oldhrmid) + '|' UPDATE Prj_TaskProcess set parenthrmids=replace
 (parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%') end set @flag = 1 set @msg = 'OK!' 
 go
