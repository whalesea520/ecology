create procedure HrmEditRightPath_SeByURId @userid int,@rightstr varchar(100),@level int, @flag integer output , @msg varchar(80) output AS

declare @temptree1 Table (subcompanyid int ,rightlevel int)
declare @temptree2 Table (id int )
declare @temptree3 Table (id int )

	
insert @temptree1
select a.subcompanyid,a.rightlevel from (select subcompanyid,min(rightlevel) as rightlevel
from SysRoleSubcomRight 
where roleid in(select a.roleid 
		from HrmRoleMembers a,SystemRightRoles b
		where a.roleid=b.roleid and a.resourceid=@userid 
		and b.rightid =(select rightid from SystemRightDetail where rightdetail=@rightstr)
		)
group by subcompanyid ) a where a.rightlevel>=@level




insert @temptree2
select b.subcompanyid
from hrmsubcompany a,@temptree1 b
where a.id=b.subcompanyid and a.supsubcomid<>0 and a.supsubcomid not in(select subcompanyid from @temptree1)


declare c1 cursor for select id from @temptree2
open c1 
declare  @tempsubid int
fetch next from c1 into @tempsubid
while @@fetch_status=0 begin 
	insert @temptree3
	select id from getSubComParentTree(@tempsubid)
	fetch next from c1 into @tempsubid
end 
close c1 deallocate c1

select * from  @temptree1
union
select distinct(id),-1 from @temptree3
	
GO