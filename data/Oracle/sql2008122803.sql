alter table workflow_flownode add IsPendingForward char(1)
/
alter table workflow_flownode add IsWaitForwardOpinion char(1)
/
alter table workflow_flownode add IsBeForward char(1)
/
alter table workflow_flownode add IsSubmitedOpinion char(1)
/
alter table workflow_flownode add IsSubmitForward char(1)
/
update workflow_flownode set IsPendingForward='1',IsWaitForwardOpinion='0',IsBeForward='0',IsSubmitedOpinion='1',IsSubmitForward='0'
/
update workflow_flownode set IsSubmitForward='1',IsBeForward='1' where workflowid in(select id from workflow_base where isremarks='1')
/
CREATE TABLE workflow_Forward(
    requestid integer,
    Forwardid integer,
    BeForwardid integer
)
/
CREATE  INDEX IX_workflow_Forward ON workflow_Forward(requestid)
/
