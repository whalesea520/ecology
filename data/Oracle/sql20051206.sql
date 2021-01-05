declare cursor c1 is select requestid,createdate,createtime from workflow_requestbase ;
		requestid1 integer;
		createdate1	char(10);
		createtime1	char(8);
begin
    open c1;
    fetch c1 into requestid1, createdate1,createtime1;
    while c1%found
    loop
		update workflow_currentoperator set receivedate=createdate1 ,receivetime=createtime1 ,orderdate=createdate1 ,ordertime=createtime1
		where requestid=requestid1 and receivedate='2005-10-31' and receivetime='01:01:01';
		fetch c1 into requestid1,createdate1,createtime1;
	end loop;
    close c1;
end;
/

