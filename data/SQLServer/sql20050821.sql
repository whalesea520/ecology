

alter PROCEDURE HrmResource_SelectAll 
 (@flag integer output, @msg   varchar(80) output ) 
AS select 
  id,
  loginid,  
  lastname,
  sex,
  resourcetype,
  email,
  locationid,
  workroom, 
  departmentid,
  costcenterid,
  jobtitle,
  managerid,
  assistantid ,
  seclevel,
  joblevel,
  status,
  account
from HrmResource  
if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 

GO


alter PROCEDURE HrmResourceSystemInfo_Insert (@id_1 int, @loginid_2 varchar(20), @password_3 varchar(60), @systemlanguage_4 int, @seclevel_5 int, @email_6 varchar(60) ,@needusb1 int,@serial1 char(10),@account_2 varchar(60),@lloginid_2 varchar(60),@flag int output, @msg varchar(60) output) AS 
   declare @count int  
   declare @oldpass varchar(60)  
   declare @chgpasswddate char(10)  
   set @chgpasswddate=null select @oldpass=password from HrmResource where id=@id_1 
   if (@oldpass is null and @password_3<>'0' ) or @oldpass<>@password_3 
   set @chgpasswddate=convert(char(10),getdate(),120)  
   if @loginid_2 is not null and @loginid_2 != '' and @loginid_2 != 'sysadmin' 
   select @count = count(id) from HrmResource where id != @id_1 and loginid = @loginid_2  
   if ( @count is not null and @count > 0 ) or @loginid_2 = 'sysadmin' 
   select 0 
   else begin 
   if @password_3 = '0' begin
   if @serial1='0'
   UPDATE HrmResource SET loginid = @loginid_2, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,account=@account_2,lloginid=@lloginid_2 WHERE id = @id_1
   else UPDATE HrmResource SET loginid = @loginid_2, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,serial=@serial1,account=@account_2,lloginid=@lloginid_2 WHERE id = @id_1
   end
   else begin
   if @serial1='0' 
   UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,account=@account_2,lloginid=@lloginid_2  WHERE id = @id_1
   else UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,serial=@serial1,account=@account_2,lloginid=@lloginid_2  WHERE id = @id_1
   end
   end


GO

drop trigger Tri_U_workflow_createlist
go
create  TRIGGER Tri_U_workflow_createlist ON HrmResource WITH ENCRYPTION
FOR UPDATE
AS
Declare @workflowid int,
        @type int,
        @objid int,
        @level_n int,
        @level2_n int,
        @userid int,
        @resourceid_1 int,
        @loginid_1 varchar(60),
        @olddepartmentid_1 int,
        @subcompanyid1_1 int,
        @departmentid_1 int,
        @oldseclevel_1   int,
        @seclevel_1  int,
        @all_cursor cursor,
        @detail_cursor cursor,
        @current_date char(10),
        @current_time char(8),
        @agenter_id int,
        @begin_date char(10),
        @begin_time char(8),
        @end_date char(10),
        @end_time char(8),
        @agent_cursor cursor,
        @isbeAgent int

select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel from deleted
select @resourceid_1 = id , @loginid_1 = loginid , @departmentid_1 = departmentid, @seclevel_1 = seclevel from inserted
select @subcompanyid1_1 = subcompanyid1 from HrmDepartment where id = @departmentid_1
select @current_date=subString(convert(char,getDate(),120),1,10)
select @current_time=subString(convert(char,getDate(),120),12,19)

if (@departmentid_1 is not null and @olddepartmentid_1 is not null and (@departmentid_1 <> @olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1) )
begin 
    delete from workflow_createrlist where userid = @resourceid_1 and usertype = 0
    
    if @loginid_1 <> '' and @loginid_1 is not null
    begin 
        SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
        select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

        OPEN @all_cursor 
        FETCH NEXT FROM @all_cursor INTO @workflowid ,  @type ,@objid ,@level_n ,@level2_n
        WHILE @@FETCH_STATUS = 0
        begin 

            SET @isbeAgent=0
            SET @agent_cursor = CURSOR FORWARD_ONLY STATIC FOR
            select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=@workflowid and beagenterId=@resourceid_1 and isCreateAgenter=1
            OPEN @agent_cursor
            FETCH NEXT FROM @agent_cursor INTO @agenter_id ,@begin_date ,@begin_time ,@end_date ,@end_time
            if @@FETCH_STATUS = 0
            begin
                SET @isbeAgent=1;
                if (@begin_date<>'') begin
                    if (@current_date<@begin_date)
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@begin_date and @begin_time<>'') begin
                            if(@current_time<@begin_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
                if (@end_date<>'') begin
                    if (@current_date>@end_date) 
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@end_date and @end_time<>'') begin
                            if(@current_time>@end_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
            end
            CLOSE @agent_cursor
            DEALLOCATE @agent_cursor


            if @type=1 
            begin
                if @departmentid_1 is not null and @departmentid_1 = @objid and @seclevel_1 >= @level_n and @seclevel_1 <= @level2_n begin
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@resourceid_1,0,0)
                    if @isbeAgent=1
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)
                end
            end
            else if @type=2
            begin
                SELECT @userid = count(resourceid) FROM HrmRoleMembers where roleid =  @objid and rolelevel >=@level_n and resourceid = @resourceid_1
                if @userid > 0  begin
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@resourceid_1,0,0)
                    if @isbeAgent=1
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)
                end
            end
            else if @type=3
            begin
                if @resourceid_1 = @objid begin
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@resourceid_1,0,0)
                    if @isbeAgent=1
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)
                end
            end
            else if @type=30
            begin
                if @subcompanyid1_1 = @objid and @seclevel_1 >= @level_n and @seclevel_1 <= @level2_n begin
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@resourceid_1,0,0)
                    if @isbeAgent=1
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)
                end
            end
            FETCH NEXT FROM @all_cursor INTO @workflowid ,  @type ,@objid ,@level_n,@level2_n
        end 
        CLOSE @all_cursor
        DEALLOCATE @all_cursor
    end
end
go


/* 修改hrmresource的trigger */
drop trigger Tri_Update_HrmresourceShare 
go
create  TRIGGER Tri_Update_HrmresourceShare ON Hrmresource WITH ENCRYPTION
FOR UPDATE
AS
Declare @resourceid_1 int,
        @subresourceid_1 int,
        @supresourceid_1 int,
        @olddepartmentid_1 int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @oldseclevel_1	 int,
	    @seclevel_1	 int,
        @docid_1	 int,
        @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,        
        @sharelevel_1  int,
        @countrec      int,
        @countdelete   int,
        @oldmanagerstr_1    varchar(200),
        @managerstr_1    varchar(200) ,
        @contractid_1	 int, /*2003-11-06杨国生*/
        @contractroleid_1 int ,   /*2003-11-06杨国生*/
        @sharelevel_Temp int,    /*2003-11-06杨国生*/
	@workPlanId_1 int	/* added by lupeng 2004-07-22 */
       


/* 从刚修改的行中查找修改的resourceid 等 */
select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel , 
       @oldmanagerstr_1 = managerstr from deleted
select @resourceid_1 = id , @departmentid_1 = departmentid, @subcompanyid_1 = subcompanyid1 ,  
       @seclevel_1 = seclevel , @managerstr_1 = managerstr from inserted

/* 如果部门和安全级别信息被修改 */
if (@departmentid_1 is not null and @olddepartmentid_1 is not null and (@departmentid_1 <>@olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 or @oldseclevel_1 is null ))
begin


    /* 修改目录许可表 */
    if ((@olddepartmentid_1 is not null) and (@oldseclevel_1 is not null)) begin
        execute Doc_DirAcl_DUserP_BasicChange @resourceid_1, @olddepartmentid_1, @oldseclevel_1
    end
    if ((@departmentid_1 is not null) and (@seclevel_1 is not null)) begin
        execute Doc_DirAcl_GUserP_BasicChange @resourceid_1, @departmentid_1, @seclevel_1
    end

    /* 该人新建文档目录的列表 */
    exec DocUserCategory_InsertByUser @resourceid_1,'0','',''
    
    /* DOC 部分*/

    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevalue  table(docid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    declare docid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid = @resourceid_1 or ownerid = @resourceid_1 ) and usertype= '1'
    open docid_cursor 
    fetch next from docid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalue values(@docid_1, 2)
        fetch next from docid_cursor into @docid_1
    end
    close docid_cursor deallocate docid_cursor


    /* 自己下级的文档 */
    /* 查找下级 */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subdocid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) or ownerid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and usertype= '1'
    open subdocid_cursor 
    fetch next from subdocid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1
        if @countrec = 0  insert into @temptablevalue values(@docid_1, 1)
        fetch next from subdocid_cursor into @docid_1
    end
    close subdocid_cursor deallocate subdocid_cursor
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    declare sharedocid_cursor cursor for
    select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= @seclevel_1 )  or ( userid= @resourceid_1 ) or (departmentid= @departmentid_1 and seclevel<= @seclevel_1 )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor



    /* 将临时表中的数据写入共享表 */
    declare alldocid_cursor cursor for
    select * from @temptablevalue
    open alldocid_cursor 
    fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into docsharedetail values(@docid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    end
    close alldocid_cursor deallocate alldocid_cursor


    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1
    
    /* delete the work plan share info of this user */
    DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* 作为crm管理员能看到的客户 */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* 由客户的共享获得的权利 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* 将临时表中的数据写入共享表 */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)

	/* added by lupeng 2004-07-22 for customer contact work plan */	
        DECLARE ccwp_cursor CURSOR FOR
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
        OPEN ccwp_cursor 
        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN 	    
	    IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
	    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        END	    
        CLOSE ccwp_cursor 
        DEALLOCATE ccwp_cursor
	/* end */

        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor



    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* 作为项目管理员能看到的项目4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* 由项目的共享获得的权利 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* 项目成员5 (内部用户) */
	declare @members_1 varchar(200)
	set @members_1 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 
    declare inuserprjid_cursor cursor for
    SELECT  id FROM Prj_ProjectInfo   WHERE  (','+members+','  LIKE  @members_1)  and isblock='1' 
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* 自己下级的资产1 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* 由资产的共享获得的权利 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcptid_cursor cursor for
    select * from @temptablevalueCpt
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor


     /* ------- 客户合同部分2003-11-06杨国生 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluecontract  table(contractid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecontract 中 */

    /* 自己下级的客户合同 3 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcontractid_cursor cursor for
    select id from CRM_Contract where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcontractid_cursor 
    fetch next from subcontractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
        if @countrec = 0  insert into @temptablevaluecontract values(@contractid_1, 3)
        fetch next from subcontractid_cursor into @contractid_1
    end
    close subcontractid_cursor deallocate subcontractid_cursor

 
    /*  自己是 manager 的客户合同 2 */
    declare contractid_cursor cursor for
    select id from CRM_Contract where manager = @resourceid_1 
    open contractid_cursor 
    fetch next from contractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecontract values(@contractid_1, 2)
        fetch next from contractid_cursor into @contractid_1
    end
    close contractid_cursor deallocate contractid_cursor



    /* 作为客户合同管理员能看到的 */
    declare roleids_cursor cursor for
    select roleid from SystemRightRoles where rightid = 396
    open roleids_cursor 
    fetch next from roleids_cursor into @contractroleid_1
    while @@fetch_status=0
    begin 

       declare rolecontractid_cursor cursor for
       select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1 ) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ));
       
        open rolecontractid_cursor 
        fetch next from rolecontractid_cursor into @contractid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
            if @countrec = 0  
            begin
                insert into @temptablevaluecontract values(@contractid_1, 2)
            end
            else
            begin
                select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                if @sharelevel_1 = 1
                begin
                     update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                end 
            end
            fetch next from rolecontractid_cursor into @contractid_1
        end
        close rolecontractid_cursor deallocate rolecontractid_cursor
        
     fetch next from roleids_cursor into @contractroleid_1
     end
     close roleids_cursor deallocate roleids_cursor	 


    /* 由客户合同的共享获得的权利 1 2 */
    declare sharecontractid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecontractid_cursor 
    fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecontract values(@contractid_1, @sharelevel_1)
        end
        else
        begin
            select @sharelevel_Temp = sharelevel from @temptablevaluecontract where contractid = @contractid_1
            if ((@sharelevel_Temp = 1) and (@sharelevel_1 = 2)) 
            update @temptablevaluecontract set sharelevel = @sharelevel_1 where contractid = @contractid_1
        end
        fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    end 
    close sharecontractid_cursor deallocate sharecontractid_cursor



    declare sharecontractid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecontractid_cursor 
    fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecontract values(@contractid_1, @sharelevel_1)
        end
        else
        begin
            select @sharelevel_Temp = sharelevel from @temptablevaluecontract where contractid = @contractid_1
            if ((@sharelevel_Temp = 1) and (@sharelevel_1 = 2)) 
            update @temptablevaluecontract set sharelevel = @sharelevel_1 where contractid = @contractid_1
        end
        fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    end 
    close sharecontractid_cursor deallocate sharecontractid_cursor


    /* 自己下级的客户合同  (客户经理及经理线)*/
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcontractid_cursor cursor for
    select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 where ( t1.manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and (t2.crmId = t1.id)
    open subcontractid_cursor 
    fetch next from subcontractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
        if @countrec = 0  insert into @temptablevaluecontract values(@contractid_1, 1)
        fetch next from subcontractid_cursor into @contractid_1
    end
    close subcontractid_cursor deallocate subcontractid_cursor

 
    /*  自己是 manager 的客户 (客户经理及经理线) */
    declare contractid_cursor cursor for
    select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 where (t1.manager = @resourceid_1 ) and (t2.crmId = t1.id)
    open contractid_cursor 
    fetch next from contractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecontract values(@contractid_1, 1)
        fetch next from contractid_cursor into @contractid_1
    end
    close contractid_cursor deallocate contractid_cursor


    /* 删除原有的与该人员相关的所有权 */
    delete from ContractShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcontractid_cursor cursor for
    select * from @temptablevaluecontract
    open allcontractid_cursor 
    fetch next from allcontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel) values(@contractid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcontractid_cursor into @contractid_1 , @sharelevel_1
    end
    close allcontractid_cursor deallocate allcontractid_cursor


    /* for work plan */ 
    /* added by lupeng 2004-07-22 */
    /* delete all the work plan share info of this user */
    /* DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1 */

    /* define a temporary table */
    DECLARE @TmpTableValueWP TABLE (workPlanId int, shareLevel int)
    
    /* write the data to the temporary table */
    /* a. the creater of the work plan is this user */
    DECLARE creater_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE createrid = @resourceid_1 
    OPEN creater_cursor 
    FETCH NEXT FROM creater_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 2)
        FETCH NEXT FROM creater_cursor INTO @workPlanId_1
    END
    CLOSE creater_cursor 
    DEALLOCATE creater_cursor

    /* b. the creater of the work plan is my underling */     
    SET @managerstr_11 = '%,' + CONVERT(varchar(5), @resourceid_1) + ',%' 
    DECLARE underling_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE ',' + MANAGERSTR LIKE @managerstr_11))
    OPEN underling_cursor 
    FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1
        IF (@countrec = 0)  INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 1)
        FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    END
    CLOSE underling_cursor 
    DEALLOCATE underling_cursor     


    /* c. in the work plan share info */
    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE ((forAll = 1 AND securityLevel <= @seclevel_1) OR (userId = @resourceid_1) OR (deptId = @departmentid_1 AND securityLevel <= @seclevel_1))
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0)
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor

    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2, HrmRoleMembers t3 WHERE t1.id = t2.workPlanId AND t3.resourceid = @resourceid_1 AND t3.roleid = t2.roleId AND t3.rolelevel >= t2.roleLevel AND t2.securityLevel <= @seclevel_1 AND ((t2.roleLevel = 0  AND t1.deptId = @departmentid_1) OR (t2.roleLevel = 1 AND t1.subcompanyId = @subcompanyid_1) OR (t3.rolelevel = 2)) 
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0 )
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor

    /* write the temporary table data to the share detail table */
    DECLARE allwp_cursor CURSOR FOR
    SELECT * FROM @TmpTableValueWP
    OPEN allwp_cursor 
    FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
        FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    END
    CLOSE allwp_cursor 
    DEALLOCATE allwp_cursor
    /* end */


end        /* 结束修改了部门和安全级别的情况 */
            

       
/* 对于修改了经理字段,新的所有上级增加对该下级的文档共享,共享级别为可读 */
if ( @countdelete > 0 and @managerstr_1 <> @oldmanagerstr_1 )  /* 新建人力资源时候对经理字段的改变不考虑 */
begin
    if ( @managerstr_1 is not null and len(@managerstr_1) > 1 )  /* 有上级经理 */
    begin

        set @managerstr_1 = ',' + @managerstr_1

	/* ------- DOC 部分 ------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, DocDetail t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and ( t2.doccreaterid = @resourceid_1 or t2.ownerid = @resourceid_1 ) and t2.usertype= '1' ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @docid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @docid_1
        end
        close supuserid_cursor deallocate supuserid_cursor
	
	/* ------- CRM 部分 ------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CRM_CustomerInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1,@supresourceid_1,1,3)
            end

	    /* added by lupeng 2004-07-22 for customer contact work plan */	
	    DECLARE ccwp_cursor CURSOR FOR
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
	    OPEN ccwp_cursor 
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    WHILE (@@FETCH_STATUS = 0)
	    BEGIN 	    
	        IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
	        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
	        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    END	    
	    CLOSE ccwp_cursor 
	    DEALLOCATE ccwp_cursor
	    /* end */

            fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* ------- PROJ 部分 ------- */
	declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, Prj_ProjectInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @prjid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1,@supresourceid_1,1,3)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @prjid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* ------- CPT 部分 ------- */
	declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CptCapital t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.resourceid = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @cptid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @cptid_1
        end
        close supuserid_cursor deallocate supuserid_cursor

        

         /* ------- 客户合同部分 经理改变 2003-11-06杨国生------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CRM_Contract t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @contractid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel) values(@contractid_1,@supresourceid_1,1,3)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @contractid_1
        end
        close supuserid_cursor deallocate supuserid_cursor

        declare supuserid_cursor cursor for
        select distinct t1.id , t3.id from HrmResource t1, CRM_CustomerInfo t2 ,CRM_Contract t3 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  and t2.id = t3.crmId;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @contractid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel) values(@contractid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @contractid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* for work plan */ 
	/* added by lupeng 2004-07-22 */
	DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id, t2.id FROM HrmResource t1, WorkPlan t2 WHERE @managerstr_1 LIKE '%,' + CONVERT(varchar(5),t1.id) + ',%' AND t2.createrid = @resourceid_1
        OPEN supuserid_cursor 
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN 
            SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @supresourceid_1 AND usertype = 1
            IF (@countrec = 0)
            BEGIN
                INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) values(@workPlanId_1, @supresourceid_1, 1, 1)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @workPlanId_1
        end
        CLOSE supuserid_cursor 
	DEALLOCATE supuserid_cursor
	/* end */


    end             /* 有上级经理判定结束 */
end   /* 修改经理的判定结束 */

go