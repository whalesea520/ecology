alter table workflow_flownode add formSignatureWidth integer null
/
update workflow_flownode set formSignatureWidth=512
/

alter table workflow_flownode add formSignatureHeight integer null
/
update workflow_flownode set formSignatureHeight=200
/