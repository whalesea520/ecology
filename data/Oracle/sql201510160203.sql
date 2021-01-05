CREATE OR REPLACE function getchilds(i_id int) return t_table pipelined as v hrmline_table; begin for myrow in( select id,lastname,managerid from hrmresource where id=i_id union select  a.id,a.lastname,a.managerid from HrmResource a where a.id<>i_id  start with a.id = i_id connect by NOCYCLE prior a.id=a.managerid  where a.id<>i_id) loop v:=hrmline_table(myrow.id,myrow.lastname,myrow.managerid); pipe row(v); end loop; return; end;
/
create or replace function getchilds_v(i_id int)
return t_table_v pipelined as v hrmline_table_v;
begin    
	for myrow in(
		select aa.resourceid,aa.managerid,aa.virtualtype from
		(select resourceid,managerid,virtualtype from hrmresourcevirtual where resourceid=i_id
		union
		select  a.resourceid,a.managerid,a.virtualtype from HrmResourcevirtual a join hrmresource c on ( c.id=a.resourceid and c.status in (0,1,2,3) and c.loginid is not null ) where a.resourceid<>i_id start with a.resourceid = i_id connect by NOCYCLE prior a.resourceid=a.managerid) aa
		where exists(select 1 from hrmresourcevirtual b where b.resourceid=i_id and b.virtualtype=aa.virtualtype)
	)
	loop 
	v:=hrmline_table_v(myrow.resourceid,myrow.managerid,myrow.virtualtype);
	pipe row(v);
	end loop;
	return;
end;
/

CREATE OR REPLACE function getparents(i_id int) return t_table pipelined as v hrmline_table; begin for myrow in( select id,lastname,managerid from hrmresource where id=i_id union select  a.id,a.lastname,a.managerid from HrmResource a where a.id<>i_id  start with a.id = i_id connect by NOCYCLE prior a.managerid=a.id ) loop v:=hrmline_table(myrow.id,myrow.lastname,myrow.managerid); pipe row(v); end loop; return; end;
/
CREATE OR REPLACE function getparents_v(i_id int) return t_table_v pipelined as v hrmline_table_v; begin for myrow in( select aa.resourceid,aa.managerid,aa.virtualtype from (select resourceid,managerid,virtualtype from hrmresourcevirtual where resourceid=i_id union select  a.resourceid,a.managerid,a.virtualtype from HrmResourcevirtual a join hrmresource c on ( c.id=a.resourceid and c.status in (0,1,2,3) and c.loginid is not null )  where a.resourceid<>i_id start with a.resourceid = i_id connect by NOCYCLE prior a.managerid=a.resourceid ) aa where exists(select 1 from hrmresourcevirtual b where b.resourceid=i_id and b.virtualtype=aa.virtualtype) ) loop v:=hrmline_table_v(myrow.resourceid,myrow.managerid,myrow.virtualtype); pipe row(v); end loop; return; end;
/