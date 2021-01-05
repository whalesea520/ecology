ALTER TABLE workflow_flownode ADD IsBeForwardTodo char(1) null
/
ALTER TABLE workflow_flownode ADD IsShowBeForwardTodo char(1) null
/
ALTER TABLE workflow_flownode ADD IsBeForwardAlready char(1) null
/
ALTER TABLE workflow_flownode ADD IsShowBeForwardAlready char(1) null
/
ALTER TABLE workflow_flownode ADD IsAlreadyForward char(1) null
/
ALTER TABLE workflow_flownode ADD IsShowAlreadyForward char(1) null
/
ALTER TABLE workflow_flownode ADD IsBeForwardSubmitAlready char(1) null
/
ALTER TABLE workflow_flownode ADD IsShowBeForwardSubmitAlready char(1) null
/
ALTER TABLE workflow_flownode ADD IsBeForwardSubmitNotaries char(1) null
/
ALTER TABLE workflow_flownode ADD IsShowBeForwardSubmitNotaries char(1) null
/
ALTER TABLE workflow_Forward ADD IsBeForwardTodo char(1) null
/
ALTER TABLE workflow_Forward ADD IsBeForwardAlready char(1) null
/
ALTER TABLE workflow_Forward ADD IsAlreadyForward char(1) null
/
ALTER TABLE workflow_Forward ADD IsBeForwardSubmitAlready char(1) null
/
ALTER TABLE workflow_Forward ADD IsBeForwardSubmitNotaries char(1) null
/
ALTER TABLE workflow_Forward ADD IsFromWFRemark char(1) null
/