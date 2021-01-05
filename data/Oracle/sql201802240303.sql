CREATE OR REPLACE FUNCTION getSubComParentTree(subcom_id integer)
  RETURN tab_tree AS
  parent_id  integer;
  tab_tree_1 tab_tree := tab_tree();
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  select supsubcomid
    into parent_id
    from hrmsubcompany
   where id = subcom_id;
  while parent_id != 0 and parent_id is not null loop
    insert into temptree
      (id, supsubcomid)
      (select id, supsubcomid from hrmsubcompany where id = parent_id);
    select supsubcomid
      into parent_id
      from (select supsubcomid from temptree order by num desc)
     WHERE rownum = 1;
  end loop;
  select obj_tree(id, supsubcomid) bulk collect
    into tab_tree_1
    from temptree
   order by num desc;
    COMMIT;
  return tab_tree_1;
END;
/
