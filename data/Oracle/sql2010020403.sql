alter table workflow_base add isforwardrights char(1)
/
alter table workflow_flownode add IsBeForwardSubmit char(1)
/
alter table workflow_flownode add IsBeForwardModify char(1)
/
alter table workflow_flownode add IsBeForwardPending char(1)
/
alter table workflow_flownode add IsShowPendingForward char(1)
/
alter table workflow_flownode add IsShowWaitForwardOpinion char(1)
/
alter table workflow_flownode add IsShowBeForward char(1)
/
alter table workflow_flownode add IsShowSubmitedOpinion char(1)
/
alter table workflow_flownode add IsShowSubmitForward char(1)
/
alter table workflow_flownode add IsShowBeForwardSubmit char(1)
/
alter table workflow_flownode add IsShowBeForwardModify char(1)
/
alter table workflow_flownode add IsShowBeForwardPending char(1)
/
alter table workflow_groupdetail add IsCoadjutant char(1)
/
alter table workflow_groupdetail add signtype char(1)
/
alter table workflow_groupdetail add issyscoadjutant char(1)
/
alter table workflow_groupdetail add issubmitdesc char(1)
/
alter table workflow_groupdetail add ispending char(1)
/
alter table workflow_groupdetail add isforward char(1)
/
alter table workflow_groupdetail add ismodify char(1)
/
alter table workflow_groupdetail add coadjutants varchar2(500)
/
alter table workflow_groupdetail add coadjutantcn varchar2(1000)
/
alter table workflow_Forward add IsPendingForward char(1)
/
alter table workflow_Forward add IsWaitForwardOpinion char(1)
/
alter table workflow_Forward add IsBeForward char(1)
/
alter table workflow_Forward add IsSubmitedOpinion char(1)
/
alter table workflow_Forward add IsSubmitForward char(1)
/
alter table workflow_Forward add IsBeForwardSubmit char(1)
/
alter table workflow_Forward add IsBeForwardModify char(1)
/
alter table workflow_Forward add IsBeForwardPending char(1)
/

update workflow_flownode set IsBeForwardSubmit='1',IsBeForwardModify='0',IsBeForwardPending='0'
/
update workflow_Forward set IsPendingForward=(select a.IsPendingForward from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
/
update workflow_Forward set IsWaitForwardOpinion=(select a.IsWaitForwardOpinion from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
/
update workflow_Forward set IsBeForward=(select a.IsBeForward from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
/
update workflow_Forward set IsSubmitedOpinion=(select a.IsSubmitedOpinion from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
/
update workflow_Forward set IsSubmitForward=(select a.IsSubmitForward from workflow_flownode a,workflow_currentoperator b where a.workflowid=b.workflowid and a.nodeid=b.nodeid and b.id=Forwardid)
/
update workflow_Forward set IsBeForwardSubmit='1',IsBeForwardModify='0',IsBeForwardPending='0'
/

alter table workflow_agentpersons add coadjutants varchar2(1000)
/

CREATE TABLE workflow_coadjutant(
    requestid integer,
    organizedid integer,
    coadjutantid integer,
    issubmitdesc char(1),
    ispending char(1),
    isforward char(1),
    ismodify char(1)
)
/

CREATE TABLE workflow_CustFieldName(
    workflowId integer,
    nodeId integer,
    Languageid integer,
    fieldname varchar2(50),
    CustFieldName varchar2(50)
)
/

alter table HrmDepartment add coadjutant integer
/
