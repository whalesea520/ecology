update  workflow_flownode set printflowcomment = '9' where printflowcomment = '0'
/
update  workflow_flownode set printflowcomment = '0' where printflowcomment = '1'
/
update  workflow_flownode set printflowcomment = '1' where printflowcomment = '9'
/