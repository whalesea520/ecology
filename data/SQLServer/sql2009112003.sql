create procedure FormLabelMaintenance AS
Declare
  @indexidn    int,
  @labelnamen  varchar(2000),
  @languageidn int,
  @all_cursor cursor
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select hl.*
                       from (select h.indexid, count(h.languageid) cl
                               from workflow_bill b, htmllabelinfo h
                              where b.namelabel = h.indexid
                              and b.id<0
                              group by h.indexid
                             having count(h.languageid) < 3) r,
                            htmllabelinfo hl
                      where r.indexid = hl.indexid
                        and languageid = 7
OPEN @all_cursor 
FETCH NEXT FROM @all_cursor INTO @indexidn ,	@labelnamen ,@languageidn
WHILE @@FETCH_STATUS = 0 
begin
	begin
	    delete from htmllabelinfo where indexid = @indexidn
	end 
	begin
	    insert into htmllabelinfo
	    values
	      (@indexidn, @labelnamen, 7)
	end 
	begin
	    insert into htmllabelinfo
	    values
	      (@indexidn, @labelnamen, 8)
	end 
	begin
	    insert into htmllabelinfo
	    values
	      (@indexidn, @labelnamen, 9)
	end 
	FETCH NEXT FROM @all_cursor INTO @indexidn ,	@labelnamen ,@languageidn
end 
CLOSE @all_cursor 
DEALLOCATE @all_cursor  
go

exec FormLabelMaintenance
GO
