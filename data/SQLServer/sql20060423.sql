
alter FUNCTION GetDocShareDetailTable  (@userid varchar(10) ,@usertype  varchar(10))
RETURNS @DocShareDetail  TABLE (sourceid int , sharelevel int)
AS
BEGIN  
   Declare @seclevel varchar(10),@departmentid varchar(10),@subcompanyid varchar(10),@type varchar(10)
   if @usertype='1'
   begin
      select @seclevel=seclevel,@departmentid=departmentid,@subcompanyid=subcompanyid1 from hrmresource where id=@userid   
      begin
        insert @DocShareDetail SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareinnerdoc where 
        (type=1 and content=@userid) or  (type=2 and content=@subcompanyid and seclevel<=@seclevel) or 
        (type=3 and content=@departmentid and seclevel<=@seclevel) or (  type=4 and content in 
        (select convert(VARCHAR(10),roleid)+CONVERT(VARCHAR(10),rolelevel) from hrmrolemembers where resourceid=@userid) and seclevel<=@seclevel) 
        GROUP BY sourceid
     end       
   end
   else 
    begin     
      select @type=type,@seclevel=seclevel from crm_customerinfo where id=@userid
       insert @DocShareDetail  SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareouterdoc where 
                               (type=9 and content=@userid) or 
                               (type=10 and content=@type and seclevel<=@seclevel)
                                GROUP BY sourceid
    end  
   RETURN 
END
GO



Alter  TRIGGER Tri_Update_HrmresourceShare ON Hrmresource WITH ENCRYPTION
FOR UPDATE
AS
Declare @resourceid_1 int,
        @subresourceid_1 int,
        @supresourceid_1 int,
        @olddepartmentid_1 int,
        @departmentid_1 int,
        @subcompanyid_1 int,
        @oldseclevel_1   int,
        @seclevel_1  int,
        @docid_1     int,
        @crmid_1     int,
        @prjid_1     int,
        @cptid_1     int,        
        @sharelevel_1  int,
        @countrec      int,
        @countdelete   int,
        @managerid   int,
        @oldManagerid   int,
        @oldmanagerstr_1    varchar(200),
        @managerstr_1    varchar(200) ,
        @contractid_1    int, 
        @contractroleid_1 int ,   
        @sharelevel_Temp int,    
        @workPlanId_1 int   
       


select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel , 
       @oldmanagerstr_1 = managerstr ,@oldManagerid=managerid from deleted
select @resourceid_1 = id , @departmentid_1 = departmentid, @subcompanyid_1 = subcompanyid1 ,  
       @seclevel_1 = seclevel , @managerstr_1 = managerstr ,@managerid=managerid from inserted

if (@departmentid_1 is not null and @olddepartmentid_1 is not null and (@departmentid_1 <>@olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 or @oldseclevel_1 is null ))
begin


    if ((@olddepartmentid_1 is not null) and (@oldseclevel_1 is not null)) begin
        execute Doc_DirAcl_DUserP_BasicChange @resourceid_1, @olddepartmentid_1, @oldseclevel_1
    end
    if ((@departmentid_1 is not null) and (@seclevel_1 is not null)) begin
        execute Doc_DirAcl_GUserP_BasicChange @resourceid_1, @departmentid_1, @seclevel_1
    end

    exec DocUserCategory_InsertByUser @resourceid_1,'0','',''
    
  

    delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1
    
    
    DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

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


    declare @managerstr_11 varchar(200) 
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


    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)

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


        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor


    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

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


    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

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


    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

 
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
    

    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

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


    Declare @temptablevaluecontract  table(contractid int,sharelevel int)

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

    delete from ContractShareDetail where userid = @resourceid_1 and usertype = 1


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


    DECLARE @TmpTableValueWP TABLE (workPlanId int, shareLevel int)
    
  
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


end       


if (@managerid is not null and @managerid<>@oldManagerid)
begin
update shareinnerdoc set content=@managerid where srcfrom=81 and opuser=@resourceid_1   
end 

if (  @managerstr_1 <> @oldmanagerstr_1 )  
begin
    if ( @managerstr_1 is not null and len(@managerstr_1) > 1 ) 
    begin

        set @managerstr_1 = ',' + @managerstr_1


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

            fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        end
        close supuserid_cursor deallocate supuserid_cursor

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

    end         
end  

GO
