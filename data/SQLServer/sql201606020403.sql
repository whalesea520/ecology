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
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.subcompanyname,' ')=ISNULL(del.subcompanyname,' ') and ISNULL(ins.supsubcomid,0)=ISNULL(del.supsubcomid,0) and ISNULL(ins.companyid,0)=ISNULL(del.companyid,0) and ISNULL(ins.showorder,0)=ISNULL(del.showorder,0) and ISNULL(ins.canceled,'0')=ISNULL(del.canceled,'0')) begin
	  update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmSubCompany'
	end
  end
END

GO