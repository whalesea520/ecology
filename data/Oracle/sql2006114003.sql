

create or replace procedure HrmEditRightPath_SeByURId 
	(userid_1 integer,
	rightstr_2 varchar2,
	level_3 integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS

tempsub_id integer;

begin
insert into temptree4(subcomid,rightlevel)
select a.subcompanyid,a.rightlevel from (select subcompanyid,min(rightlevel) as rightlevel
from SysRoleSubcomRight 
where roleid in(select a.roleid 
		from HrmRoleMembers a,SystemRightRoles b
		where a.roleid = b.roleid and a.resourceid = userid_1 
		and b.rightid =(select rightid from SystemRightDetail where rightdetail = rightstr_2)
		)
group by subcompanyid ) a where a.rightlevel >= level_3;

insert into temptree2(id)
select b.subcomid
from hrmsubcompany a,temptree4 b
where a.id = b.subcomid and a.supsubcomid<>0 and a.supsubcomid not in(select subcomid from temptree4);

for c1 in(select id from temptree2)
	loop 
		tempsub_id := c1.id;
		insert into  temptree3(id)
		select id from table(cast(getSubComParentTree(tempsub_id) as tab_tree));
	end loop;
	open thecursor for
	select subcomid as subcompanyid,rightlevel from temptree4
	union
	select distinct(id),-1 from temptree3;
end;
/