update workflow_flownode set IsAlreadyForward='1' where IsSubmitForward='1'
GO
update workflow_flownode set IsBeForwardAlready='1' where IsBeForward='1' and IsSubmitForward='1'
GO
update workflow_flownode set IsShowBeForwardAlready='1' where IsShowBeForward='1' and IsSubmitForward='1'
GO
update workflow_flownode set IsShowBeForwardTodo='1',IsShowBeForward='0' where IsShowBeForward='1' and IsSubmitForward='0' and IsPendingForward='1'
GO
update workflow_flownode set IsBeForwardTodo='1',IsBeForward='0' where IsBeForward='1' and IsSubmitForward='0' and IsPendingForward='1'
GO
update workflow_flownode set IsShowBeForwardSubmitNotaries='1' where IsPendingForward='1' and IsShowSubmitedOpinion='1' and IsSubmitForward='1'
GO
update workflow_flownode set IsShowBeForwardSubmitAlready='1' where IsPendingForward='1' and IsShowSubmitedOpinion='1' and IsAlreadyForward='1'
GO
update workflow_flownode set IsBeForwardSubmitNotaries='1' where IsPendingForward='1' and IsSubmitedOpinion='1' and IsSubmitForward='1'
GO
update workflow_flownode set IsBeForwardSubmitAlready='1' where IsPendingForward='1' and IsSubmitedOpinion='1' and IsAlreadyForward='1'
GO
update workflow_flownode set IsBeForwardSubmit=0 where IsPendingForward=1 and IsBeForwardSubmit=1 and IsSubmitedOpinion=1 and IsBeForwardModify=0 and IsWaitForwardOpinion=0 and IsBeForwardPending=0
GO