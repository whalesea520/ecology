ALTER PROCEDURE CRM_ContactLog_WorkPlan (
@flag integer output , @msg varchar(80) output)
AS 
DECLARE @m_logid int
DECLARE @m_customerid int
DECLARE @m_resourceid int
DECLARE @m_subject varchar(100)
DECLARE @m_contactdate char(10)
DECLARE @m_contacttime char(8)
DECLARE @m_enddate char(10)
DECLARE @m_endtime char(10)
DECLARE @m_contactinfo varchar(4000)
DECLARE @m_documentid int
DECLARE @m_submitdate char(10)
DECLARE @m_submittime char(8)
DECLARE @m_isfinished tinyint
DECLARE @m_isprocessed tinyint
DECLARE @m_agentid int
DECLARE @m_status char(1)
DECLARE @m_workid int
DECLARE @m_userid int
DECLARE @m_usertype int
DECLARE @m_deptId int
DECLARE @m_subcoId int

DECLARE all_cursor CURSOR FOR
SELECT id, customerid, resourceid, subject, contactdate, 
contacttime, enddate, endtime, contactinfo, documentid, 
submitdate, submittime, isfinished, isprocessed, agentid FROM CRM_ContactLog
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_logid, @m_customerid, @m_resourceid, @m_subject, @m_contactdate, @m_contacttime, @m_enddate,
@m_endtime, @m_contactinfo, @m_documentid, @m_submitdate, @m_submittime, @m_isfinished, @m_isprocessed, @m_agentid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
IF (@m_subject <> 'Create')
BEGIN

IF (@m_isfinished = 0)
SET @m_status = '0'
ELSE IF (@m_isprocessed = 0)
SET @m_status = '1'
ELSE
SET @m_status = '2'

INSERT INTO WorkPlan (
type_n, urgentLevel, crmid, resourceid, name, begindate, begintime, enddate, endtime, description, docid, createdate, createtime,
agentId, status, createrid) VALUES ('3', '1', @m_customerid, @m_resourceid, @m_subject, @m_contactdate, @m_contacttime,
@m_enddate, @m_endtime, @m_contactinfo, @m_documentid, @m_submitdate, @m_submittime, @m_agentid, @m_status, @m_resourceid)
SELECT @m_workid = MAX(id) FROM WorkPlan

IF EXISTS(SELECT id FROM CRM_SellChance WHERE comefromid = @m_logid) 
UPDATE CRM_SellChance SET comefromid = @m_workid WHERE comefromid = @m_logid

SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @m_resourceid
UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_workid

INSERT INTO WorkPlanShare (workPlanId,shareType,userId,deptId,roleId,forAll,roleLevel,securityLevel,shareLevel,isdefault) 
SELECT @m_workid,sharetype,seclevel,rolelevel,userid,departmentid,roleid,foralluser,0,1 FROM CRM_ShareInfo WHERE relateditemid = @m_customerid
END

FETCH NEXT FROM all_cursor INTO @m_logid, @m_customerid, @m_resourceid, @m_subject, @m_contactdate, @m_contacttime, @m_enddate,
@m_endtime, @m_contactinfo, @m_documentid, @m_submitdate, @m_submittime, @m_isfinished, @m_isprocessed, @m_agentid
END
CLOSE all_cursor 
DEALLOCATE all_cursor

GO

ALTER PROCEDURE CRM_Share_WorkPlan (
@crmId_1 varchar(100), @flag integer output , @msg varchar(80) output)
AS 
DECLARE @m_workid int
DECLARE @m_userid int
DECLARE @m_usertype int

DECLARE @t_sharetype int
DECLARE @t_seclevel int
DECLARE @t_rolelevel int
DECLARE @t_userid int
DECLARE @t_departmentid int
DECLARE @t_roleid int
DECLARE @t_foralluser char(1)

DECLARE all_cursor CURSOR FOR
SELECT id FROM WorkPlan WHERE type_n = '3' AND (','+crmid+',') LIKE ('%,'+@crmId_1+',%')
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_workid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
DECLARE m_cursor CURSOR FOR
SELECT sharetype,seclevel,rolelevel,userid,departmentid,roleid,foralluser FROM CRM_ShareInfo WHERE relateditemid = @crmId_1
OPEN m_cursor
FETCH NEXT FROM m_cursor INTO @t_sharetype, @t_seclevel, @t_rolelevel, @t_userid, @t_departmentid, @t_roleid, @t_foralluser
WHILE (@@FETCH_STATUS = 0)
BEGIN
IF NOT EXISTS (SELECT workPlanId FROM WorkPlanShare WHERE workPlanId = @m_workid 
AND shareType = @t_sharetype AND userId = @t_userid AND deptId = @t_departmentid 
AND roleId = @t_roleid AND forAll = @t_foralluser AND roleLevel = @t_rolelevel 
AND securityLevel = @t_seclevel AND shareLevel=0 AND isdefault=1)
INSERT INTO WorkPlanShare (workPlanId,shareType,userId,deptId,roleId,forAll,roleLevel,securityLevel,shareLevel,isdefault) 
VALUES (@m_workid,@t_sharetype,@t_userid,@t_departmentid,@t_roleid,@t_foralluser,@t_rolelevel,@t_seclevel,0,1)
FETCH NEXT FROM m_cursor INTO @t_sharetype, @t_seclevel, @t_rolelevel, @t_userid, @t_departmentid, @t_roleid, @t_foralluser
END
CLOSE m_cursor 
DEALLOCATE m_cursor
FETCH NEXT FROM all_cursor INTO @m_workid
END
CLOSE all_cursor 
DEALLOCATE all_cursor

GO

ALTER PROCEDURE HrmRoleMembersShare(@resourceid_1 int, @roleid_1 int, @rolelevel_1 int, @rolelevel_2 int, @flag_1 int, @flag integer output, @msg varchar(80) output)  AS

declare	
        @docid_1	int,
	@crmid_1	int,
	@prjid_1	int,
	@cptid_1	int,
        @sharelevel_1	int,
        @departmentid_1	int,
	@subcompanyid_1	int,
        @seclevel_1	int,
        @countrec	int,
        @countdelete	int,
        @countinsert	int,
        @contractid_1	int,
        @contractroleid_1	int ,
        @sharelevel_Temp	int,
	@workPlanId_1	int,
	@managerstr_11	char(100)


/* 如果有删除原有数据，则将许可表中的权限许可数减一 */
if (@flag_1 = 2) begin
    select @seclevel_1 = seclevel from hrmresource where id = @resourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_DUserP_RoleChange @resourceid_1, @roleid_1, @rolelevel_2, @seclevel_1
    end
end
/* 如果有增加新数据，则将许可表中的权限许可数加一 */
if (@flag_1 = 0) begin
    select @seclevel_1 = seclevel from hrmresource where id = @resourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_GUserP_RoleChange @resourceid_1, @roleid_1, @rolelevel_1, @seclevel_1
    end
end

if ( @flag_1 =0 or ( @flag_1 = 1 and @rolelevel_1  > @rolelevel_2 ) )
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    if @rolelevel_1 = '2'       /* 新的角色级别为总部级 */
    begin 

	

	/* ------- CRM 部分 ----角色变化不影响客户和日程的共享，共享跟角色相对独立--- */
	
	/* ------- PROJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor


	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor

     
        /* ------- 客户合同部分 总部 2003-11-06杨国生------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396为客户合同管理权限*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and t2.rolelevel=2 ;
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
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

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 /* end */

end


else if @rolelevel_1 = '1'          /* 新的角色级别为分部级 */
begin
	/* ------- CRM 部分 ----角色变化不影响客户和日程的共享，共享跟角色相对独立--- */

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department=t4.id and t4.subcompanyid1= @subcompanyid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor



        /* ------- 客户合同部分 分部 2003-11-06杨国生------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396为客户合同管理权限*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 );
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
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

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 /* end */


end


else if @rolelevel_1 = '0'          /* 为新建时候设定级别为部门级 */
begin

    
	
	/* ------- CRM 部分 ---角色变化不影响客户和日程的共享，共享跟角色相对独立---- */

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department= @departmentid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid= @departmentid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


       /* ------- 客户合同部分 部门 2003-11-06杨国生------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396为客户合同管理权限*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=0 and t1.department=@departmentid_1 );
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
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

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 /* end */

    end
end



else if ( @flag_1 =2 or ( @flag_1 = 1 and @rolelevel_1  < @rolelevel_2 ) ) /* 当为删除或者级别降低 */
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0
	
  

   


    /* ------- CRM  部分 ----角色变化不影响客户和日程的共享，共享跟角色相对独立--- */
    
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
    declare inuserprjid_cursor cursor for
    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =@resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' 

    
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
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1) /*2004-8-3 路碰 -- 角色改变时，资产的权限共享不起作用。*/
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

end        /* 结束角色删除或者级别降低的处理 */



    
    /*================== 处理日程 ==================*/
    DECLARE @TmpTableValueWP TABLE (workPlanId int, shareLevel int)
    
    /* 调整人本人日程 */
    DECLARE creater_cursor CURSOR FOR
	SELECT id FROM WorkPlan WHERE createrId = @resourceid_1 
	OPEN creater_cursor 
	FETCH NEXT FROM creater_cursor INTO @workPlanId_1
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 2)
		FETCH NEXT FROM creater_cursor INTO @workPlanId_1
	END
	CLOSE creater_cursor 
    DEALLOCATE creater_cursor

    /* 可以看到调整人下级日程 */     
    SET @managerstr_11 = '%,' + CONVERT(varchar(5), @resourceid_1) + ',%' 
    DECLARE underling_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE ',' + MANAGERSTR LIKE @managerstr_11))
    OPEN underling_cursor 
    FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1
        IF (@countrec = 0)
        	INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 1)
        FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    END
    CLOSE underling_cursor 
    DEALLOCATE underling_cursor     

GO
