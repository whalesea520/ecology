INSERT INTO HtmlLabelIndex values(18010,'节点后附加操作') 
GO
INSERT INTO HtmlLabelInfo VALUES(18010,'节点后附加操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18010,'followed odditional operation',8) 
GO

INSERT INTO HtmlLabelIndex values(18009,'节点前附加操作') 
GO
INSERT INTO HtmlLabelInfo VALUES(18009,'节点前附加操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18009,'pre odditional operation',8) 
GO

alter table workflow_addinoperate add ispreadd char(1)
GO
 
update  workflow_addinoperate set ispreadd = '0'
GO

alter PROCEDURE workflow_addinoperate_select 
(@id 	int,
@isnode 	int, 
@ispreadd char(1),
@flag integer output, 
@msg varchar(80) output) 
AS
select * from workflow_addinoperate where objid=@id and isnode=@isnode and ispreadd=@ispreadd order by id  

GO


alter PROCEDURE workflow_addinoperate_Insert 
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
     @ispreadd_11           [char](1),
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
     [type],
     [ispreadd]) 

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
