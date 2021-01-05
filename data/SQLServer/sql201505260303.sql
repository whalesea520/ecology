alter table DocSecCategoryShare add  operategroup char(10) null
GO
alter table DocSecCategoryShare add  orgid char(10) null
GO
alter table DocSecCategoryShare add  seclevelmax char(10)  not null DEFAULT '255'
GO
alter table DocSecCategoryShare add  includesub char(10) null
GO
alter table DocSecCategoryShare add  custype char(10) null
GO
alter table DocSecCategoryShare add  isolddate char(10) null
GO
alter table docshare add  allmanagers varchar(2000) null
GO
alter table docshare add  includesub char(10) null
GO
alter table docshare add  orgid char(10) null
GO
alter table docshare add  seclevelmax char(10)  not null DEFAULT '255' 
GO
alter table DirAccessControlList add  seclevelmax  char(10)  not null DEFAULT '255'
GO
alter table DirAccessControlList add  isolddate    char(10) null
GO
alter table DirAccessControlDetail add  seclevelmax    char(10)  not null DEFAULT '255'
GO

alter table shareinnerdoc add   seclevelmax char(10) not null DEFAULT '255'
Go
alter table ShareouterDoc add   seclevelmax char(10) not null DEFAULT '255'
Go

insert into DocSecCategoryShare (seccategoryid,sharetype,sharelevel,downloadlevel,operategroup)select id,1,3,1,1 from DocSecCategory
GO
insert into DocSecCategoryShare (seccategoryid,sharetype,sharelevel,downloadlevel,operategroup)select id,2,1,1,1 from DocSecCategory
GO
insert into DocSecCategoryShare (seccategoryid,sharetype,sharelevel,downloadlevel,operategroup)select id,1,3,1,2 from DocSecCategory
GO
insert into DocSecCategoryShare (seccategoryid,sharetype,sharelevel,downloadlevel,operategroup)select id,2,1,1,2 from DocSecCategory
GO

alter PROCEDURE Doc_DirAcl_CheckPermission(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, 
@departmentid_1 varchar(4000),@subcompanyid_1 varchar(4000), @roleid_1 varchar(4000),@flag int output, @msg varchar(4000) output)  AS
declare @count_1 int
declare @result int
set @result = 0
if @usertype_1 = 0 begin
    set @count_1 = (select count(sourceid) from DirAccessControlDetail  where  sourceid = @dirid_1 and  sourcetype=@dirtype_1 and  sharelevel=@operationcode_1 and ((type=1 and content in (select * from SplitStr(@departmentid_1,',')) and seclevel<=@seclevel_1 and seclevelmax>=@seclevel_1 ) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=3 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=5 and content=@userid_1) or (type=6 and content in (select * from SplitStr(@subcompanyid_1,',')) and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 )))
end
else begin
    set @count_1 = (select count(mainid) from DirAccessControlList where dirid=@dirid_1 and dirtype=@dirtype_1 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 )))
end
print @count_1
if (not (@count_1 is null)) and (@count_1 > 0) begin
    set @result = 1
end
select @result result
if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=-1 
    set @msg='检查目录访问权限失败' 
    return 
end
GO
alter PROCEDURE Doc_DirAcl_CheckPermissionBE (@dirid_1 int, @dirtype_1 int, @userid_1 varchar(4000), @usertype_1 int, @seclevel_1 int, @operationcode_1 int, 
@departmentid_1 varchar(4000),@subcompanyid_1 varchar(4000), @roleid_1 varchar(4000),@flag int output, @msg varchar(4000) output)  AS
declare @count_1 int
declare @result int
set @result = 0
if @usertype_1 = 0 begin
    set @count_1 = (select count(sourceid) from DirAccessControlDetail  where  sourceid = @dirid_1 and  sourcetype=@dirtype_1 and  sharelevel=@operationcode_1 and ((type=1 and content in(select * from SplitStr(@departmentid_1,',')) and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=3 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=5 and content in(select * from SplitStr(@userid_1,','))) or (type=6 and content in(select * from SplitStr(@subcompanyid_1,',')) and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 )))
end
else begin
    set @count_1 = (select count(mainid) from DirAccessControlList where dirid=@dirid_1 and dirtype=@dirtype_1 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 )))
end
print @count_1
if (not (@count_1 is null)) and (@count_1 > 0) begin
    set @result = 1
end
select @result result
if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=-1 
    set @msg='检查目录访问权限失败' 
    return 
end
GO
alter PROCEDURE Doc_DirAcl_CheckPermissionEx1(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int,
@departmentid_1 varchar(4000),@subcompanyid_1 varchar(4000), @roleid_1 varchar(4000), @haspermission_1 int output, @flag int output, @msg varchar(4000) output)  AS 
declare @count_1 int
declare @result int
set @result = 0
if @usertype_1 = 0 begin
    set @count_1 = (select count(sourceid) from DirAccessControlDetail  where  sourceid = @dirid_1 and  sourcetype=@dirtype_1 and  sharelevel=@operationcode_1 and ((type=1 and content in (select * from SplitStr(@departmentid_1,',')) and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=2 and content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=3 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (type=5 and content=@userid_1) or (type=6 and content in (select * from SplitStr(@subcompanyid_1,',')) and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 )))
end
else begin
    set @count_1 = (select count(mainid) from DirAccessControlList where dirid=@dirid_1 and dirtype=@dirtype_1 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 ) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1  and seclevelmax>=@seclevel_1 )))
end
if (not (@count_1 is null)) and (@count_1 > 0) begin
    set @result = 1
end
set @haspermission_1 = @result
if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='检查目录访问权限失败' 
    return 
end
GO

ALTER PROCEDURE DocSecCategoryShare_Ins_G (
@secid	int,
@sharetype	int,
@seclevel	tinyint, 
@rolelevel	tinyint, 
@sharelevel	tinyint, 
@userid	int, 
@subcompanyid	int, 
@departmentid	int, 
@roleid	int, 
@foralluser	tinyint, 
@crmid int, 
@orgGroupId int,
@downloadlevel int,
@operategroup char(10),
@orgid  char(10),
@seclevelmax char(10),
@includesub char(10),
@custype char(10),
@isolddate char(10),
@flag	int output, 
@msg	varchar(4000)	output
) 
as 
insert into DocSecCategoryShare 
(seccategoryid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,orgGroupId,downloadlevel,operategroup,orgid,seclevelmax,includesub,custype,isolddate )
values (@secid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser,@crmid,@orgGroupId,@downloadlevel,@operategroup,@orgid,@seclevelmax,@includesub,@custype,@isolddate) 

GO
Alter PROCEDURE Share_forDoc
(
    @docid int ,
    @flag int output, 
     @msg varchar(4000) output 
)
AS 
declare @sharetype int
declare @newsharetype int
declare @sharecontent varchar(4000)

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

declare @seclevelmax int
declare @allmanagers int
declare @orgid int
declare @includesub int

declare @sharesource int
declare @isExistInner int
declare @isExistOuter int

declare @isSysadmin int
declare @hasmanager int
declare @downloadlevel int
BEGIN
    /*选删除相关数据*/
    DELETE ShareinnerDoc  WHERE  sourceid=@docid
    DELETE ShareouterDoc  WHERE  sourceid=@docid
    

    /*再插入相关数据*/
    declare docid_cursor cursor for   
    select docid,sharetype,seclevel,seclevelmax,allmanagers,orgid,includesub,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,orgGroupId,sharesource,downloadlevel 
    from docshare where docid=@docid and docid>0

    open docid_cursor fetch next from docid_cursor into @docid,@sharetype,@seclevel,@seclevelmax,@allmanagers,@orgid,@includesub,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@orgGroupId,@sharesource,@downloadlevel

     while @@fetch_status=0 
      begin  
           set @isExistInner=0
           set @isExistOuter=0
           if @downloadlevel is null set @downloadlevel=0
	   if @allmanagers is null set @allmanagers=0
	   if @orgid  is null set @orgid =0
	   if @includesub  is null set @includesub =0
           /*得到值*/         
            if @sharetype=1   /*人力资源*/ 
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @seclevelmax=255
                    set @srcfrom=1
                    set @opuser=@userid

                    set @isExistInner=1
                end

            else if  @sharetype=2  /*分部*/            
                begin
                    set @newsharetype=2
                    set @sharecontent=@subcompanyid 
                    set @seclevel=@seclevel
                    set @seclevelmax=@seclevelmax
                    set @srcfrom=2
                    set @opuser=@subcompanyid
                    set @isExistInner=1
                end  

            else if  @sharetype=3  /*部门*/
                begin
                    set @newsharetype=3
                    set @sharecontent=@departmentid 
                    set @seclevel=@seclevel
                    set @seclevelmax=@seclevelmax
                    set @srcfrom=3
                    set @opuser=@departmentid

                    set @isExistInner=1
                end  
           else if  @sharetype=6  /*群组*/
                begin
                    set @newsharetype=6
                    set @sharecontent=@orgGroupId
                    set @seclevel=@seclevel
                    set @seclevelmax=@seclevelmax
                    set @srcfrom=6
                    set @opuser=@orgGroupId

                    set @isExistInner=1
                end 
           else if  @sharetype=5  /*所有人*/
                begin
                    set @newsharetype=5
                    set @sharecontent=1 
                    set @seclevel=@seclevel
                    set @seclevelmax=@seclevelmax
                    set @srcfrom=5
                    set @opuser=0

                    set @isExistInner=1
                end 
           else if  @sharetype=80  /*创建人本身*/
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @seclevelmax=255
                    set @srcfrom=80
                    set @opuser=@userid                    
                    set @isExistInner=1
                    
                    /*如果文档的创建者和文档的所有者如果不是同一人的话，他们的权限将保持一致*/
				    select @ownerid=ownerid, @createrid=doccreaterid  from docdetail where id=@docid    
				    if (@ownerid!=@createrid) begin
                         insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
                         values(@docid,1,@ownerid,0,255,@sharelevel,86,0,0,@downloadlevel)  
                    end                    
                end 
          else if  @sharetype=81  /*创建人直接上级*/
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid
	          select  @hasmanager=count(*)  from hrmresource a,hrmresource b     where a.id=b.managerid and b.id= @userid
                if @orgid =0
                begin
                  if (@isSysadmin!=1 and @hasmanager=1 and @allmanagers=0)    
                  begin                
	                  set @newsharetype=1
	                  /*求上级*/
	                  SELECT  @sharecontent=managerid FROM HrmResource where id=@userid
	                  set @seclevel=0
	                  set @seclevelmax=255
	                  set @srcfrom=81
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end

		   if (@isSysadmin!=1 and @hasmanager=1 and @allmanagers=1)    
                  begin                
	                  set @newsharetype=1
	                  /*求上级*/
	                  SELECT  @sharecontent=managerstr FROM HrmResource where id=@userid
	                  set @seclevel=0
	                  set @seclevelmax=255
	                  set @srcfrom=81
	                  set @opuser=@userid	         
			 insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
                         select @docid,1,Data,0,255,@sharelevel,81,@opuser,Data,@downloadlevel from SplitStr(@sharecontent,',') where Data>0
	                 set @isExistInner=0
                   end

		 end
		else if  @orgid <0
                  begin
                  if (@isSysadmin!=1  and @allmanagers=0)    
                  begin                
	                  set @newsharetype=1
	                  /*求上级多维组织中的*/
	                  SELECT  @sharecontent=managerid FROM HrmResourceVirtual where resourceid=@userid and virtualtype=@orgid
	                  set @seclevel=0
	                  set @seclevelmax=255
	                  set @srcfrom=81
	                  set @opuser=@userid
	                  insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel)
			  values(@docid,1,@sharecontent,0,255,@sharelevel,81,@opuser,@sharecontent,@downloadlevel)
	                  set @isExistInner=0
                   end

		   if (@isSysadmin!=1  and @allmanagers=1)    
                  begin                
	                  set @newsharetype=1
	                  /*求上级*/
	                  SELECT  @sharecontent=managerstr FROM HrmResourceVirtual where resourceid=@userid and virtualtype=@orgid
	                  set @seclevel=0
	                  set @seclevelmax=255
	                  set @srcfrom=81
	                  set @opuser=@userid	         
			 insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
                         select @docid,1,Data,0,255,@sharelevel,81,@opuser,Data,@downloadlevel from SplitStr(@sharecontent,',') where Data>0
	                 set @isExistInner=0
                   end

		 end
                 


		  
            end 
         else if  @sharetype=84  /*同分部*/
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid   
		 if @orgid =0
		  begin
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=2
	                  /*求分部*/                  
	                  SELECT  @temp_departmentid=departmentid  FROM HrmResource where id=@userid
	                  select @sharecontent=subcompanyid1   from  HrmDepartment where id=@temp_departmentid
	
	                  set @seclevel=@seclevel
	                  set @seclevelmax=@seclevelmax
	                  set @srcfrom=84
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
		 end
		 else if @orgid <0 
		 begin
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=2
	                  /*求分部*/                  
	               
	                  select @sharecontent=subcompanyid   from  HrmResourceVirtual where resourceid=@userid and virtualtype=@orgid
	
	                  set @seclevel=@seclevel
	                  set @seclevelmax=@seclevelmax
	                  set @srcfrom=84
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
		 end


              end 
         else if  @sharetype=85  /*同部门*/
              begin
	       if @orgid =0
		 begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid  
                  if (@isSysadmin!=1)    
                  begin 
	                  set @newsharetype=3
	                  /*求部门*/
	                  SELECT @sharecontent=departmentid  FROM HrmResource where id=@userid
	                  set @seclevel=@seclevel
	                  set @seclevelmax=@seclevelmax
	                  set @srcfrom=85
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                  end
                end
		else if @orgid <0
		 begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid  
                  if (@isSysadmin!=1)    
                  begin 
	                  set @newsharetype=3
	                  /*求部门*/
	                  SELECT @sharecontent=departmentid  FROM  HrmResourceVirtual where resourceid=@userid and virtualtype=@orgid
	                  set @seclevel=@seclevel
	                  set @seclevelmax=@seclevelmax
	                  set @srcfrom=85
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                  end
                end

              end 

       else if  @sharetype=-81  /*客户的经理*/
          begin
              set @newsharetype=1             
              select @sharecontent=manager from CRM_CustomerInfo where id=@userid /*求客户的经理*/
              set @seclevel=0
               set @seclevelmax=255
              set @srcfrom=-81
              set @opuser=@userid

              set @isExistInner=1
          end 
       else if  @sharetype=9  /*客户*/
          begin
              set @newsharetype=9             
              select @sharecontent=@crmid
              set @seclevel=0
               set @seclevelmax=255
              set @srcfrom=9
              set @opuser=@crmid

              set @isExistOuter=1
          end 

         else if  @sharetype=-80  /*客户本人*/
          begin
              set @newsharetype=9             
              select @sharecontent=@userid
              set @seclevel=0
               set @seclevelmax=255
              set @srcfrom=-80
              set @opuser=@userid

              set @isExistOuter=1
          end 
          else if  @sharetype<0 /*客户类型*/
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
                      if @seclevelmax is null set @seclevel=255
                     if @sharelevel is null set @sharelevel=0
                     if @srcfrom is null set @srcfrom=0
                     if @opuser is null set @opuser=0
                     if @sharesource is null set @sharesource=0


                    IF @rolelevel=0 /*表部门 总部,分部,部门能看*/
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(0,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    else  IF @rolelevel=1 /*表分部 总部,分部能看*/                        
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    else IF @rolelevel=2 /*表总部 总部能看*/
                    BEGIN
                      set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                      insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    set @isExistInner=0  /*不需要再在下面插入数据*/
                end   
         IF  @isExistInner=1
         BEGIN
             if @docid is null set @docid=0
             if @newsharetype is null set @newsharetype=0
             if @sharecontent is null set @sharecontent=0
             if @seclevel is null set @seclevel=0
               if @seclevelmax is null set @seclevelmax=255
             if @sharelevel is null set @sharelevel=0
             if @srcfrom is null set @srcfrom=0
             if @opuser is null set @opuser=0
             if @sharesource is null set @sharesource=0

             /*插入数据*/                         
             insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values       
             (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel)             
         END             

         IF  @isExistOuter=1 
         BEGIN
             if @docid is null set @docid=0
             if @newsharetype is null set @newsharetype=0
             if @sharecontent is null set @sharecontent=0
             if @seclevel is null set @seclevel=0
             if @seclevelmax is null set @seclevelmax=255
             if @sharelevel is null set @sharelevel=0
             if @srcfrom is null set @srcfrom=0
             if @opuser is null set @opuser=0
             if @sharesource is null set @sharesource=0

             /*插入数据*/
             insert into ShareouterDoc(sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values        
             (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel)
         END          

        /*进入下一循环*/    
        fetch next from docid_cursor into  @docid,@sharetype,@seclevel,@seclevelmax,@allmanagers,@orgid,@includesub,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@orgGroupId,@sharesource,@downloadlevel
      end 
    close docid_cursor deallocate docid_cursor	
END
GO
alter trigger Tri_I_DirAccessControlList on DirAccessControlList for insert
as
declare  @id_1         integer;
declare  @dirid_1         integer;
declare  @dirtype_1      integer;
declare  @seclevel_1     integer;
declare  @seclevelmax_1     integer;
declare  @departmentid_1      integer;
declare  @subcompanyid_1      integer;
declare  @userid_1            integer;
declare  @usertype_1        integer;
declare  @sharelevel_1       integer;
declare  @roleid_1            integer;
declare  @rolelevel_1         integer;
declare  @permissiontype_1  integer;
declare  @operationcode_1 integer;
declare  @docSecCategoryTemplateId_1 integer;
declare @sourceid_1           integer;
declare  @type_1		    integer;
declare  @content_1		    integer;
declare  @sourcetype_1        integer;
declare  @srcfrom_1        integer;
declare  @detail_insert_cursor cursor;
if EXISTS(SELECT 1 FROM inserted)  
begin
    set @detail_insert_cursor = cursor FORWARD_ONLY static for select mainid, dirid,dirtype,seclevel,seclevelmax,userid,subcompanyid,departmentid,usertype,roleid,rolelevel,operationcode,permissiontype,DocSecCategoryTemplateId from inserted
    OPEN @detail_insert_cursor 
    fetch next from @detail_insert_cursor INTO @id_1 , @dirid_1,@dirtype_1,@seclevel_1,@seclevelmax_1,@userid_1,@subcompanyid_1,@departmentid_1,@usertype_1,@roleid_1,@rolelevel_1,@operationcode_1,@permissiontype_1,@docSecCategoryTemplateId_1
    while @@FETCH_STATUS = 0 
    begin 
        begin
            set	@srcfrom_1 = @id_1;
            set	@sourceid_1= @dirid_1;
            set	@sourcetype_1= @dirtype_1;
            set	@type_1= @permissiontype_1;
            set	@sharelevel_1 = @operationcode_1;

            if @type_1=1         /*部门+安全级别*/
            	set @content_1 = @departmentid_1;
            else if @type_1=2   /*角色+安全级别+级别*/
            	set @content_1 =  convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),@rolelevel_1)));
            else if @type_1=3   /*安全级别*/
            	begin
            		set @seclevel_1 = @seclevel_1;
            		set @seclevelmax_1 = @seclevelmax_1;
            		set @content_1 = 0;
            	end
            else if @type_1=4    /*用户类型+安全级别*/
            	set  @content_1 = @usertype_1;
            else if @type_1=5    /*人力资源*/
            	begin
            		set  @content_1 = @userid_1;
            		set  @seclevel_1 = 0; 
            		set  @seclevelmax_1 = 255;
            	end
            else if @type_1=6    /*分部+安全级别*/
            	set @content_1 = @subcompanyid_1;	
            /*插入数据*/
             insert into DirAccessControlDetail
            (
            	sourceid,
            	type,
            	content,
            	seclevel,
            	seclevelmax,
            	sharelevel,
            	sourcetype,
            	srcfrom
             )values(
            	@sourceid_1,
            	@type_1,
            	@content_1,
            	@seclevel_1,
            	@seclevelmax_1,
            	@sharelevel_1,
            	@sourcetype_1,
            	@srcfrom_1
             )
             /*修正角色共享时，角色级别数据*/
             if @rolelevel_1 = 0 /*部门级别*/
               begin
                   /*增加分部级别数据*/
                   set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),1)));
                    insert into DirAccessControlDetail
            		(
            			sourceid,
            			type,
            			content,
            			seclevel,
            			seclevelmax,
            			sharelevel,
            			sourcetype,
            			srcfrom
            		 )values(
            			@sourceid_1,
            			@type_1,
            			@content_1,
            			@seclevel_1,
            			@seclevelmax_1,
            			@sharelevel_1,
            			@sourcetype_1,
            			@srcfrom_1
            		 )
            		set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),2)));
                    insert into DirAccessControlDetail
            		(
            			sourceid,
            			type,
            			content,
            			seclevel,
            			seclevelmax,
            			sharelevel,
            			sourcetype,
            			srcfrom
            		 )values(
            			@sourceid_1,
            			@type_1,
            			@content_1,
            			@seclevel_1,
            			@seclevelmax_1,
            			@sharelevel_1,
            			@sourcetype_1,
            			@srcfrom_1
            		 )
               end
            else if @rolelevel_1>0  /*分部级别*/
               begin
            /*增加总部级别数据*/
            		set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),2)));
                    insert into DirAccessControlDetail
            		(
            			sourceid,
            			type,
            			content,
            			seclevel,
            			seclevelmax,
            			sharelevel,
            			sourcetype,
            			srcfrom
            		 )values(
            			@sourceid_1,
            			@type_1,
            			@content_1,
            			@seclevel_1,
            			@seclevelmax_1,
            			@sharelevel_1,
            			@sourcetype_1,
            			@srcfrom_1
            		 )
               end
		end
		FETCH NEXT FROM @detail_insert_cursor INTO @id_1 , @dirid_1,@dirtype_1,@seclevel_1,@seclevelmax_1,@userid_1,@subcompanyid_1,@departmentid_1,@usertype_1,@roleid_1,@rolelevel_1,@operationcode_1,@permissiontype_1,@docSecCategoryTemplateId_1
	end 
	CLOSE @detail_insert_cursor 
	DEALLOCATE @detail_insert_cursor
end
GO