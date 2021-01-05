alter table workflow_base add isforwardrights char(1)
GO
alter table workflow_flownode add IsBeForwardSubmit char(1)
GO
alter table workflow_flownode add IsBeForwardModify char(1)
GO
alter table workflow_flownode add IsBeForwardPending char(1)
GO
alter table workflow_flownode add IsShowPendingForward char(1)
GO
alter table workflow_flownode add IsShowWaitForwardOpinion char(1)
GO
alter table workflow_flownode add IsShowBeForward char(1)
GO
alter table workflow_flownode add IsShowSubmitedOpinion char(1)
GO
alter table workflow_flownode add IsShowSubmitForward char(1)
GO
alter table workflow_flownode add IsShowBeForwardSubmit char(1)
GO
alter table workflow_flownode add IsShowBeForwardModify char(1)
GO
alter table workflow_flownode add IsShowBeForwardPending char(1)
GO
alter table workflow_groupdetail add IsCoadjutant char(1)
GO
alter table workflow_groupdetail add signtype char(1)
GO
alter table workflow_groupdetail add issyscoadjutant char(1)
GO
alter table workflow_groupdetail add issubmitdesc char(1)
GO
alter table workflow_groupdetail add ispending char(1)
GO
alter table workflow_groupdetail add isforward char(1)
GO
alter table workflow_groupdetail add ismodify char(1)
GO
alter table workflow_groupdetail add coadjutants varchar(500)
GO
alter table workflow_groupdetail add coadjutantcn varchar(1000)
GO
alter table workflow_Forward add IsPendingForward char(1)
GO
alter table workflow_Forward add IsWaitForwardOpinion char(1)
GO
alter table workflow_Forward add IsBeForward char(1)
GO
alter table workflow_Forward add IsSubmitedOpinion char(1)
GO
alter table workflow_Forward add IsSubmitForward char(1)
GO
alter table workflow_Forward add IsBeForwardSubmit char(1)
GO
alter table workflow_Forward add IsBeForwardModify char(1)
GO
alter table workflow_Forward add IsBeForwardPending char(1)
GO

update workflow_flownode set IsBeForwardSubmit='1',IsBeForwardModify='0',IsBeForwardPending='0'
GO
update workflow_Forward set IsPendingForward=(select a.IsPendingForward from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
GO
update workflow_Forward set IsWaitForwardOpinion=(select a.IsWaitForwardOpinion from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
GO
update workflow_Forward set IsBeForward=(select a.IsBeForward from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
GO
update workflow_Forward set IsSubmitedOpinion=(select a.IsSubmitedOpinion from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
GO
update workflow_Forward set IsSubmitForward=(select a.IsSubmitForward from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
GO
update workflow_Forward set IsBeForwardSubmit='1',IsBeForwardModify='0',IsBeForwardPending='0'
GO

alter table workflow_agentpersons add coadjutants varchar(1000)
GO

CREATE TABLE workflow_coadjutant(
    requestid int,
    organizedid int,
    coadjutantid int,
    issubmitdesc char(1),
    ispending char(1),
    isforward char(1),
    ismodify char(1)
)
GO

CREATE TABLE workflow_CustFieldName(
    workflowId int,
    nodeId int,
    Languageid int,
    fieldname varchar(50),
    CustFieldName varchar(50)
)
GO

alter table HrmDepartment add coadjutant int
GO
