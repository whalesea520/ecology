alter  TRIGGER [Tri_U_bill_WorkPlanByMeet1] ON Meeting WITH ENCRYPTION
FOR UPDATE
AS
Declare 
 	@name varchar(80),
 	@isapproved	int,
 	@begindate	char(10),
 	@begintime  char(8),
 	@enddate	char(10),
 	@endtime    char(8),
    @createdate	char(10),
 	@createtime  char(8),
 	@resourceid	int,
 	@meetingid	int,
 	@caller     int,
 	@contacter int,
    @allresource varchar(200),
    @managerstr varchar(200),
    @managerid int,
	@tmpcount int ,
    @userid int ,
    @usertype int ,
    @sharelevel int ,
    @workplanid int ,
    @workplancount int ,
    @m_deptId int,
    @m_subcoId int,
    @all_cursor cursor,
	@detail_cursor cursor
if update(isapproved)
begin
    Declare @temptablevalueWork  table(workid int,userid int,usertype int,sharelevel int)

	select distinct @meetingid=id from deleted 
	
	
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select id,name,caller,contacter,begindate,begintime,enddate,endtime,createdate,createtime from inserted 
	where isapproved=2 
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @meetingid,@name,@caller,@contacter,@begindate,@begintime,@enddate,@endtime,@createdate,@createtime
	WHILE @@FETCH_STATUS = 0
	begin
        if @enddate=''  set @enddate=@begindate

	/* get the department and subcompany info */
	/* added by lupeng 2004-07-22*/
	SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @caller
	/* end */

        INSERT INTO WorkPlan  
        (type_n ,
        name  ,
        resourceid ,
        begindate ,
        begintime ,
        enddate ,
        endtime  ,
        description ,
        requestid  ,
        projectid ,
        crmid  ,
        docid  ,
        meetingid ,
        status  ,
        isremind  ,
        waketime  ,	
        createrid  ,
        createdate  ,
        createtime ,
        deleted,
	urgentLevel,
	deptId,
	subcompanyId)          
         VALUES 
        ('1' ,
        @name  ,
        @allresource ,
        @begindate ,
        @begintime ,
        @enddate ,
        @endtime  ,
        '' ,
        '0'  ,
        '0' ,
        '0'  ,
        '0'  ,
        @meetingid ,
        '0'  ,
        '1'  ,
        '0'  ,	
        @caller  ,
        @createdate  ,
        @createtime  ,
        '0',
	'1',
	@m_deptId,
	@m_subcoId)
        select top 1 @workplanid = id from WorkPlan order by id desc

        set @allresource = convert(varchar(5),@caller)
        if PATINDEX('%,' + convert(varchar(5),@contacter) + ',%' , ',' + @allresource + ',') = 0
        set @allresource = @allresource + ',' + convert(varchar(5),@contacter)

        insert into @temptablevalueWork values(@workplanid,@caller,1,2)
        set @managerstr =''
        select @managerstr = managerstr from HrmResource where id = @caller
        set @managerstr = '%,' + @managerstr + '%'
        declare allmanagerid_cursor cursor for
        select id from HrmResource where (','+CONVERT(varchar(5), id)+',') like @managerstr
        open allmanagerid_cursor 
        fetch next from allmanagerid_cursor into @managerid 
        while @@fetch_status=0
        begin 
            select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @managerid
            if @workplancount = 0
            insert into @temptablevalueWork values(@workplanid,@managerid,1,1)
            fetch next from allmanagerid_cursor into @managerid 
        end
        close allmanagerid_cursor 
        deallocate allmanagerid_cursor



        select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @contacter
        if @workplancount = 0
        begin
            insert into @temptablevalueWork values(@workplanid,@contacter,1,1)
            set @managerstr =''
            select @managerstr = managerstr from HrmResource where id = @contacter
            set @managerstr = '%,' + @managerstr + '%'

            declare allmanagerid_cursor cursor for
            select id from HrmResource where (','+CONVERT(varchar(5), id)+',') like @managerstr
            open allmanagerid_cursor 
            fetch next from allmanagerid_cursor into @managerid 
            while @@fetch_status=0
            begin 
                select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @managerid
                if @workplancount = 0
                insert into @temptablevalueWork values(@workplanid,@managerid,1,1)
                fetch next from allmanagerid_cursor into @managerid 
            end
            close allmanagerid_cursor 
            deallocate allmanagerid_cursor
        end


    	SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR 
		select memberid from Meeting_Member2 where meetingid=@meetingid and membertype=1
		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @resourceid 
		WHILE @@FETCH_STATUS = 0
		begin
            if PATINDEX('%,' + convert(varchar(5),@resourceid) + ',%' , ',' + @allresource + ',') = 0
    		set @allresource = @allresource + ',' + convert(varchar(5),@resourceid)  

            select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @resourceid
            if @workplancount = 0
            begin
                insert into @temptablevalueWork values(@workplanid,@resourceid,1,1)
                set @managerstr =''
                select @managerstr = managerstr from HrmResource where id = @resourceid
                set @managerstr = '%,' + @managerstr + '%'

                declare allmanagerid_cursor cursor for
                select id from HrmResource where (','+CONVERT(varchar(5), id)+',') like @managerstr
                open allmanagerid_cursor 
                fetch next from allmanagerid_cursor into @managerid 
                while @@fetch_status=0
                begin 
                    select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @managerid
                    if @workplancount = 0
                    insert into @temptablevalueWork values(@workplanid,@managerid,1,1)
                    fetch next from allmanagerid_cursor into @managerid 
                end
                close allmanagerid_cursor 
                deallocate allmanagerid_cursor
            end


    		FETCH NEXT FROM @detail_cursor INTO @resourceid 
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor 

        update WorkPlan set resourceid=@allresource where id = @workplanid

        declare allmeetshare_cursor cursor for
        select * from @temptablevalueWork
        open allmeetshare_cursor 
        fetch next from allmeetshare_cursor into @meetingid , @userid , @usertype , @sharelevel
        while @@fetch_status=0
        begin 
            insert into WorkPlanShareDetail (workid, userid, usertype, sharelevel)  values(@meetingid , @userid , @usertype , @sharelevel)
            fetch next from allmeetshare_cursor into @meetingid , @userid , @usertype , @sharelevel
        end
        close allmeetshare_cursor 
        deallocate allmeetshare_cursor

		FETCH NEXT FROM @all_cursor INTO @meetingid,@name,@caller,@contacter,@begindate,@begintime,@enddate,@endtime,@createdate,@createtime
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor 
end
go