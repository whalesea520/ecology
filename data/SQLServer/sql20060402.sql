create table ShareRedundancy (
      srcId int not null 
)
GO


create table shareinnerdoc (
      id int IDENTITY (1, 1) NOT NULL ,
      sourceid int not null ,
      type int not null,  
      content int not null,
      seclevel int not null,
      sharelevel int not null,
      srcfrom int  not null,
      opuser   int  not null,
      sharesource int,
      CONSTRAINT PK_shareinnerdoc PRIMARY KEY NONCLUSTERED (id ASC) 
)
GO




create table ShareouterDoc (
      id int IDENTITY (1, 1) NOT NULL,
      sourceid int not null ,
      type int not null,  
      content int not null,
      seclevel int not null,
      sharelevel int not null,
      srcfrom int  not null,
      opuser   int  not null,
      sharesource int ,
      CONSTRAINT PK_shareouterdoc PRIMARY KEY NONCLUSTERED (id ASC)
) 
GO 



ALTER TABLE DocSecCategoryShare add  crmid int
GO

DROP PROC  DocShareDetail_SetByDoc
GO
DROP PROC  Doc_setDocShareByHrm
GO
DROP PROC  Doc_setDocShareBYHrmAndDoc
GO
DROP PROC  DocShareDetail_SByResourceId
GO
DROP PROC  DocShareDetail_SelectByDocId
GO

create PROCEDURE Share_forDoc
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
BEGIN
    
    DELETE ShareinnerDoc  WHERE  sourceid=@docid
    DELETE ShareouterDoc  WHERE  sourceid=@docid
    

    
    declare docid_cursor cursor for   
    select docid,sharetype,seclevel,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,sharesource 
    from docshare where docid=@docid and docid>0

    open docid_cursor fetch next from docid_cursor into @docid,@sharetype,@seclevel,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@sharesource

     while @@fetch_status=0 
      begin  
           set @isExistInner=0
           set @isExistOuter=0
                
            if @sharetype=1   
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @srcfrom=1
                    set @opuser=@userid

                    set @isExistInner=1
                end

            else if  @sharetype=2            
                begin
                    set @newsharetype=2
                    set @sharecontent=@subcompanyid 
                    set @seclevel=@seclevel
                    set @srcfrom=2
                    set @opuser=@subcompanyid
                    set @isExistInner=1
                end  

            else if  @sharetype=3  
                begin
                    set @newsharetype=3
                    set @sharecontent=@departmentid 
                    set @seclevel=@seclevel
                    set @srcfrom=3
                    set @opuser=@departmentid

                    set @isExistInner=1
                end  
           else if  @sharetype=5  
                begin
                    set @newsharetype=5
                    set @sharecontent=1 
                    set @seclevel=@seclevel
                    set @srcfrom=5
                    set @opuser=0

                    set @isExistInner=1
                end 
           else if  @sharetype=80 
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @srcfrom=80
                    set @opuser=@userid                    
                    set @isExistInner=1
                    
                  
				    select @ownerid=ownerid, @createrid=doccreaterid  from docdetail where id=@docid    
				    if (@ownerid!=@createrid) begin
                         insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) 
                         values(@docid,1,@ownerid,0,@sharelevel,86,0,0)  
                    end                    
                end 
          else if  @sharetype=81  
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid
                  if (@isSysadmin!=1)  
                  begin                
	                  set @newsharetype=1
	                  
	                  SELECT  @sharecontent=managerid FROM HrmResource where id=@userid
	                  set @seclevel=0
	                  set @srcfrom=81
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
              end 
         else if  @sharetype=84  
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid                    
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=2
	                              
	                  SELECT  @temp_departmentid=departmentid  FROM HrmResource where id=@userid
	                  select @sharecontent=subcompanyid1   from  HrmDepartment where id=@temp_departmentid
	
	                  set @seclevel=@seclevel
	                  set @srcfrom=84
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
              end 
         else if  @sharetype=85 
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid  
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=3
	                 
	                  SELECT @sharecontent=departmentid  FROM HrmResource where id=@userid
	                  set @seclevel=@seclevel
	                  set @srcfrom=85
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                  end
              end 

       else if  @sharetype=-81  
          begin
              set @newsharetype=1             
              select @sharecontent=manager from CRM_CustomerInfo where id=@userid 
              set @seclevel=0
              set @srcfrom=-81
              set @opuser=@userid

              set @isExistInner=1
          end 
       else if  @sharetype=9  
          begin
              set @newsharetype=9             
              select @sharecontent=@crmid
              set @seclevel=0
              set @srcfrom=9
              set @opuser=@crmid

              set @isExistOuter=1
          end 

         else if  @sharetype=-80  
          begin
              set @newsharetype=9             
              select @sharecontent=@userid
              set @seclevel=0
              set @srcfrom=-80
              set @opuser=@userid

              set @isExistOuter=1
          end 
          else if  @sharetype<0 and @sharetype>-80 
          begin
              set @newsharetype=10             
              select @sharecontent=STR(@sharetype*-1)
              set @srcfrom=10
              set @opuser=@sharetype

              set @isExistOuter=1
          end 
          else if  @sharetype=4  
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


                    IF @rolelevel=0 
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(0,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                    END
                    else  IF @rolelevel=1                      
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                    END
                    else IF @rolelevel=2 
                    BEGIN
                      set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                      insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                    END
                    set @isExistInner=0  
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
                      
             insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values       
             (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource)             
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

             insert into ShareouterDoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values        
             (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource)
         END          

        fetch next from docid_cursor into  @docid,@sharetype,@seclevel,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@sharesource
      end 
    close docid_cursor deallocate docid_cursor	
END 
GO


create PROCEDURE Share_forDoc_init
(
    @docid int )
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
BEGIN
    

    

    
    declare docid_cursor cursor for   
    select docid,sharetype,seclevel,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,sharesource 
    from docshare where docid=@docid and docid>0

    open docid_cursor fetch next from docid_cursor into @docid,@sharetype,@seclevel,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@sharesource

     while @@fetch_status=0 
      begin  
           set @isExistInner=0
           set @isExistOuter=0
                
            if @sharetype=1   
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @srcfrom=1
                    set @opuser=@userid

                    set @isExistInner=1
                end

            else if  @sharetype=2            
                begin
                    set @newsharetype=2
                    set @sharecontent=@subcompanyid 
                    set @seclevel=@seclevel
                    set @srcfrom=2
                    set @opuser=@subcompanyid
                    set @isExistInner=1
                end  

            else if  @sharetype=3  
                begin
                    set @newsharetype=3
                    set @sharecontent=@departmentid 
                    set @seclevel=@seclevel
                    set @srcfrom=3
                    set @opuser=@departmentid

                    set @isExistInner=1
                end  
           else if  @sharetype=5  
                begin
                    set @newsharetype=5
                    set @sharecontent=1 
                    set @seclevel=@seclevel
                    set @srcfrom=5
                    set @opuser=0

                    set @isExistInner=1
                end 
           else if  @sharetype=80 
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @srcfrom=80
                    set @opuser=@userid                    
                    set @isExistInner=1
                    
                  
				    select @ownerid=ownerid, @createrid=doccreaterid  from docdetail where id=@docid    
				    if (@ownerid!=@createrid) begin
                         insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) 
                         values(@docid,1,@ownerid,0,@sharelevel,86,0,0)  
                    end                    
                end 
          else if  @sharetype=81  
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid
                  if (@isSysadmin!=1)  
                  begin                
	                  set @newsharetype=1
	                  
	                  SELECT  @sharecontent=managerid FROM HrmResource where id=@userid
	                  set @seclevel=0
	                  set @srcfrom=81
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
              end 
         else if  @sharetype=84  
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid                    
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=2
	                              
	                  SELECT  @temp_departmentid=departmentid  FROM HrmResource where id=@userid
	                  select @sharecontent=subcompanyid1   from  HrmDepartment where id=@temp_departmentid
	
	                  set @seclevel=@seclevel
	                  set @srcfrom=84
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
              end 
         else if  @sharetype=85 
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid  
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=3
	                 
	                  SELECT @sharecontent=departmentid  FROM HrmResource where id=@userid
	                  set @seclevel=@seclevel
	                  set @srcfrom=85
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                  end
              end 

       else if  @sharetype=-81  
          begin
              set @newsharetype=1             
              select @sharecontent=manager from CRM_CustomerInfo where id=@userid 
              set @seclevel=0
              set @srcfrom=-81
              set @opuser=@userid

              set @isExistInner=1
          end 
       else if  @sharetype=9  
          begin
              set @newsharetype=9             
              select @sharecontent=@crmid
              set @seclevel=0
              set @srcfrom=9
              set @opuser=@crmid

              set @isExistOuter=1
          end 

         else if  @sharetype=-80  
          begin
              set @newsharetype=9             
              select @sharecontent=@userid
              set @seclevel=0
              set @srcfrom=-80
              set @opuser=@userid

              set @isExistOuter=1
          end 
          else if  @sharetype<0 and @sharetype>-80 
          begin
              set @newsharetype=10             
              select @sharecontent=STR(@sharetype*-1)
              set @srcfrom=10
              set @opuser=@sharetype

              set @isExistOuter=1
          end 
          else if  @sharetype=4  
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


                    IF @rolelevel=0 
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(0,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                    END
                    else  IF @rolelevel=1                      
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                    END
                    else IF @rolelevel=2 
                    BEGIN
                      set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                      insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource )     
                    END
                    set @isExistInner=0  
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
                      
             insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values       
             (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource)             
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

             insert into ShareouterDoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values        
             (@docid,@newsharetype,@sharecontent,@seclevel,@sharelevel,@srcfrom,@opuser,@sharesource)
         END          

        fetch next from docid_cursor into  @docid,@sharetype,@seclevel,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@sharesource
      end 
    close docid_cursor deallocate docid_cursor	
END 
GO







declare @docMax int
declare @i int
declare @pagesize int
declare @pagenum int
declare @docid int
set @i=1
set @pagesize=500
select  @docMax=max(id) from docdetail
set @pagenum=@docMax/@pagesize
if @pagenum=0  set @pagenum=1 

WHILE @i<=@pagenum+1
begin 
	declare initdocid_cursor cursor for select id from docdetail where id>=(@i-1)*@pagesize and id<@i*@pagesize 
	
        open initdocid_cursor fetch next from initdocid_cursor into @docid
	while @@fetch_status=0 
	begin 
		exec Share_forDoc_init @docid   	
		fetch next from initdocid_cursor into @docid
	end 
	close initdocid_cursor 
	deallocate initdocid_cursor 

	set @i=@i+1
end  


go

delete from ShareinnerDoc where ShareinnerDoc.id<(select max(b.id) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                and ShareinnerDoc.sharelevel=b.sharelevel) and ShareinnerDoc.type=1
go

delete from ShareinnerDoc where ShareinnerDoc.sharelevel<(select max(b.sharelevel) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                ) and ShareinnerDoc.type=1
go

delete from ShareinnerDoc where ShareinnerDoc.id<(select max(b.id) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                and ShareinnerDoc.sharelevel=b.sharelevel) and ShareinnerDoc.type!=1
go

delete from ShareinnerDoc where ShareinnerDoc.sharelevel<(select max(b.sharelevel) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                ) and ShareinnerDoc.type!=1
go


delete from ShareouterDoc where ShareouterDoc.id<(select max(b.id) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                and ShareouterDoc.sharelevel=b.sharelevel) and ShareouterDoc.type=9
go

delete from ShareouterDoc where ShareouterDoc.sharelevel<(select max(b.sharelevel) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                ) and ShareouterDoc.type=9
go

delete from ShareouterDoc where ShareouterDoc.id<(select max(b.id) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                and ShareouterDoc.sharelevel=b.sharelevel) and ShareouterDoc.type!=10
go

delete from ShareouterDoc where ShareouterDoc.sharelevel<(select max(b.sharelevel) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                ) and ShareouterDoc.type!=10
go


delete from ShareinnerDoc where (sourceid<=0 or content<=0)
Go
delete from ShareouterDoc where (sourceid<=0 or content<=0)
Go 
delete from docdetail where (id<=0)
Go 
delete from docshare  where (docid<=0)
Go 

create clustered index shareIndexDoc on shareinnerdoc (type, content,seclevel)
GO
create  index dshareIndexDoc_sourceid on shareinnerdoc (sourceid desc)
GO
create clustered index shareoutIndexDoc on ShareouterDoc (type, content,seclevel)
GO
create  index shareoutIndexDoc_sourceid on ShareouterDoc (sourceid desc)
GO

ALTER TRIGGER Tri_Update_HrmRoleMembersShare ON HrmRoleMembers WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE
AS
Declare @roleid_1 int,
        @resourceid_1 int,
        @oldrolelevel_1 char(1),
        @oldroleid_1 int,
        @oldresourceid_1 int,
        @rolelevel_1 char(1),
        @docid_1	 int,
	    @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,
        @sharelevel_1  int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @seclevel_1	 int,
        @countrec      int,
        @countdelete   int,
        @countinsert   int,
        @contractid_1	 int, 
        @contractroleid_1 int ,   
        @sharelevel_Temp int,   
	@workPlanId_1 int	

        


select @countdelete = count(*) from deleted
select @countinsert = count(*) from inserted

select @oldrolelevel_1 = rolelevel, @oldroleid_1 = roleid, @oldresourceid_1 = resourceid from deleted

if @countinsert > 0 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from inserted
else 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from deleted

if (@countdelete > 0) begin
    select @seclevel_1 = seclevel from hrmresource where id = @oldresourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_DUserP_RoleChange @oldresourceid_1, @oldroleid_1, @oldrolelevel_1, @seclevel_1
    end
end
if (@countinsert > 0) begin
    select @seclevel_1 = seclevel from hrmresource where id = @resourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_GUserP_RoleChange @resourceid_1, @roleid_1, @rolelevel_1, @seclevel_1
    end
end

if ( @countinsert >0 and ( @countdelete = 0 or @rolelevel_1  > @oldrolelevel_1 ) )     
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    if @rolelevel_1 = '2'      
    begin 

	

	

	declare sharecrmid_cursor cursor for
        select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)		
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid=@crmid_1 and userid = @resourceid_1 and usertype = 1   
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

            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor



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
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1     
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor



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
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1     
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor

     
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 
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

	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE roleId = @roleid_1 AND roleLevel <= @rolelevel_1 AND securityLevel <= @seclevel_1 
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1    
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor


    end
    else if @rolelevel_1 = '1'         
    begin

	


       declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1     
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
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor


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
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1     
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor


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
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1     
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor



        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 
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

	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = @roleid_1 AND t2.roleLevel <= @rolelevel_1 AND t2.securityLevel <= @seclevel_1 AND t1.subcompanyId = @subcompanyid_1
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1     
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor
	 


    end
    else if @rolelevel_1 = '0'          
    begin

    
	

	declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = @departmentid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1    
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

            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor


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
                update PrjShareDetail set sharelevel = 2 where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1     
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	

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
                update CptShareDetail set sharelevel = 2 where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1     
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 
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

	 
	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = @roleid_1 AND t2.roleLevel <= @rolelevel_1 AND t2.securityLevel <= @seclevel_1 AND t1.deptId = @departmentid_1
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1    
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor
	
    end
end
else if ( @countdelete > 0 and ( @countinsert = 0 or @rolelevel_1  < @oldrolelevel_1 ) ) 
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0
	
  

    Declare @temptablevalue  table(docid int,sharelevel int)

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
            update @temptablevalue set sharelevel = 2 where docid=@docid_1    
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
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
            update @temptablevalue set sharelevel = 2 where docid=@docid_1    
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor


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
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid = @departmentid_1 and t2.seclevel<=@seclevel_1)  )
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
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department = @departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
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
        @oldmanagerstr_1    varchar(200),
        @managerstr_1    varchar(200) ,
        @contractid_1    int, 
        @contractroleid_1 int ,   
        @sharelevel_Temp int,   
        @workPlanId_1 int   
       


select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel , 
       @oldmanagerstr_1 = managerstr from deleted
select @resourceid_1 = id , @departmentid_1 = departmentid, @subcompanyid_1 = subcompanyid1 ,  
       @seclevel_1 = seclevel , @managerstr_1 = managerstr from inserted

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

       
if ( @countdelete > 0 and @managerstr_1 <> @oldmanagerstr_1 )  
begin
    if ( @managerstr_1 is not null and len(@managerstr_1) > 1 )  
    begin

        set @managerstr_1 = ',' + @managerstr_1

    update shareinnerdoc set content=@managerstr_1 where srcfrom=81 and opuser=@resourceid_1    
    
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

Create  TRIGGER Tri_CRM_CustomerInfoShare ON CRM_CustomerInfo WITH ENCRYPTION
FOR UPDATE
AS
Declare 
	@crmid int,
        @oldmanagerstr_1 varchar(200),
        @managerstr_1 varchar(200)       


select  @oldmanagerstr_1 = manager from deleted
select @managerstr_1 = manager from inserted
   
if (  @managerstr_1 <> @oldmanagerstr_1 ) 
begin   
    begin
    	update shareouterdoc set content=@managerstr_1 where srcfrom=-81 and opuser=@crmid 
    end          
end   

GO

Alter PROCEDURE DocSecCategoryShare_Insert (
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
@flag	int output, 
@msg	varchar(80)	output
) 
as 
insert into DocSecCategoryShare 
(seccategoryid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid )
values (@secid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser,@crmid) 

GO

Alter PROCEDURE DocShareDetail_DeleteByDocId (
@docid_1 	int ,
@flag	int	output,
@msg	varchar(80)	output
)  AS 
DELETE shareinnerdoc  WHERE (sourceid=@docid_1)  
GO

Alter  PROCEDURE PDocShare_SetById (
	@docid_1  int , 
	@flag int output,
	@msg varchar(80) output 
	)
AS
    Declare @doccreaterid int ,
            @hrmid int,
            @sharelevel int,
            @all_cursor cursor

  
    delete shareinnerdoc where sourceid = @docid_1

 
    select @doccreaterid = doccreaterid from docdetail where id =  @docid_1
    

    exec Share_forDoc @docid_1,'',''   
GO

