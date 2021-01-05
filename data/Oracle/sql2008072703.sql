CREATE TABLE workflow_viewattrlinkage(
    workflowid integer,
    nodeid integer, 
    selectfieldid varchar2(20),
    selectfieldvalue    varchar2(10),
    changefieldids   varchar2(1000),
    viewattr char(1)
)
/
