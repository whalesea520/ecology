Alter FUNCTION GetDocShareDetailTable  (@userid varchar(10) ,@usertype  varchar(10))
RETURNS @DocShareDetail  TABLE (sourceid int , sharelevel int)
AS
BEGIN  
   Declare @seclevel varchar(10),@departmentid varchar(10),@subcompanyid varchar(10),@type varchar(10)
   if @usertype='1'
   begin
      select @seclevel=seclevel,@departmentid=departmentid,@subcompanyid=subcompanyid1 from hrmresource where id=@userid   
      begin
        if @userid='1' 
            insert @DocShareDetail SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareinnerdoc where 
            (type=1 and content=@userid) or (  type=4 and content in 
            (select convert(VARCHAR(10),roleid)+CONVERT(VARCHAR(10),rolelevel) from hrmrolemembers where resourceid=@userid) and seclevel<=@seclevel) 
            GROUP BY sourceid
        else         
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

update HtmlLabelIndex set indexdesc='回复文档的数量(包含回复自己的)' where id=18491
GO
update HtmlLabelIndex set indexdesc='回复文档的数量(不包含回复自己的)' where id=18490
GO

update HtmlLabelInfo set labelname='回复文档的数量(包含回复自己的)' where indexid=18491 and languageid=7
GO
update HtmlLabelInfo set labelname='回复文档的数量(不包含回复自己的)' where indexid=18490 and languageid=7
GO


ALTER PROCEDURE DocRpSum (
	 @optional	varchar(30),
	 @userid int,
	 @flag	int output, 
	 @msg 	varchar(80)  output 
 )
   AS
    declare @resultid  int, @count  int, @replycount  int
    create table #temp( resultid  int , acount  int, replycount int )
    if   @optional='doccreater' 
    begin 
        declare resultid_cursor cursor for   
        select top 20 count(id) resultcount, ownerid resultid from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 
        where t1.id=t2.sourceid and t1.docstatus in (1,2,5) group by ownerid
        order by resultcount desc 
        
        open resultid_cursor fetch next from resultid_cursor into @count, @resultid 
        while @@fetch_status=0 
        begin 
            select @replycount=count(id) from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and 
            t1.docstatus in (1,2,5) and 
            doccreaterid=@resultid and isreply='1' insert into #temp 
            values(@resultid, @count, @replycount) 
            
            fetch next from resultid_cursor into @count, @resultid
       end 
       close resultid_cursor 
       deallocate resultid_cursor 
       
       select * from #temp order by acount desc 
   end  
   
   if @optional='crm'
   begin 
	    declare resultid_cursor cursor for     
	    select top 20 count(id) resultcount, t1.crmid resultid from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 
	    where t1.id=t2.sourceid and t1.docstatus in (1,2,5) group by t1.crmid 
	    order by resultcount desc 
	    
	    open resultid_cursor fetch next from resultid_cursor into @count, @resultid 
	    while @@fetch_status=0 
	    begin 
		    select @replycount=count(id) from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and t1.docstatus 
		    in (1,2,5) and t1.crmid=@resultid and isreply='1' 
		    insert into #temp values(@resultid, @count, @replycount) 
		    fetch next from resultid_cursor into @count, @resultid 
	    end 
	    close resultid_cursor 
	    deallocate resultid_cursor 
	    select * from #temp order by acount  desc 
   end  
   if   @optional='resource' 
   begin 
	   declare resultid_cursor cursor for 
	   select top 20 count(id) resultcount, hrmresid resultid from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 
	   where t1.id=t2.sourceid and t1.docstatus in (1,2,5) group by hrmresid 
	   order by resultcount desc 
	   
	   open resultid_cursor fetch next from resultid_cursor into @count, @resultid while @@fetch_status=0 
	   begin 
	        select @replycount=count(id) from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and 
	        t1.docstatus in (1,2,5) and hrmresid=@resultid and isreply='1' 
	        
	        insert into #temp values(@resultid, @count, @replycount) 
	        fetch next from resultid_cursor into @count, @resultid 
	  end 
	  close resultid_cursor 
	  deallocate resultid_cursor
	    
	  Select * from #temp order by acount desc 
  end  
  if   @optional='project' 
  begin 
    declare resultid_cursor cursor for 
    select top 20 count(id) resultcount, projectid resultid from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 
    where t1.id=t2.sourceid and t1.docstatus in (1,2,5) group by projectid 
    order by resultcount desc
    
    open resultid_cursor fetch next from resultid_cursor into @count, @resultid 
    while @@fetch_status=0 
    begin 
        select @replycount=count(id) from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and t1.docstatus 
        in (1,2,5) and projectid=@resultid and isreply='1' 
        
        insert into #temp values(@resultid, @count, @replycount) 
        
        fetch next from resultid_cursor  into @count, @resultid 
    end 
    close resultid_cursor 
    deallocate resultid_cursor 
    select * from #temp order by acount desc 
  end  
  if   @optional='department' 
  begin 
    declare resultid_cursor cursor for select top 20 count(id) resultcount, docdepartmentid resultid from docdetail 
    as t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) and docdepartmentid>0  group by docdepartmentid order by resultcount desc 
    
    open resultid_cursor fetch next from resultid_cursor into @count, @resultid 
    while @@fetch_status=0 
    begin 
        select @replycount=count(id) from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and 
        t1.docstatus in (1,2,5) and docdepartmentid=@resultid and 
        isreply='1'         
        insert into #temp values(@resultid, @count, @replycount)         
        fetch next from resultid_cursor into @count, @resultid 
    end 
    close resultid_cursor 
    deallocate resultid_cursor     
    select * from #temp order by acount desc 
 end  
  if   @optional='language' 
  begin 
    declare resultid_cursor cursor for select top 20 count(id) resultcount, doclangurage resultid from docdetail as 
    t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) 
    group by doclangurage order by resultcount desc 
    
    open resultid_cursor fetch next from resultid_cursor into @count, @resultid 
    while @@fetch_status=0 
    begin 
        select @replycount=count(id) from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and t1.docstatus 
        in (1,2,5) and doclangurage=@resultid and isreply='1' 
        
        insert into #temp values(@resultid, @count, @replycount) 
        fetch next from resultid_cursor into @count, @resultid 
    end 
    close resultid_cursor
    deallocate resultid_cursor 
    select * from #temp order by acount desc 
 end  
 if   @optional='item' 
 begin 
	 declare resultid_cursor cursor for select top 20 count(id) resultcount, itemid resultid from docdetail as t1, 
	 GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) 
	 group by itemid order by resultcount desc 
	 
	 open resultid_cursor fetch next from resultid_cursor into @count, @resultid while @@fetch_status=0 
	 begin 
	    select @replycount=count(id) from docdetail as t1, GetDocShareDetailTable(@userid ,1)  as t2 where t1.id=t2.sourceid and t1.docstatus 
        in (1,2,5) and itemid=@resultid and isreply='1' 
        insert into #temp values(@resultid, @count, @replycount) 
        
        fetch next from resultid_cursor into @count, @resultid 
    end 
    close resultid_cursor 
    deallocate resultid_cursor 
    select * from #temp order by acount desc 
 end
GO

