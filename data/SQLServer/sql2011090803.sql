Alter PROCEDURE Share_forDoc
(
    @docid int ,
    @flag int output, 
    @msg varchar(80) output 
)
AS 
declare @sharetype int
declare @newsharetype int
declare @sharecontent varchar(10)

declare @sharelevel int
declare @foralluser int
declare @departmentid int
declare @subcompanyid int
declare @userid int
declare @ownerid int
declare @createrid int
declare @crmid int
declare @orgGroupId int
declare @temp_userid int
declare @srcfrom int
declare @opuser int
declare @temp_departmentid int 

declare @roleid int
declare @rolelevel int
declare @rolevalue int
declare @seclevel int
declare @sharesource int

declare @isExistInner int
declare @isExistOuter int

declare @isSysadmin int
declare @downloadlevel int
BEGIN
    /*选删除相关数据*/
    DELETE ShareinnerDoc  WHERE  sourceid=@docid
    DELETE ShareouterDoc  WHERE  sourceid=@docid
    

    /*再插入相关数据*/
    declare docid_cursor cursor for   
    select docid,sharetype,seclevel,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,orgGroupId,sharesource,downloadlevel 
    from docshare where docid=@docid and docid>0

    open docid_cursor fetch next from docid_cursor into @docid,@sharetype,@seclevel,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@orgGroupId,@sharesource,@downloadlevel

     while @@fetch_status=0 
      begin  
           set @isExistInner=0
           set @isExistOuter=0
           if @downloadlevel is null set @downloadlevel=0
           /*得到值*/         
            if @sharetype=1   /*人力资源*/ 
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @srcfrom=1
                    set @opuser=@userid

                    set @isExistInner=1
                end

            else if  @sharetype=2  /*分部*/            
                begin
                    set @newsharetype=2
                    set @sharecontent=@subcompanyid 
                    set @seclevel=@seclevel
                    set @srcfrom=2
                    set @opuser=@subcompanyid
                    set @isExistInner=1
                end  

            else if  @sharetype=3  /*部门*/
                begin
                    set @newsharetype=3
                    set @sharecontent=@departmentid 
                    set @seclevel=@seclevel
                    set @srcfrom=3
                    set @opuser=@departmentid

                    set @isExistInner=1
                end  
           else if  @sharetype=6  /*群组*/
                begin
                    set @newsharetype=6
                    set @sharecontent=@orgGroupId
                    set @seclevel=@seclevel
                    set @srcfrom=6
                    set @opuser=@orgGroupId

                    set @isExistInner=1
                end 
           else if  @sharetype=5  /*所有人*/
                begin
                    set @newsharetype=5
                    set @sharecontent=1 
                    set @seclevel=@seclevel
                    set @srcfrom=5
                    set @opuser=0

                    set @isExistInner=1
                end 
           else if  @sharetype=80  /*创建人本身*/
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @srcfrom=80
                    set @opuser=@userid                    
                    set @isExistInner=1
                    
                    /*如果文档的创建者和文档的所有者如果不是同一人的话，他们的权限将保持一致*/
				    select @ownerid=ownerid, @createrid=doccreaterid  from docdetail where id=@docid    
				    if (@ownerid!=@createrid) begin
                         insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
                         values(@docid,1,@ownerid,0,@sharelevel,86,0,0,@downloadlevel)  
                    end                    
                end 
          else if  @sharetype=81  /*创建人直接上级*/
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid
                  if (@isSysadmin!=1)    
                  begin                
	                  set @newsharetype=1
	                  /*求上级*/
	                  SELECT  @sharecontent=managerid FROM HrmResource where id=@userid
	                  set @seclevel=0
	                  set @srcfrom=81
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
              end 
         else if  @sharetype=84  /*同分部*/
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid                    
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=2
	                  /*求分部*/                  
	                  SELECT  @temp_departmentid=departmentid  FROM HrmResource where id=@userid
	                  select @sharecontent=subcompanyid1   from  HrmDepartment where id=@temp_departmentid
	
	                  set @seclevel=@seclevel
	                  set @srcfrom=84
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
              end 
         else if  @sharetype=85  /*同部门*/
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid  
                  if (@isSysadmin!=1)    
                  begin 
	                  set @newsharetype=3
	                  /*求部门*/
	                  SELECT @sharecontent=departmentid  FROM HrmResource where id=@userid
	                  set @seclevel=@seclevel
	                  set @srcfrom=85
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                  end
              end 

       else if  @sharetype=-81  /*客户的经理*/
          begin
              set @newsharetype=1             
              select @sharecontent=manager from CRM_CustomerInfo where id=@userid /*求客户的经理*/
              set @seclevel=0
              set @srcfrom=-81
              set @opuser=@userid

              set @isExistInner=1
          end 
       else if  @sharetype=9  /*客户*/
          begin
              set @newsharetype=9             
              select @sharecontent=@crmid
              set @seclevel=0
              set @srcfrom=9
              set @opuser=@crmid

              set @isExistOuter=1
          end 

         else if  @sharetype=-80  /*客户本人*/
          begin
              set @newsharetype=9             
              select @sharecontent=@userid
              set @seclevel=0
              set @srcfrom=-80
              set @opuser=@userid

              set @isExistOuter=1
          end 
          else if  @sharetype<0 and @sharetype>-80 /*客户类型*/
          begin
              set @newsharetype=10             
              select @sharecontent=STR(@sharetype*-1)
              set @srcfrom=10
              set @opuser=@sharetype

              set @isExistOuter=1
          end 
          else if  @sharetype=4  /*角色 角色类型的处理比较特殊*/
                begin  
                    set @newsharetype=4    
                    set @srcfrom=4
                    set @opuser=@roleid

                     if @docid is null set @docid=0
                     if @newsharetype is null set @newsharetype=0
                     if @sharecontent is null set @sharecontent=0
                     if @seclevel is null set @seclevel=0
                     if @sharelevel is null set @sharelevel=0
                     if @srcfrom is null set @srcfrom=0
                     if @opuser is null set @opuser=0
                     if @sharesource is null set @sharesource=0


                    IF @rolelevel=0 /*表部门 总部,分部,部门能看*/
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(0,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    else  IF @rolelevel=1 /*表分部 总部,分部能看*/                        
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    else IF @rolelevel=2 /*表总部 总部能看*/
                    BEGIN
                      set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                      insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    set @isExistInner=0  /*不需要再在下面插入数据*/
                end   
         IF  @isExistInner=1
         BEGIN
             if @docid is null set @docid=0
             if @newsharetype is null set @newsharetype=0
             if @sharecontent is null set @sharecontent=0
             if @seclevel is null set @seclevel=0
             if @sharelevel is null set @sharelevel=0
             if @srcfrom is null set @srcfrom=0
             if @opuser is null set @opuser=0
             if @sharesource is null set @sharesource=0

             /*插入数据*/                         
             insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values       
             (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel)             
         END             

         IF  @isExistOuter=1 
         BEGIN
             if @docid is null set @docid=0
             if @newsharetype is null set @newsharetype=0
             if @sharecontent is null set @sharecontent=0
             if @seclevel is null set @seclevel=0
             if @sharelevel is null set @sharelevel=0
             if @srcfrom is null set @srcfrom=0
             if @opuser is null set @opuser=0
             if @sharesource is null set @sharesource=0

             /*插入数据*/
             insert into ShareouterDoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values        
             (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel)
         END          

        /*进入下一循环*/    
        fetch next from docid_cursor into  @docid,@sharetype,@seclevel,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@orgGroupId,@sharesource,@downloadlevel
      end 
    close docid_cursor deallocate docid_cursor	
END
GO
