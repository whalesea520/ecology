declare @i int 
set @i = 0 
while @i < 5000 
begin 
insert into workflow_billfield (billid) values(-1)
set @i = @i + 1 
end
GO
delete from workflow_billfield where billid=-1
GO
