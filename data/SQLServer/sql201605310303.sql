create  procedure initmapexpand   
as
 begin
    declare modeCursor cursor    
        for select id from modeinfo where isdelete=0
     open modeCursor; 
    declare @modeid varchar(20); 
       fetch next from modeCursor into @modeid;
     while @@fetch_status=0    
        begin
			print '模块id:'+@modeid;
			declare @excount int;
			select @excount=count(*) from mode_pageexpand where modeid=@modeid and issystemflag='110';
			print '地图扩展数量:'+convert(varchar(10),@excount);
			if @excount=0 begin
			insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable)
				select @modeid,t.expendname,t.showtype,t.opentype,t.hreftype,t.hrefid,t.hreftarget,t.isshow,t.showorder,t.issystem,t.issystemflag,t.expenddesc,t.isbatch,t.defaultenable from  mode_pageexpandtemplate t where t.issystemflag='110'
			
			end
			FETCH NEXT FROM modeCursor INTO @modeid
		end
     close modeCursor;    
     deallocate modeCursor;    
end
go
exec initmapexpand
go
drop procedure initmapexpand
go