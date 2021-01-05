create or replace procedure rolestrtree_sbyurid(userid_1  integer,
                                                roleid_2  integer,
                                                flag      out integer,
                                                msg       out varchar2,
                                                thecursor in out cursor_define.weavercursor) as
  rowcount integer;
  id_1     integer;
begin
  select count(roleid)
    into rowcount
    from systemrightroles
   where roleid = roleid_2;
  if rowcount > 0 then
    insert into temptree4
      (rightid, subcomid, rightlevel)
      select b.rightid, c.subcompanyid, max(c.rightlevel)
        from hrmrolemembers a, systemrightroles b, sysrolesubcomright c
       where a.roleid = b.roleid
         and a.roleid = c.roleid
         and a.resourceid = userid_1
         and b.rightid in
             (select rightid from systemrightroles where roleid = roleid_2)
         --and b.roleid <> roleid_2
       group by b.rightid, c.subcompanyid;
    insert into temptree1
      (id, operatetype_range)
      select subcomid, min(rightlevel)
        from temptree4
       group by subcomid
      having count(subcomid) = (select count(distinct(rightid))
                                  from temptree4);
  else
    insert into temptree1
      (id, operatetype_range)
      select subcompanyid, min(rightlevel)
        from sysrolesubcomright
       where roleid in
             (select roleid from hrmrolemembers where resourceid = userid_1)
         and roleid <> roleid_2
       group by subcompanyid
      having count(subcompanyid) = (select count(roleid)
                                      from hrmrolemembers
                                     where resourceid = userid_1
                                       and roleid <> roleid_2);
  end if;
  insert into temptree2
    (id, parent_id, operatetype_range)
    select a.id, b.supsubcomid, a.operatetype_range
      from temptree1 a, hrmsubcompany b
     where a.id = b.id;
  for c1 in (select id
               from temptree2
              where parent_id <> 0
                and parent_id not in (select id from temptree2)) loop
    id_1 := c1.id;
    select count(id)
      into rowcount
      from temptree3
     where id in
           (select id
              from table(cast(getsubcomparenttree(id_1) as tab_tree)));
    if rowcount = 0 then
      insert into temptree3
        (id, parent_id, nodetype, operatetype_range)
        select id, supsubcomid, 0, 0
          from table(cast(getsubcomparenttree(id_1) as tab_tree));
    end if;
  end loop;
  insert into temptree3
    (id, parent_id, nodetype, operatetype_range)
    select id, parent_id, 1, operatetype_range from temptree2;
  open thecursor for
    select * from temptree3;
end;
