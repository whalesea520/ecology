drop trigger trg_cptfrozennum_update
go
create trigger trg_cptfrozennum_update
on cptcapital
for update
as
if update(frozennum)
begin
	declare @cptid int;
	declare @isdata int;
	declare @newfrozennum decimal(18,2);
	declare @oldfrozennum decimal(18,2);
	declare my_cursor cursor for select inserted.id,inserted.isdata,inserted.frozennum,deleted.frozennum from inserted,deleted where inserted.id=deleted.id;
	open my_cursor
	fetch next from my_cursor into @cptid,@isdata,@newfrozennum,@oldfrozennum;
	while @@fetch_status=0
	begin
	   	if @isdata!=2 fetch next from my_cursor into @cptid,@isdata,@newfrozennum,@oldfrozennum;
	   	
	  select  @newfrozennum=sum(t.num)  from
	  (
	  select d.number_n as num from bill_cptfetchmain m,bill_cptfetchdetail d where d.cptfetchid=m.id and d.capitalid=@cptid and exists(select 1 from workflow_requestbase r where r.requestid=m.requestid and r.currentnodetype>0 and r.currentnodetype<3)
	  union all
	  select d.numbers as num from bill_discard_detail d where d.capitalid=@cptid and exists(select 1 from workflow_requestbase r where r.requestid=d.detailrequestid and r.currentnodetype>0 and r.currentnodetype<3)
	  union all
	  select m.losscount as num from bill_cptloss m where m.losscpt=@cptid and exists(select 1 from workflow_requestbase r where r.requestid=m.requestid and r.currentnodetype>0 and r.currentnodetype<3)
	  union all
	  select 1 as num from bill_cptlend m where m.lendCpt=@cptid and exists(select 1 from workflow_requestbase r where r.requestid=m.requestid and r.currentnodetype>0 and r.currentnodetype<3)
	  ) t ;
	  
		update cptcapital set frozennum=@newfrozennum where id=@cptid;
		fetch next from my_cursor into @cptid,@isdata,@newfrozennum,@oldfrozennum;
	end
	CLOSE my_cursor;
	DEALLOCATE my_cursor;
end
go