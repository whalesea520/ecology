alter table workflow_groupdetail add bhxj integer
/
alter table ShareInnerWfCreate add bhxj integer
/
create or replace trigger Tri_U_Workflow_CreateShare after insert or update or delete on workflow_groupdetail for each row 
Declare
  workflowid  integer;
  groupid     integer;
  gid         integer;
  type_1      integer;
  objid       integer;
  objid_2     integer;
  level_n     integer;
  level2_n    integer;
  signorder   integer;
  gid_old     integer;
  groupid_old INTEGER;
  count_1     integer;
  bhxj        integer;
begin
  groupid   := :new.groupid;
  gid       := :new.id;
  type_1    := :new.type;
  objid     := :new.objid;
  level_n   := :new.level_n;
  level2_n  := :new.level2_n;
  signorder := 0;
  bhxj      := :new.bhxj;
  IF (:new.signorder <> ' ') THEN
    signorder := To_number(:new.signorder);
  END IF;
  gid_old     := :old.id;
  groupid_old := :old.groupid;
  IF (updating or deleting) THEN
    if (gid_old IS NOT NULL) then
      delete from ShareInnerWfCreate where gid = gid_old;
    end IF;
  END IF;
  IF (inserting OR updating) THEN
    select workflowid
      into workflowid
      from workflow_flownode t1, workflow_nodegroup t2
     where t1.nodetype = '0'
       and t1.nodeid = t2.nodeid
       and t2.id = groupid;
    IF (workflowid IS NOT NULL AND workflowid <> 0) THEN
      if (type_1 = 1 or type_1 = 3 or type_1 = 4 or type_1 = 30) then
        insert into ShareInnerWfCreate
          (gid,
           workflowid,
           type,
           content,
           min_seclevel,
           max_seclevel,
           isBelong,
           usertype,
           bhxj)
        values
          (gid, workflowid, type_1, objid, level_n, level2_n, signorder, 0,bhxj);
      end if;
      if (type_1 = 2) then
        objid_2 := objid || '' || level_n;
        insert into ShareInnerWfCreate
          (gid,
           workflowid,
           type,
           content,
           min_seclevel,
           max_seclevel,
           isBelong,
           usertype,bhxj)
        values
          (gid, workflowid, type_1, objid_2, -1, -1, signorder, 0,bhxj);
        IF (signorder = 1) THEN
          IF (level_n = 0) THEN
            level_n := level_n + 1;
            objid_2 := objid || '' || level_n;
            insert into ShareInnerWfCreate
              (gid,
               workflowid,
               type,
               content,
               min_seclevel,
               max_seclevel,
               isBelong,
               usertype,bhxj)
            values
              (gid, workflowid, type_1, objid_2, -1, -1, signorder, 0,bhxj);
          END IF;
          IF (level_n = 1) THEN
            level_n := level_n + 1;
            objid_2 := objid || '' || level_n;
            insert into ShareInnerWfCreate
              (gid,
               workflowid,
               type,
               content,
               min_seclevel,
               max_seclevel,
               isBelong,
               usertype,bhxj)
            values
              (gid, workflowid, type_1, objid_2, -1, -1, signorder, 0,bhxj);
          END IF;
        END IF;
      end if;
      if (type_1 = 20 or type_1 = 21 or type_1 = 22 or type_1 = 25) then
        insert into ShareInnerWfCreate
          (gid,
           workflowid,
           type,
           content,
           min_seclevel,
           max_seclevel,
           isBelong,
           usertype,bhxj)
        values
          (gid, workflowid, type_1, objid, level_n, level2_n, signorder, 1,bhxj);
      end if;
    END IF;
  END IF;
exception
  when NO_DATA_FOUND then
    workflowid := 0;
end;
/