create or replace type hrmline_table_v as object
(
  id int,
  managerid int,
  virtualtype int
)
/
create or replace type t_table_v is table of hrmline_table_v;
/

create or replace function getchilds_v(i_id int)
return t_table_v pipelined as v hrmline_table_v;
begin    
	for myrow in(
		select aa.resourceid,aa.managerid,aa.virtualtype from
		(select resourceid,managerid,virtualtype from hrmresourcevirtual where resourceid=i_id
		union
		select  a.resourceid,a.managerid,a.virtualtype from HrmResourcevirtual a join hrmresource c on ( c.id=a.resourceid and c.status in (0,1,2,3) and c.loginid is not null ) start with a.resourceid = i_id connect by prior a.resourceid=a.managerid) aa
		where exists(select 1 from hrmresourcevirtual b where b.resourceid=i_id and b.virtualtype=aa.virtualtype)
	)
	loop 
	v:=hrmline_table_v(myrow.resourceid,myrow.managerid,myrow.virtualtype);
	pipe row(v);
	end loop;
	return;
end;
/

create or replace function getparents_v(i_id int)
return t_table_v pipelined as v hrmline_table_v;
begin    
	for myrow in(
		select aa.resourceid,aa.managerid,aa.virtualtype from
		(select resourceid,managerid,virtualtype from hrmresourcevirtual where resourceid=i_id
		union
		select  a.resourceid,a.managerid,a.virtualtype from HrmResourcevirtual a join hrmresource c on ( c.id=a.resourceid and c.status in (0,1,2,3) and c.loginid is not null )  start with a.resourceid = i_id connect by prior a.managerid=a.resourceid ) aa
		where exists(select 1 from hrmresourcevirtual b where b.resourceid=i_id and b.virtualtype=aa.virtualtype)
	)
	loop 
	v:=hrmline_table_v(myrow.resourceid,myrow.managerid,myrow.virtualtype);
	pipe row(v);
	end loop;
	return;
end;
/