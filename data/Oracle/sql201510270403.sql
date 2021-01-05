CREATE OR REPLACE TRIGGER trg_prjmembers_update
  AFTER INSERT OR UPDATE ON Prj_ProjectInfo
  FOR EACH ROW
declare
  i_prjid   int;
  i_members varchar2(4000);
  i_isblock int;
  i_idx     int;
  i_userid  int;
begin
  i_members := :new.members || ',';
  i_isblock := :new.isblock;
  i_prjid   := :new.id;
  delete from prj_members where relateditemid = i_prjid;
  if i_isblock != 1 THEN
    RETURN;
  end if;
  if i_members = '' THEN
    RETURN;
  end if;
  if i_members is null THEN
    RETURN;
  end if;
  i_idx := INSTR(i_members, ',', 1, 1);
  while i_idx > 0 loop
    i_userid := to_number(SUBSTR(i_members, 0, (i_idx - 1)));
    if i_userid > 0 then
      insert into prj_members
        (relateditemid, userid)
      values
        (i_prjid, i_userid);
    end if;
    i_members := SUBSTR(i_members, (i_idx + 1), LENGTH(i_members));
    i_idx     := INSTR(i_members, ',', 1, 1);
  end loop;
end;
/