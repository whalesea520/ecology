IF OBJECT_ID (N'mobileSyncInfo', N'U') IS NOT NULL
DROP TABLE mobileSyncInfo
GO

CREATE TABLE mobileSyncInfo(syncTable CHAR(100), syncLastTime INT)
GO

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmResource');
GO

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmDepartment');
GO

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmSubCompany');
GO

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmCompany');
GO

INSERT INTO mobileSyncInfo(syncTable) VALUES('HrmGroupMember');
GO

INSERT INTO mobileSyncInfo(syncTable) VALUES('WorkPlanType');
GO

INSERT INTO mobileSyncInfo(syncTable) VALUES('WorkFlowType');
GO

update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable in ('HrmResource','HrmDepartment','HrmSubCompany','HrmCompany','HrmGroupMember','WorkPlanType','WorkFlowType')
GO

IF OBJECT_ID (N'HrmCompanyTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER HrmCompanyTimesTamp_trigger

GO

CREATE TRIGGER HrmCompanyTimesTamp_trigger ON HrmCompany FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmCompany'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.companyname,' ')=ISNULL(del.companyname,' ')) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmCompany'
	end
  end
END

GO

IF OBJECT_ID (N'HrmDepartmentTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER HrmDepartmentTimesTamp_trigger

GO

CREATE TRIGGER HrmDepartmentTimesTamp_trigger ON HrmDepartment FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmDepartment'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.departmentname,' ')=ISNULL(del.departmentname,' ') and ISNULL(ins.supdepid,0)=ISNULL(del.supdepid,0) and ISNULL(ins.subcompanyid1,0)=ISNULL(del.subcompanyid1,0)) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmDepartment'
	end
  end
END

GO

IF OBJECT_ID (N'HrmGroupMemberTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER HrmGroupMemberTimesTamp_trigger

GO

CREATE TRIGGER HrmGroupMemberTimesTamp_trigger ON HrmGroupMembers FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmGroupMember'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ISNULL(ins.groupid,0)=ISNULL(del.groupid,0) and ISNULL(ins.userid,0)=ISNULL(del.userid,0)) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmGroupMember'
	end
  end
END

GO

IF OBJECT_ID (N'HrmResourceTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER HrmResourceTimesTamp_trigger

GO

CREATE TRIGGER HrmResourceTimesTamp_trigger ON HrmResource FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmResource'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.lastname,' ')=ISNULL(del.lastname,' ') and ISNULL(ins.pinyinlastname,' ')=ISNULL(del.pinyinlastname,' ') and ISNULL(ins.messagerurl,' ')=ISNULL(del.messagerurl,' ') and ISNULL(ins.subcompanyid1,0)=ISNULL(del.subcompanyid1,0) and ISNULL(ins.departmentid,0)=ISNULL(del.departmentid,0) and ISNULL(ins.mobile,' ')=ISNULL(del.mobile,' ') and ISNULL(ins.telephone,' ')=ISNULL(del.telephone,' ') and ISNULL(ins.email,' ')=ISNULL(del.email,' ') and ISNULL(ins.jobtitle,' ')=ISNULL(del.jobtitle,' ') and ISNULL(ins.managerid,' ')=ISNULL(del.managerid,' ') and ISNULL(ins.status,0)=ISNULL(del.status,0) and ISNULL(ins.loginid,0)=ISNULL(del.loginid,0) and ISNULL(ins.account,0)=ISNULL(del.account,0)) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmResource'
	end
  end
END

GO

IF OBJECT_ID (N'HrmSubCompanyTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER HrmSubCompanyTimesTamp_trigger

GO

CREATE TRIGGER HrmSubCompanyTimesTamp_trigger ON HrmSubCompany FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmSubCompany'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.subcompanyname,' ')=ISNULL(del.subcompanyname,' ') and ISNULL(ins.supsubcomid,0)=ISNULL(del.supsubcomid,0) and ISNULL(ins.companyid,0)=ISNULL(del.companyid,0)) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmSubCompany'
	end
  end
END

GO

IF OBJECT_ID (N'OverWorkPlanTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER OverWorkPlanTimesTamp_trigger

GO

CREATE TRIGGER OverWorkPlanTimesTamp_trigger ON OverWorkPlan FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkPlanType'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ISNULL(ins.wavailable,0)=ISNULL(del.wavailable,0) and ISNULL(ins.workplancolor,' ')=ISNULL(del.workplancolor,' ')) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkPlanType'
	end
  end
END

GO

IF OBJECT_ID (N'WorkFlowBaseTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER WorkFlowBaseTimesTamp_trigger

GO

CREATE TRIGGER WorkFlowBaseTimesTamp_trigger ON workflow_base FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkFlowType'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.workflowname,' ')=ISNULL(del.workflowname,' ') and ins.workflowtype=del.workflowtype and ISNULL(ins.isvalid,'0')=ISNULL(del.isvalid,'0') and ISNULL(ins.isbill,'0')=ISNULL(del.isbill,'0')) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkFlowType'
	end
  end
END

GO

IF OBJECT_ID (N'WorkFlowTypeTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER WorkFlowTypeTimesTamp_trigger

GO

CREATE TRIGGER WorkFlowTypeTimesTamp_trigger ON workflow_type FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkFlowType'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.typename,' ')=ISNULL(del.typename,' ') and ins.dsporder=del.dsporder) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkFlowType'
	end
  end
END

GO

IF OBJECT_ID (N'WorkPlanTypeTimesTamp_trigger', N'TR') IS NOT NULL
DROP TRIGGER WorkPlanTypeTimesTamp_trigger

GO

CREATE TRIGGER WorkPlanTypeTimesTamp_trigger ON WorkPlanType FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkPlanType'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.workPlanTypeID=del.workPlanTypeID and ISNULL(ins.workPlanTypeName,' ')=ISNULL(del.workPlanTypeName,' ') and ISNULL(ins.workPlanTypeColor,' ')=ISNULL(del.workPlanTypeColor,' ') and ISNULL(ins.available,'0')=ISNULL(del.available,'0') and ISNULL(ins.displayOrder,0)=ISNULL(del.displayOrder,0)) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkPlanType'
	end
  end
END

GO
