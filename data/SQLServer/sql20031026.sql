/* 朝华测试错误 刘煜修改部分 */

alter table workflow_requestbase alter column requestname  varchar(200)
GO


update workflow_groupdetail set objid=4 where groupid = 1
GO

insert into workflow_groupdetail (groupid,type,objid,level_n) values (2,5,4,0)
GO


delete workflow_nodelink where nodeid not in ( select id from workflow_nodebase ) or  destnodeid not in 
( select id from workflow_nodebase )
GO



alter PROCEDURE bill_monthinfodetail_Insert 
	@infoid		int,
	@type		int,
	@targetname	varchar(250),
	@targetresult	text,
	@forecastdate	char(10),
	@scale		decimal(10,3),
	@point		varchar(5),
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into bill_monthinfodetail (infoid,type,targetname,targetresult,forecastdate,scale,point)
	values (@infoid,@type,@targetname,@targetresult,@forecastdate,@scale,@point)

GO


update FileBackupIndex set lastbackupimagefileid = 0 , lastbackupmailfileid = 0 
GO


/* 朝华测试错误 杨国生修改部分 */

CREATE INDEX WorkPlan_type_n ON WorkPlan (type_n) 
GO
CREATE INDEX WorkPlan_name ON WorkPlan (name) 
GO
CREATE INDEX WorkPlan_resourceid ON WorkPlan (resourceid) 
GO
CREATE INDEX WorkPlan_status ON WorkPlan (status) 
GO
CREATE INDEX WorkPlan_begindate ON WorkPlan (begindate) 
GO
CREATE INDEX WorkPlan_enddate ON WorkPlan (enddate) 
GO

delete from HomePageDesign
GO
delete from PersonalHomePageDesign
GO
insert into HomePageDesign (name,iframe,height,url) values ('6057','CurrentWorkIframe','200','/system/homepage/HomePageWork.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('2118','WorkFlowIframe','200','/system/homepage/HomePageWorkFlow.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('316','NewsIframe','200','/system/homepage/HomePageNews.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('6058','UnderlingWorkIframe','30','/system/homepage/HomePageUnderlingWork.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('2102','MeetingIframe','200','/system/homepage/HomePageMeeting.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('6059','CustomerIframe','200','/system/homepage/HomePageCustomer.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('1211','ProjectIframe','200','/system/homepage/HomePageProject.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('6060','UnderlingCustomerIframe','30','/system/homepage/HomePageUnderlingCustomer.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('1213','MailIframe','30','/system/homepage/HomePageMail.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('6061','CustomerContactframe','200','/system/homepage/HomePageCustomerContact.jsp')
GO

/*当会议审批通过时加入到相关人员的工作计划中并加入相应的权限*/
CREATE TRIGGER [Tri_U_bill_WorkPlanByMeet1] ON Meeting WITH ENCRYPTION
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
    @allresource varchar(200), /*工作计划中的接受人*/
    @managerstr varchar(200),
    @managerid int,
	@tmpcount int ,
    @userid int ,
    @usertype int ,
    @sharelevel int ,
    @workplanid int ,
    @workplancount int ,
    @all_cursor cursor,
	@detail_cursor cursor
if update(isapproved)
begin
    /* 定义临时表变量 */
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
        /*插入工作计划表begin*/
        INSERT INTO WorkPlan  
        (type_n ,
        name  ,
        resourceid ,
        begindate ,
        begintime ,
        enddate ,
        endtime  ,
        color ,
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
        deleted)          
         VALUES 
        ('1' ,
        @name  ,
        @allresource ,
        @begindate ,
        @begintime ,
        @enddate ,
        @endtime  ,
        '50C1CB' ,
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
        '0' )
        select top 1 @workplanid = id from WorkPlan order by id desc
        /*插入工作计划表end*/

        set @allresource = convert(varchar(5),@caller)
        if PATINDEX('%,' + convert(varchar(5),@contacter) + ',%' , ',' + @allresource + ',') = 0
        set @allresource = @allresource + ',' + convert(varchar(5),@contacter)

        /*召集人及其经理线权限--begin*/
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

        /*召集人及其经理线权限--end*/


        /*联系人及其经理线权限--begin*/
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

        /*联系人及其经理线权限--end*/

    	SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR 
		select memberid from Meeting_Member2 where meetingid=@meetingid and membertype=1
		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @resourceid 
		WHILE @@FETCH_STATUS = 0
		begin
            if PATINDEX('%,' + convert(varchar(5),@resourceid) + ',%' , ',' + @allresource + ',') = 0
    		set @allresource = @allresource + ',' + convert(varchar(5),@resourceid)  

            /*参会人及其经理线权限--begin*/
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

            /*参会人及其经理线权限--end*/

    		FETCH NEXT FROM @detail_cursor INTO @resourceid 
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor 

        update WorkPlan set resourceid=@allresource where id = @workplanid

        /* 将临时表中的数据写入共享表 */
        declare allmeetshare_cursor cursor for
        select * from @temptablevalueWork
        open allmeetshare_cursor 
        fetch next from allmeetshare_cursor into @meetingid , @userid , @usertype , @sharelevel
        while @@fetch_status=0
        begin 
            insert into WorkPlanShareDetail values(@meetingid , @userid , @usertype , @sharelevel)
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


