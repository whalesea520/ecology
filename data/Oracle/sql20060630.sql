create global temporary table temp_HrmRSRPath_01(   
	subcompanyid	int ,
	rightlevel  	int
) on commit delete rows 
/
create global temporary table temp_HrmRSRPath_02(   
	id  	int 
) on commit delete rows 
/
create global temporary table temp_HrmRSRPath_03(   
	id  	int 
) on commit delete rows 
/

CREATE OR REPLACE procedure HrmRSRPath_SeByURId
(userid_1 integer,
rightstr_1 varchar2,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
 tempsubid integer;
 CURSOR c1 is select id from temp_HrmRSRPath_02;
begin
	insert into temp_HrmRSRPath_01(subcompanyid,rightlevel)
		select subcompanyid,min(rightlevel)
		from SysRoleSubcomRight 
		where roleid in(select a.roleid 
				from HrmRoleMembers a,SystemRightRoles b
				where a.roleid=b.roleid and a.resourceid=userid_1 
				and b.rightid =(select rightid from SystemRightDetail where rightdetail=rightstr_1)
				)
		group by subcompanyid;

	insert into temp_HrmRSRPath_02(id)
		select b.subcompanyid
		from hrmsubcompany a,temp_HrmRSRPath_01 b
		where a.id=b.subcompanyid and a.supsubcomid!=0 and a.supsubcomid not in(select subcompanyid from temp_HrmRSRPath_01);
	
	open c1 ;
	fetch c1 into tempsubid;
	while c1%found
	loop
		insert into temp_HrmRSRPath_03(id)
			select id from table(cast(getSubComParentTree(tempsubid) as tab_tree));
		fetch c1 into tempsubid;
	end loop;
	close c1;
	
	open thecursor for
	select subcompanyid,rightlevel from  temp_HrmRSRPath_01
	union
	select distinct(id) as subcompanyid,-1 as rightlevel from temp_HrmRSRPath_03 where id is not null;
	
end;
/
