update  workflow_flownode set printflowcomment = '9' where printflowcomment = '0'
GO
update  workflow_flownode set printflowcomment = '0' where printflowcomment = '1'
GO
update  workflow_flownode set printflowcomment = '1' where printflowcomment = '9'
GO