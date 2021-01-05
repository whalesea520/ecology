exec sp_rename 'workflow_requestlogAtInfo.forwardresource', 'forwardresource_temp', 'column'
GO
alter TABLE workflow_requestlogAtInfo add forwardresource text
GO
update workflow_requestlogAtInfo set forwardresource = forwardresource_temp
GO