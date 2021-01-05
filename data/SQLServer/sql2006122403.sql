CREATE TABLE VotingViewer (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	votingid int NULL,
	sharetype int NULL,
	resourceid int NULL,
	subcompanyid int NULL,
	departmentid int NULL,
	roleid int NULL,
	seclevel int NULL,
	rolelevel int NULL,
	foralluser int NULL
)
GO

CREATE TABLE VotingViewerDetail (
	votingid int NULL,
	resourceid int NULL
)
GO

CREATE PROCEDURE VotingViewerDetail_Update
(@votingid    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	declare @shareid int,
	        @sharetype   int,
	        @resourceid  int,
	        @subcompanyid    int,
	        @departmentid    int,
	        @roleid      int,
	        @seclevel    int,
	        @rolelevel   int,
	        @foralluser  int,
	        @all_cursor cursor,
	        @detail_cursor cursor,
	        @userid int,
	        @count  int
	delete from votingviewerdetail where votingid=@votingid
	
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    select id,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,rolelevel,foralluser from votingviewer where votingid=@votingid
    OPEN @all_cursor 
    FETCH NEXT FROM @all_cursor INTO @shareid ,	@sharetype ,@resourceid ,@subcompanyid,@departmentid,@roleid,@seclevel,@rolelevel,@foralluser
    WHILE @@FETCH_STATUS = 0 
    begin 
        if @sharetype=1 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select id from HrmResource where id = @resourceid and seclevel >= @seclevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingviewerdetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingviewerdetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
    	
        if @sharetype=2 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select id from HrmResource where subcompanyid1 = @subcompanyid and seclevel >= @seclevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingviewerdetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingviewerdetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
        
        if @sharetype=3 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select id from HrmResource where departmentid = @departmentid and seclevel >= @seclevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingviewerdetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingviewerdetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
    	
    	if @sharetype=4 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select resourceid from HrmRoleMembers where roleid = @roleid and rolelevel >= @rolelevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingviewerdetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingviewerdetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
    	
    	if @sharetype=5 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select id from HrmResource where seclevel >= @seclevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingviewerdetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingviewerdetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
        FETCH NEXT FROM @all_cursor INTO @shareid ,	@sharetype ,@resourceid ,@subcompanyid,@departmentid,@roleid,@seclevel,@rolelevel,@foralluser
    end 
    CLOSE @all_cursor 
    DEALLOCATE @all_cursor  

GO
