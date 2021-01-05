/*处理没有权限类型的权限*/
declare
mcount integer;
mid integer;

begin
select  count(rightgroupmark) into mcount from SystemRightGroups where rightgroupmark='OTHADM';
if mcount=0 then
	insert into SystemRightGroups(rightgroupmark,rightgroupname,rightgroupremark)
	values ('OTHADM','其他权限组','存放暂时未分组的权限');
end if;
select  id into mid from SystemRightGroups where rightgroupmark='OTHADM';
insert into SystemRightToGroup(groupid,rightid) 
select mid,id from SystemRights where id not in(select rightid from SystemRightToGroup);
end;
/