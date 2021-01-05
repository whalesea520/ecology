create  procedure mode_pageexpand_historydata2
as
declare @icount int,@modeid int
declare m_cursor cursor  for select id from modeinfo
begin
	open m_cursor
	fetch next from m_cursor into @modeid
	while @@FETCH_STATUS=0
	begin
		select @icount=count(*) from mode_pageexpand where modeid=@modeid and expendname='ÅúÁ¿¹²Ïí'
		if @icount<1
			begin 
			insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable)
				   select @modeid,mp.expendname,mp.showtype,mp.opentype,mp.hreftype,mp.hrefid,mp.hreftarget,mp.isshow,mp.showorder,mp.issystem,mp.issystemflag,mp.expenddesc,mp.isbatch,mp.defaultenable
				   from mode_pageexpandtemplate mp where mp.issystemflag=104
			end
			fetch next from m_cursor into @modeid
	end
	close m_cursor
	deallocate m_cursor
end

go
exec mode_pageexpand_historydata2
go

