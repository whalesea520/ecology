alter table workflow_nodehtmllayout add isactive int
GO

create procedure WORKFLOW_LAYOUTSETACTIVE as 
       declare @vsql nvarchar(1000);
       declare @v_nodeid INT;
       declare @v_formid INT;
       declare @v_isbill INT;
       declare @v_type INT;
       declare @v_str nvarchar(1000);
       declare @maxid varchar(100);
   declare my_cur cursor 
	FOR SELECT nodeid,formid,isbill,type FROM (SELECT nodeid,formid,isbill,type,count(*)
        AS num FROM workflow_nodehtmllayout where isactive is null GROUP BY nodeid,formid,isbill,type) a WHERE a.num>1;
   open my_cur;
   fetch next from my_cur into @v_nodeid,@v_formid,@v_isbill,@v_type;
   while (@@FETCH_STATUS =0)
   BEGIN
       set @v_str = ' and nodeid='+convert(varchar,@v_nodeid)+' and formid='+convert(varchar,@v_formid)+' and isbill='+convert(varchar,@v_isbill)+' and type='+convert(varchar,@v_type);
       set @vsql = 'select @maxid=MAX(id) from workflow_nodehtmllayout where 1=1 '+@v_str;
       print @vsql;
       EXEC SP_EXECUTESQL @stmt=@vsql,@params=N'@maxid INT OUT',@maxid=@maxid OUTPUT;
       print @maxid;
       set @vsql = 'update workflow_nodehtmllayout set isactive=1 where 1=1 '+@v_str+' and id='+@maxid;
       EXEC SP_EXECUTESQL @vsql;
       set @vsql = 'update workflow_nodehtmllayout set isactive=0 where 1=1 '+@v_str+' and id<>'+@maxid;
       EXEC SP_EXECUTESQL @vsql;
       fetch next from my_cur into @v_nodeid,@v_formid,@v_isbill,@v_type;
   END;
   close my_cur;
   deallocate my_cur;
  update workflow_nodehtmllayout set isactive=1 where isactive is null
GO
exec WORKFLOW_LAYOUTSETACTIVE
GO