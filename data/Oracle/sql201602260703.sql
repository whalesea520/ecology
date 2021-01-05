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
  jobfield	  varchar2(4000);
  jobobj	  varchar2(4000);
  v_strs_last varchar2(4000);
  v_idx       integer;
  v_str       varchar2(500);
  p_split	  varchar2(5);
begin
  groupid   := :new.groupid;
  gid       := :new.id;
  type_1    := :new.type;
  objid     := :new.objid;
  level_n   := :new.level_n;
  level2_n  := :new.level2_n;
  signorder := 0;
  bhxj      := :new.bhxj;
  jobfield	:= :new.jobfield;
  jobobj    := :new.jobobj;
  v_strs_last := jobfield;
  p_split   := ',';
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
      
      if(type_1 = 58) THEN
      	IF(jobfield IS null) THEN
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
	          (gid, workflowid, type_1, jobobj, level_n, level2_n, signorder, 0,bhxj);
      	END IF;
      	 
      	IF(jobfield IS NOT null) THEN 
      	    
	  		
		    LOOP
		      	v_idx := instr(v_strs_last, p_split);
			    exit when v_idx = 0;
			    v_str       := substr(v_strs_last, 1, v_idx - 1);
			    v_strs_last := substr(v_strs_last, v_idx + 1);
		      
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
			          (gid, workflowid, type_1, jobobj, level_n, v_str, signorder, 0,bhxj);
	      	end loop;
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
		          (gid, workflowid, type_1, jobobj, level_n, v_strs_last, signorder, 0,bhxj);
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

CREATE OR REPLACE PROCEDURE workflow_groupdetail_SByGroup(id_1      integer,
                                                          flag      OUT integer,
                                                          msg       OUT varchar2,
                                                          thecursor IN OUT cursor_define.weavercursor) AS
BEGIN
  OPEN thecursor FOR
    SELECT id,
           groupid,
           TYPE,
           objid,
           deptField,
           subcompanyField,
           level_n,
           level2_n,
           conditions,
           conditioncn,
           orders,
           signorder,
           CASE
             WHEN signorder in (3, 4) THEN
              10000 + signorder
             ELSE
              1 + orders
           END AS sort,
           IsCoadjutant,
           signtype,
           issyscoadjutant,
           issubmitdesc,
           ispending,
           isforward,
           ismodify,
           coadjutants,
           coadjutantcn,
           virtualid,
           ruleRelationship,
           jobfield,
	   jobobj,
	   bhxj
      FROM workflow_groupdetail
     WHERE groupid = id_1
     ORDER BY sort, id;
END;
/