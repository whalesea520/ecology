CREATE OR REPLACE PROCEDURE workflow_addinoperate_Insert 
    (objid_1           integer,
     isnode_2          integer,
     workflowid_3      integer,
     fieldid_4         integer,
     fieldop1id_5      integer,
     fieldop2id_6      integer,
     operation_7       integer,
     customervalue_8   varchar2,
     rules_9           integer,
     type_10           integer,
     flag       out integer,
     msg        out  varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin

 INSERT INTO workflow_addinoperate 
    (objid,
     isnode,
     workflowid,
     fieldid,
     fieldop1id,
     fieldop2id,
     operation,
     customervalue,
     rules,
     type) 

VALUES 
    (objid_1,
     isnode_2,
     workflowid_3,
     fieldid_4,
     fieldop1id_5,
     fieldop2id_6,
     operation_7,
     customervalue_8,
     rules_9,
     type_10);
end;
/
