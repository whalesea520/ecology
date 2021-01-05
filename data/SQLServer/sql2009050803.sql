alter table Prj_TaskInfo alter column fixedcost decimal(18,2)
GO

alter table Prj_TaskInfo alter column parenthrmids varchar(4000)
GO

alter table Prj_TaskInfo alter column parentids varchar(4000)
GO

alter table Prj_TaskInfo alter column content varchar(4000)
GO

alter table Prj_TaskInfo alter column enddate varchar(50)
GO

alter table Prj_TaskInfo alter column begindate varchar(50)
GO

alter table Prj_TaskInfo alter column subject varchar(500)
GO

alter table Prj_TaskInfo alter column wbscoding varchar(200)
GO

ALTER PROCEDURE Prj_TaskProcess_Insert 
	 (@prjid 	int,
	 @taskid 	int, 
	 @wbscoding 	varchar(20),
	 @subject 	varchar(80) , 
	 @version 	tinyint, 
	 @begindate 	varchar(10),
	 @enddate 	varchar(10), 
	 @workday decimal (10,1),
	 @content 	varchar(255),
	 @fixedcost decimal (18,2),
	 @parentid int, 
	 @parentids varchar (255), 
	 @parenthrmids varchar (255), 
	 @level_n tinyint,
	 @hrmid int,
	 @prefinish_1 varchar(4000),
	 @realManDays decimal (6,1), 
     	@taskIndex int,
	 @flag integer output, @msg varchar(80) output  ) 
	AS 
	declare @dsporder_9 int, @current_maxid int
	
	select @current_maxid = max(dsporder) from Prj_TaskProcess 
	where prjid = @prjid and version = @version and parentid = @parentid and isdelete<>'1' 
	if @current_maxid is null set @current_maxid = 0 
	set @dsporder_9 = @current_maxid + 1
	
	INSERT INTO Prj_TaskProcess 
	( prjid, 
	taskid , 
	wbscoding,
	subject , 
	version , 
	begindate, 
	enddate, 
	workday, 
	content, 
	fixedcost,
	parentid, 
	parentids, 
	parenthrmids,
	level_n, 
	hrmid,
	islandmark,
	prefinish,
	dsporder,
	realManDays,
    taskIndex
	)  
	VALUES 
	( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate,
	@workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'0',@prefinish_1,@dsporder_9, @realManDays,@taskIndex) 
	Declare @id int, @maxid varchar(10), @maxhrmid varchar(255)
	select @id = max(id) from Prj_TaskProcess 
	set @maxid = convert(varchar(10), @id) + ','
	set @maxhrmid = '|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
	update Prj_TaskProcess set parentids=parentids+@maxid, parenthrmids=parenthrmids+@maxhrmid  where id=@id
	
	set @flag = @@identity 
	set @msg = 'OK!'
GO


Alter PROCEDURE Prj_Plan_Approve (@prjid 	[int], @flag integer output, @msg varchar(80) output  ) AS declare @taskid 	[int], @wbscoding 	[varchar](200), @subject 	[varchar](500), @begindate 	[varchar](50), @enddate 	[varchar](50), @workday        [decimal] (10,1), @content 	[varchar](4000), @fixedcost	[decimal](18,2), @parentid	[int], @parentids	[varchar](4000), @parenthrmids	[varchar](4000), @level_n		[tinyint], @hrmid		[int], @all_cursor	cursor SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid from [Prj_TaskProcess] where prjid = @prjid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid WHILE @@FETCH_STATUS = 0 begin INSERT INTO [Prj_TaskInfo] (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'2','1') FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid end CLOSE @all_cursor DEALLOCATE @all_cursor 

GO

