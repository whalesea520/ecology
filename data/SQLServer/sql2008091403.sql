alter table workflow_flownode add formSignatureWidth int null
GO
update workflow_flownode set formSignatureWidth=512
GO

alter table workflow_flownode add formSignatureHeight int null
GO
update workflow_flownode set formSignatureHeight=200
GO
