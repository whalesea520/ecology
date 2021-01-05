/*新增数据存储过程*/
CREATE OR REPLACE PROCEDURE Workflow_Agent_Insert
    (agentId           integer,
    workflowId         integer,
    beagenterId        integer,
    agenterId          integer,
    beginDate          char,
    beginTime          char,
    endDate            char,
    endTime            char,
    isCreateAgenter    integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
begin
insert into Workflow_Agent
    (agentId,
    workflowId,
    beagenterId,
    agenterId,
    beginDate,
    beginTime,
    endDate,
    endTime,
    isCreateAgenter)
values
    (agentId,
    workflowId,
    beagenterId,
    agenterId,
    beginDate,
    beginTime,
    endDate,
    endTime,
    isCreateAgenter);
end;
/
