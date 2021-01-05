alter table workflow_addinoperate alter column customervalue varchar(4000)
GO
alter PROCEDURE workflow_addinoperate_Insert 
    (@objid_1           int,
     @isnode_2          int,
     @workflowid_3      int,
     @fieldid_4         int,
     @fieldop1id_5      int,
     @fieldop2id_6      int,
     @operation_7       int,
     @customervalue_8   varchar(4000),
     @rules_9           int,
     @type_10           int,
     @ispreadd_11       char(1),
     @flag integer      output,
     @msg varchar(80)   output
)
AS INSERT INTO workflow_addinoperate 
    (objid,
     isnode,
     workflowid,
     fieldid,
     fieldop1id,
     fieldop2id,
     operation,
     customervalue,
     rules,
     type,
     ispreadd) 
VALUES 
    (@objid_1,
     @isnode_2,
     @workflowid_3,
     @fieldid_4,
     @fieldop1id_5,
     @fieldop2id_6,
     @operation_7,
     @customervalue_8,
     @rules_9,
     @type_10,
     @ispreadd_11)
GO