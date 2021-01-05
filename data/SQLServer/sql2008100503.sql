create procedure deleteVotingRemark
as
declare @votingidtemp int
declare @v_id int

declare voting_cursor cursor for 
  select id from voting where status = 1
open voting_cursor 
fetch next from voting_cursor into @votingidtemp 
while @@fetch_status=0 
begin
   select  @v_id = count(votingid) from votingoption where votingid = @votingidtemp
   if (@v_id = 0)
     delete from votingremark where votingid = @votingidtemp
     delete from votingresourceremark where votingid = @votingidtemp
fetch next from voting_cursor into @votingidtemp
end
close voting_cursor 
deallocate voting_cursor
go

EXECUTE deleteVotingRemark
go

ALTER PROCEDURE VotingResource_Insert
(@votingid    int,
 @questionid    int,
 @optionid   int,
 @resourceid int,
 @operatedate   char(10),
 @operatetime   char(8),
 @flag integer output,
 @msg varchar(80) output)
AS 
	declare @count int
	select @count=count(votingid) from votingresource where optionid=@optionid and resourceid=@resourceid and votingid=@votingid
	if  @count=0
	begin
    	insert into votingresource (votingid,questionid,optionid,resourceid,operatedate,operatetime)
    	values (@votingid,@questionid,@optionid,@resourceid,@operatedate,@operatetime)
	end

GO
