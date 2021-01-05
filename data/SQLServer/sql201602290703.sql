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
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.departmentname,' ')=ISNULL(del.departmentname,' ') and ISNULL(ins.supdepid,0)=ISNULL(del.supdepid,0) and ISNULL(ins.subcompanyid1,0)=ISNULL(del.subcompanyid1,0) and ISNULL(ins.showorder,0)=ISNULL(del.showorder,0) and ISNULL(ins.canceled,'0')=ISNULL(del.canceled,'0') ) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmDepartment'
	end
  end
END

GO