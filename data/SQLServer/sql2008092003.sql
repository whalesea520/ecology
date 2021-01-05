delete from workflow_formdetail where requestid not in (select requestid from workflow_form)
GO