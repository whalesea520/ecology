declare c1 cursor for select requestid,createdate,createtime from workflow_requestbase;
open c1 
declare	@requestid1 	int;
declare	@createdate1	char(10);
declare	@createtime1	char(8);

fetch next from c1 into @requestid1,@createdate1,@createtime1
while @@fetch_status=0 begin 
	update workflow_currentoperator set receivedate=@createdate1 ,receivetime=@createtime1 ,orderdate=@createdate1 ,ordertime=@createtime1
	where requestid=@requestid1 and receivedate='2005-10-31' and receivetime='01:01:01'
	fetch next from c1 into @requestid1,@createdate1,@createtime1
end
close c1 deallocate c1
GO

