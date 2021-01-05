ALTER TABLE workflow_addinoperate
ADD type int NULL
GO

UPDATE workflow_addinoperate
SET type=0
GO

DROP PROCEDURE workflow_addinoperate_Insert 
GO
CREATE PROCEDURE workflow_addinoperate_Insert 
    (@objid_1           [int],
     @isnode_2          [int],
     @workflowid_3      [int],
     @fieldid_4         [int],
     @fieldop1id_5      [int],
     @fieldop2id_6      [int],
     @operation_7       [int],
     @customervalue_8   [varchar](255),
     @rules_9           [int],
     @type_10           [int],
     @flag integer      output,
     @msg varchar(80)   output
)

AS INSERT INTO [workflow_addinoperate] 
    ([objid],
     [isnode],
     [workflowid],
     [fieldid],
     [fieldop1id],
     [fieldop2id],
     [operation],
     [customervalue],
     [rules],
     [type]) 

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
     @type_10)
GO