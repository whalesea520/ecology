/*新增数据存储过程*/

CREATE PROCEDURE Workflow_Agent_Insert 
(@agentId           int,
@workflowId         int,
@beagenterId        int,
@agenterId          int,
@beginDate          char(10),
@beginTime          char(8),
@endDate            char(10),
@endTime            char(8),
@isCreateAgenter    int,
@flag integer       output,
@msg varchar(80)    output )
AS 
insert into Workflow_Agent 
values
(@agentId,@workflowId,@beagenterId,@agenterId,@beginDate,@beginTime,@endDate,@endTime,@isCreateAgenter) 
GO
