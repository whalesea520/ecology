update MainMenuInfo set labelId=16455, linkAddress='/hrm/company/HrmCompany_frm.jsp' where id=55
go 
delete from MainMenuInfo where id=56
go 
delete from MainMenuInfo where id=57
go

update LeftMenuInfo set linkAddress='/hrm/resource/HrmResource_frm.jsp' where id=42
go

INSERT INTO HtmlLabelIndex values(17898,'下级分部') 
GO
INSERT INTO HtmlLabelIndex values(17900,'下级部门') 
GO
INSERT INTO HtmlLabelIndex values(17899,'同级部门') 
GO
INSERT INTO HtmlLabelIndex values(17897,'同级分部') 
GO
INSERT INTO HtmlLabelInfo VALUES(17897,'同级分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17897,'subcompany same level',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17898,'下级分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17898,'subcompany low level',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17899,'同级部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17899,'department same level',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17900,'下级部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17900,'department low level',8) 
GO

create procedure HrmRSRPath_SeByURId @userid int,@rightstr varchar(100), @flag integer output , @msg varchar(80) output AS

declare @temptree1 Table (subcompanyid int ,rightlevel int)
declare @temptree2 Table (id int )
declare @temptree3 Table (id int )


insert @temptree1
select subcompanyid,min(rightlevel) as rightlevel
from SysRoleSubcomRight 
where roleid in(select a.roleid 
		from HrmRoleMembers a,SystemRightRoles b
		where a.roleid=b.roleid and a.resourceid=@userid 
		and b.rightid =(select rightid from SystemRightDetail where rightdetail=@rightstr)
		)
group by subcompanyid


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

create PROCEDURE HrmRoleSRT_AddByNewSc (@subcomid int,@supsubcomid int,@flag integer output, @msg varchar(30) output) as 
begin 

declare c1 cursor for select roleid,rightlevel from SysRoleSubcomRight where subcompanyid=@supsubcomid
open c1 
declare  @roleid int
declare  @rightlevel int 

fetch next from c1 into @roleid, @rightlevel
while @@fetch_status=0 begin 
	insert into SysRoleSubcomRight(roleid,subcompanyid,rightlevel) values(@roleid, @subcomid, @rightlevel)
	fetch next from c1 into @roleid, @rightlevel
end 

close c1 deallocate c1 end

GO
