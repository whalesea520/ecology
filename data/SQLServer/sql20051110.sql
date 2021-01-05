declare @docid int
declare @doccreaterid int
declare @recordCount int
declare @usertype int
declare @docMax int
select @docMax=max(id) from docdetail

declare @execCount int
declare @i int
set  @execCount = @docMax/5000+1
set @i=0

WHILE @i<@execCount
begin  
    declare docid_cursor cursor for   
     select id,doccreaterid,usertype from docdetail where id>@i*5000+1 and id <(@i+1)*5000+1 order by id desc
     open docid_cursor fetch next from docid_cursor into @docid,@doccreaterid,@usertype
     while @@fetch_status=0 
      begin 
        if @usertype=1 
        begin
            /*创建者本人*/
            select @recordCount=count(id) from docshare where docid=@docid and userid=@doccreaterid and sharetype=80
            if @recordCount=0 
            begin
                  insert into docshare(docid,userid,sharetype,sharelevel,isSecDefaultShare) values (@docid,@doccreaterid,80,3,1)
            end
             /*创建者直接上级*/
            select @recordCount=count(id) from docshare where docid=@docid and userid=@doccreaterid and sharetype=81
            if @recordCount=0 
            begin
                  insert into docshare(docid,userid,sharetype,sharelevel,isSecDefaultShare) values (@docid,@doccreaterid,81,1,1)
            end

             /*创建者间接上级*/
            select @recordCount=count(id) from docshare where docid=@docid and userid=@doccreaterid and sharetype=82
            if @recordCount=0 
            begin
                  insert into docshare(docid,userid,sharetype,sharelevel,isSecDefaultShare) values (@docid,@doccreaterid,82,1,1)
            end      
        end    
        else 
        begin
            /*外部用户创建者本人*/
            select @recordCount=count(id) from docshare where docid=@docid and userid=@doccreaterid and sharetype=-80
            if @recordCount=0 
            begin
                  insert into docshare(docid,userid,sharetype,sharelevel,isSecDefaultShare) values (@docid,@doccreaterid,-80,3,1)
            end
             /*外部用户创建人经理*/
            select @recordCount=count(id) from docshare where docid=@docid and userid=@doccreaterid and sharetype=-81
            if @recordCount=0 
            begin
                  insert into docshare(docid,userid,sharetype,sharelevel,isSecDefaultShare) values (@docid,@doccreaterid,-81,1,1)
            end

             /*外部用户创建人经理的所有上级*/
            select @recordCount=count(id) from docshare where docid=@docid and userid=@doccreaterid and sharetype=-82
            if @recordCount=0 
            begin
                  insert into docshare(docid,userid,sharetype,sharelevel,isSecDefaultShare) values (@docid,@doccreaterid,-82,1,1)
            end   
        end 
        fetch next from docid_cursor into @docid,@doccreaterid,@usertype
      end 
    close docid_cursor deallocate docid_cursor    
    set @i=@i+1    
end

go