
Alter  PROCEDURE DocShareDetail_SetByDoc (
@docid_1  int ,
@createrid_2  int ,
@owenerid_3  int , 
@usertype_4  int ,
@replydocid_5  int ,
@departmentid_6  int ,
@subcompanyid_7  int , 
@managerid_8 int ,
@considermanager_9 int ,
@flag int output, 
@msg varchar(80) output )
AS
Declare 
@recordercount int ,
@allmanagerid varchar(255), 
@tempuserid int, 
@tempsharelevel int ,
@tempsharelevelold int ,
@tempsharetype int ,
@sepindex int,
@crmManagerId int,
@crmManagerUpIds varchar(100),
@hrmManager int,
@hrmJmangers varchar(50),
@hrmallmanagerid varchar(255),
@tempseclevel int
/* 定义临时表变量 */
Declare @temptablevalue  table(userid int,usertype int,sharelevel int)  
/*
  对于内部用户:
  去除了以前对于文档创建者和所有者默认为编辑权限的做法.并且去除了其全部上级默认具有查看权限的控制
  1.文档的创建者具有的权限根据 DocShare 表中共享类型为:80的 sharelevel(共享级别来确定)
  2.如果创建者和文档所有者是同一个人的话,只需设置创建者的权限,不需设置所有者的权限
  3.如果创建者和文档所有者不是同一个人的话,文档创建者按相关的权限处理,文档的所有者默认的权限应为:完全控制权限 
  4.当碰到两个地方对同一文档的同一个人赋权的时候,采取按大权限的原则
  5.对于回复文档,应当是其默认权限继承被回复文档的权限,但可以对其权限进行进一步的修改
  
   在以前的设置中文档的创建者和所有者具有编辑的权限
   以前的回复文档,不是这样,现在新的回复文档将会这样
   80:创建人本人 81:创建人直接上级   82:创建人间接上级   83:创建人下属   84:创建人同分部成员   85:创建人同部门成员
   -80:外部用户创建人本人   -81:外部用户创建人经理     -82:外部用户创建人经理的上级
*/    
if (@usertype_4 <>1) /*对于外部用户的操作 -80 ~ -82*/
 begin
         declare shareuserid_cursor cursor for select  sharetype,sharelevel,userid from  docshare  where docid=@docid_1 and  sharetype between  -82 and -80
         open shareuserid_cursor fetch next from shareuserid_cursor into @tempsharetype, @tempsharelevel,@tempuserid 
         while @@fetch_status=0 
         begin
           if (@tempsharetype=-80)   /*外部用户创建人本人*/
            begin
                if (@tempsharelevel!=0) 
                    begin
                        insert into @temptablevalue values (@tempuserid,2, @tempsharelevel)
                        if @createrid_2!=@owenerid_3  /*如果文档所有者和文档创建者不是一个人 则文档所有者默认为完全控制权限*/
                        begin
                            insert into @temptablevalue values (@owenerid_3,2, @tempsharelevel) 
                        end
                    end                  
            end
            else if (@tempsharetype=-81)  /*外部用户创建人经理*/
            begin 
                 select @crmManagerId=manager from CRM_CustomerInfo  where id=@tempuserid
                 
                     if (@tempsharelevel!=0) 
                        insert into @temptablevalue(userid,usertype,sharelevel) values (@crmManagerId,1, @tempsharelevel)          
            end   
            else if (@tempsharetype=-82)   /*外部用户创建人经理的所有上级*/
            begin        
                select @crmManagerId=manager from CRM_CustomerInfo  where id=@tempuserid
                select @crmManagerUpIds=managerstr+'0' from  hrmresource where id =@crmManagerId
                select @sepindex = CHARINDEX(',',@crmManagerUpIds)
                while  @sepindex != 0 
                begin 
                    set @tempuserid = convert(int,SUBSTRING(@crmManagerUpIds,1,@sepindex-1)) 
                    set @crmManagerUpIds = SUBSTRING(@crmManagerUpIds,@sepindex+1,LEN(@crmManagerUpIds)-@sepindex)
                    set @sepindex = CHARINDEX(',',@crmManagerUpIds)  
                    
                    if @tempsharelevel != 0 
                        insert into @temptablevalue(userid,usertype,sharelevel) values(@tempuserid,1,@tempsharelevel) 
                end 
            end  
            fetch next from shareuserid_cursor into @tempsharetype, @tempsharelevel,@tempuserid
         end
         close shareuserid_cursor 
         deallocate shareuserid_cursor
 end
else   /*对于内部用户的操作 +80 ~ +85*/
 begin
        declare shareuserid_cursor cursor for select  sharetype,sharelevel,userid,seclevel from  docshare  where docid=@docid_1 and  sharetype  between  80 and 85
        open shareuserid_cursor fetch next from shareuserid_cursor into @tempsharetype, @tempsharelevel,@tempuserid,@tempseclevel 
         while @@fetch_status=0 
         begin           
            if (@tempsharetype=80)   /*内部用户创建人本人*/
            begin
                if (@tempsharelevel!=0)
                begin       
                   set @tempsharelevelold=0
                   select @tempsharelevelold=sharelevel from @temptablevalue where userid=@tempuserid   and usertype=1   
                   if (@tempsharelevelold=0) /*插入数据*/
                      insert into  @temptablevalue(userid,usertype,sharelevel) values(@tempuserid,1,@tempsharelevel) 
                   else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
                      update @temptablevalue  set sharelevel=@tempsharelevel where userid=@tempuserid  and usertype=1   

                   if @createrid_2!=@owenerid_3  /*如果文档所有者和文档创建者不是一个人 则文档所有者默认为完全控制权限*/
                     begin
                         set @tempsharelevelold=0
                         select @tempsharelevelold=sharelevel from @temptablevalue where userid=@owenerid_3   and usertype=1   
                         if (@tempsharelevelold=0) /*插入数据*/
                            insert into  @temptablevalue(userid,usertype,sharelevel) values(@owenerid_3,1,@tempsharelevel) 
                         else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
                            update @temptablevalue  set sharelevel=@tempsharelevel where userid=@owenerid_3  and usertype=1
                     end
                end
            end
            else if (@tempsharetype=81)   /*内部用户创建人直接上级*/  
            begin               
                if (@tempsharelevel!=0)
                begin   
                    select @hrmManager=managerid from hrmresource where id=@tempuserid                                      
                    if @hrmManager is not null                   
                    begin
                       set @tempsharelevelold=0
                       select @tempsharelevelold=sharelevel from @temptablevalue where userid=@hrmManager  and usertype=1   
                       if (@tempsharelevelold=0) /*插入数据*/
                          insert into  @temptablevalue(userid,usertype,sharelevel) values(@hrmManager,1,@tempsharelevel) 
                       else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
                          update @temptablevalue  set sharelevel=@tempsharelevel where userid=@hrmManager 
                    end
                end            
            end
            else if (@tempsharetype=82)   /*内部用户创建人本人间接上级*/
            begin
                if (@tempsharelevel!=0)
                begin   
                    declare @hrmallmanagerid_re varchar(255),@temppos int,@tempHrmManager int
                    select   @hrmallmanagerid=managerstr  from hrmresource where id=@tempuserid
                    set @hrmallmanagerid_re =  REVERSE(@hrmallmanagerid) 
                    set @temppos = CHARINDEX( ',',@hrmallmanagerid_re) 
                    set @temppos = CHARINDEX(',', @hrmallmanagerid_re, @temppos+1)
                    if  @temppos <>0 
                        set @hrmallmanagerid_re = SUBSTRING(@hrmallmanagerid_re,@temppos,len(@hrmallmanagerid_re)) /*@hrmJmangers为间拉上级*/
                    set @hrmJmangers = REVERSE(@hrmallmanagerid_re)
                     
                    select @sepindex = CHARINDEX(',',@hrmJmangers)
                    while  (@sepindex != 0)
                    begin 
                         set @tempHrmManager = convert(int,SUBSTRING(@hrmJmangers,1,@sepindex-1)) 
                         set @hrmJmangers = SUBSTRING(@hrmJmangers,@sepindex+1,LEN(@hrmJmangers)-@sepindex)                     
                         set @sepindex = CHARINDEX(',',@hrmJmangers)  

                         set @tempsharelevelold=0
                         select @tempsharelevelold=sharelevel from @temptablevalue where userid=@tempHrmManager  and usertype=1   
                         if (@tempsharelevelold=0) /*插入数据*/
                            insert into  @temptablevalue(userid,usertype,sharelevel) values(@tempHrmManager,1,@tempsharelevel) 
                         else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
                            update @temptablevalue  set sharelevel=@tempsharelevel where userid=@tempHrmManager and usertype=1 
                    end   
                end
             end
             else if (@tempsharetype=83)   /*内部用户创建人下属*/
             begin
                if (@tempsharelevel!=0)
                begin
                    declare @tempDownUserId int
                    declare temp_cursor cursor for select id from  hrmresource where ','+managerstr like '%,'+convert(char,@tempuserid)+',%' and seclevel>=@tempseclevel and loginid is not null and loginid !=''
                    open temp_cursor fetch next from temp_cursor into @tempDownUserId 
                    while @@fetch_status=0 
                    begin
                         set @tempsharelevelold=0
                         select @tempsharelevelold=sharelevel from @temptablevalue where userid=@tempDownUserId and usertype=1   
                         if (@tempsharelevelold=0) /*插入数据*/
                            insert into  @temptablevalue(userid,usertype,sharelevel) values(@tempDownUserId,1,@tempsharelevel) 
                         else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
                            update @temptablevalue  set sharelevel=@tempsharelevel where userid=@tempDownUserId  and usertype=1 
                         fetch next from temp_cursor into @tempDownUserId 
                    end
                    close temp_cursor 
                    deallocate temp_cursor
                end
            end
            else if (@tempsharetype=84)   /*内部用户创建人同分部*/
            begin
                if (@tempsharelevel!=0)
                    begin
                    declare @subCompId int,@sameSubUserId int
                    select @subCompId=subcompanyid1  from  hrmresource where id=@tempuserid
                    declare temp_cursor cursor for select id from  hrmresource where subcompanyid1=@subCompId and seclevel>=@tempseclevel   and loginid is not null and loginid !=''
                    open temp_cursor fetch next from temp_cursor into @sameSubUserId 
                    while @@fetch_status=0 
                    begin
                         set @tempsharelevelold=0
                         select @tempsharelevelold=sharelevel from @temptablevalue where userid=@sameSubUserId  and usertype=1   
                         if (@tempsharelevelold=0) /*插入数据*/
                            insert into  @temptablevalue(userid,usertype,sharelevel) values(@sameSubUserId,1,@tempsharelevel) 
                         else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
                            update @temptablevalue  set sharelevel=@tempsharelevel where userid=@sameSubUserId and usertype=1 
                    fetch next from temp_cursor into @sameSubUserId 
                    end
                    close temp_cursor 
                    deallocate temp_cursor
               end
           end
           else if (@tempsharetype=85)   /*内部用户创建人同部门*/
           begin
                if (@tempsharelevel!=0)
                    begin
                    declare @departmentId int,@sameDepartUserId int
                    select @departmentId=departmentid  from  hrmresource where id=@tempuserid
                    declare temp_cursor cursor for select id from  hrmresource where departmentid=@departmentId and seclevel>=@tempseclevel  and loginid is not null and loginid !=''
	                open temp_cursor fetch next from temp_cursor into @sameDepartUserId 
                    while @@fetch_status=0 
                    begin
                         set @tempsharelevelold=0
                         select @tempsharelevelold=sharelevel from @temptablevalue where userid=@sameDepartUserId  and usertype=1   
                         if (@tempsharelevelold=0) /*插入数据*/
                            insert into  @temptablevalue(userid,usertype,sharelevel) values(@sameDepartUserId,1,@tempsharelevel) 
                         else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
                            update @temptablevalue  set sharelevel=@tempsharelevel where userid=@sameDepartUserId and usertype=1 


                    fetch next from temp_cursor into @sameDepartUserId 
                    end
                    close temp_cursor 
                    deallocate temp_cursor
                 end
             end
            fetch next from shareuserid_cursor into  @tempsharetype, @tempsharelevel,@tempuserid,@tempseclevel
         end
         close shareuserid_cursor 
         deallocate shareuserid_cursor
end

/* 文档共享信息 (内部用户) 不涉及角色部分 */ 
 declare shareuserid_cursor cursor for select distinct t1.id , t2.sharelevel from HrmResource t1 ,  DocShare  t2 where  t1.loginid is not null and t1.loginid <> '' and t2.docid = @docid_1 and ( (t2.foralluser=1 and t2.seclevel<=t1.seclevel)  or ( t2.userid= t1.id ) or (t2.departmentid=t1.departmentid and t2.seclevel<=t1.seclevel)) and t2.sharetype not in(-80,-81,-82,80,81,82,83,84,85)  and t1.loginid is not null and t1.loginid !=''
 
 open shareuserid_cursor fetch next from shareuserid_cursor into @tempuserid, @tempsharelevel
 while @@fetch_status=0 
 begin 

 set @tempsharelevelold=0
 select @tempsharelevelold=sharelevel from @temptablevalue where userid=@tempuserid  and usertype=1   
 if (@tempsharelevelold=0) /*插入数据*/
    insert into @temptablevalue(userid,usertype,sharelevel) values(@tempuserid,1,@tempsharelevel) 
 else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
    update @temptablevalue set sharelevel = @tempsharelevel where userid=@tempuserid and usertype = 1 

    fetch next from shareuserid_cursor into @tempuserid, @tempsharelevel 
end
close shareuserid_cursor 
deallocate shareuserid_cursor  

    
/* 文档共享信息 (内部用户) 涉及角色部分 */ 
declare shareuserid_cursor cursor for select distinct t1.id , t2.sharelevel from HrmResource t1 ,  DocShare  t2,  HrmRoleMembers  t3 where  t1.loginid is not null and t1.loginid <> '' and t2.docid = @docid_1 and (  t3.resourceid=t1.id and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and ( (t3.rolelevel=2) or (t3.rolelevel=0  and t1.departmentid=@departmentid_6) or (t3.rolelevel=1 and t1.subcompanyid1=@subcompanyid_7) ) ) and t2.sharetype not in(-80,-81,-82,80,81,82,83,84,85) and t1.loginid is not null and t1.loginid !=''
open shareuserid_cursor fetch next from shareuserid_cursor into @tempuserid, @tempsharelevel 
while    @@fetch_status=0
begin

     set @tempsharelevelold=0
     select @tempsharelevelold=sharelevel from @temptablevalue where userid=@tempuserid  and usertype=1   
     if (@tempsharelevelold=0) /*插入数据*/
        insert into @temptablevalue(userid,usertype,sharelevel) values(@tempuserid,1,@tempsharelevel) 
     else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
        update @temptablevalue set sharelevel = @tempsharelevel where userid=@tempuserid and usertype = 1 

    fetch next from shareuserid_cursor into @tempuserid, @tempsharelevel
end
close shareuserid_cursor 
deallocate shareuserid_cursor  

/* 文档共享信息 外部用户 ( 类型 ) */
declare shareuserid_cursor cursor for select distinct sharetype , seclevel, sharelevel from DocShare where sharetype < 0 and docid = @docid_1 and sharetype not in(-80,-81,-82,80,81,82,83,84,85)
open shareuserid_cursor fetch next from shareuserid_cursor into @tempsharetype , @tempuserid, @tempsharelevel while @@fetch_status=0 
begin 

     set @tempsharelevelold=0
     select @tempsharelevelold=sharelevel from @temptablevalue where userid=@tempuserid and usertype = @tempsharetype   
     if (@tempsharelevelold=0) /*插入数据*/
        insert into @temptablevalue(userid,usertype,sharelevel) values(@tempuserid,@tempsharetype,@tempsharelevel)
     else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
        update @temptablevalue set sharelevel = @tempsharelevel where userid=@tempuserid and usertype = @tempuserid    

     fetch next from shareuserid_cursor into @tempsharetype , @tempuserid, @tempsharelevel   
end
close shareuserid_cursor 
deallocate shareuserid_cursor


/* 文档共享信息 外部用户 ( 用户id ) */ 
declare shareuserid_cursor cursor for select distinct crmid , sharelevel from DocShare where crmid <> 0 and sharetype = '9' and docid = @docid_1 and sharetype not in(-80,-81,-82,80,81,82,83,84,85)
open shareuserid_cursor fetch next from shareuserid_cursor into @tempuserid, @tempsharelevel
while @@fetch_status=0 
begin 

    
    set @tempsharelevelold=0
     select @tempsharelevelold=sharelevel from @temptablevalue where userid=@tempuserid and usertype = 9   
     if (@tempsharelevelold=0) /*插入数据*/
        insert into @temptablevalue(userid,usertype,sharelevel) values(@tempuserid,9,@tempsharelevel)
     else if (@tempsharelevel>@tempsharelevelold) /*更新数据*/
       update @temptablevalue set sharelevel = @tempsharelevel where userid=@tempuserid and usertype = 9   

    fetch next from shareuserid_cursor into @tempuserid, @tempsharelevel 
end
close shareuserid_cursor 
deallocate shareuserid_cursor


/* 将临时表中的数据写入共享表 */ 
delete docsharedetail where docid = @docid_1
insert into docsharedetail (docid,userid,usertype,sharelevel) select @docid_1 , userid,usertype,sharelevel from @temptablevalue
GO


UPDATE license set cversion = '3.150'
go