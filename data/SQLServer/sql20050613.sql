alter table docdetail add  docExtendName char(10)
go

create  PROCEDURE initDocDetail_docExtendName	
	@flag		int	output, 
	@msg		varchar(80) output
as
	Declare
	@docid int,
	@doctype int,
 	@docfiletype int,
	@all_cursor cursor

	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select d1.id,d1.doctype,d2.docfiletype from docdetail d1 left join docimagefile d2 on d1.id=d2.docid	
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @docid,@doctype,@docfiletype
	WHILE @@FETCH_STATUS = 0
	begin
		if @doctype = 2 
			begin
				if @docfiletype = 3 
					update docdetail set docExtendName='doc' where id = @docid;
				else if  @docfiletype = 4 
					update docdetail set docExtendName='xls' where id = @docid;
			        else  
					update docdetail set docExtendName='html' where id = @docid;				
			end
	        else 
			update docdetail set docExtendName='html' where id = @docid;	       
		FETCH NEXT FROM @all_cursor INTO  @docid,@doctype,@docfiletype
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor  	
GO

initDocDetail_docExtendName '',''
go