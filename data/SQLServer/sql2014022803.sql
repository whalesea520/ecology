CREATE TRIGGER OverWorkPlanTimesTamp_trigger ON OverWorkPlan FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=getdate() where syncTable='WorkPlanType'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ISNULL(ins.wavailable,0)=ISNULL(del.wavailable,0) and ISNULL(ins.workplancolor,' ')=ISNULL(del.workplancolor,' ')) begin
	  update mobileSyncInfo set syncLastTime=getdate() where syncTable='WorkPlanType'
	end
  end
END

GO

CREATE TRIGGER WorkPlanTypeTimesTamp_trigger ON WorkPlanType FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=getdate() where syncTable='WorkPlanType'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.workPlanTypeID=del.workPlanTypeID and ISNULL(ins.workPlanTypeName,' ')=ISNULL(del.workPlanTypeName,' ') and ISNULL(ins.workPlanTypeColor,' ')=ISNULL(del.workPlanTypeColor,' ') and ISNULL(ins.available,'0')=ISNULL(del.available,'0') and ISNULL(ins.displayOrder,0)=ISNULL(del.displayOrder,0)) begin
	  update mobileSyncInfo set syncLastTime=getdate() where syncTable='WorkPlanType'
	end
  end
END

GO
