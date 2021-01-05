create table mobileSyncInfo(syncTable char(100), syncLastTime datetime)
GO

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmResource', getdate())
GO

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmDepartment', getdate())
GO

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmSubCompany', getdate())
GO

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmCompany', getdate())
GO

insert into mobileSyncInfo(syncTable, syncLastTime) values('HrmGroupMember', getdate())
GO

update mobileSyncInfo set syncLastTime=getdate() where syncTable in ('HrmResource','HrmDepartment','HrmSubCompany','HrmCompany','HrmGroupMember')
GO

CREATE TRIGGER HrmCompanyTimesTamp_trigger ON HrmCompany FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmCompany'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.companyname,' ')=ISNULL(del.companyname,' ')) begin
	  update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmCompany'
	end
  end
END

GO

CREATE TRIGGER HrmDepartmentTimesTamp_trigger ON HrmDepartment FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmDepartment'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.departmentname,' ')=ISNULL(del.departmentname,' ') and ISNULL(ins.supdepid,0)=ISNULL(del.supdepid,0) and ISNULL(ins.subcompanyid1,0)=ISNULL(del.subcompanyid1,0)) begin
	  update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmDepartment'
	end
  end
END

GO

CREATE TRIGGER HrmGroupMemberTimesTamp_trigger ON HrmGroupMembers FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmGroupMember'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ISNULL(ins.groupid,0)=ISNULL(del.groupid,0) and ISNULL(ins.userid,0)=ISNULL(del.userid,0)) begin
	  update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmGroupMember'
	end
  end
END

GO

CREATE TRIGGER HrmResourceTimesTamp_trigger ON HrmResource FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmResource'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.lastname,' ')=ISNULL(del.lastname,' ') and ISNULL(ins.pinyinlastname,' ')=ISNULL(del.pinyinlastname,' ') and ISNULL(ins.messagerurl,' ')=ISNULL(del.messagerurl,' ') and ISNULL(ins.subcompanyid1,0)=ISNULL(del.subcompanyid1,0) and ISNULL(ins.departmentid,0)=ISNULL(del.departmentid,0) and ISNULL(ins.mobile,' ')=ISNULL(del.mobile,' ') and ISNULL(ins.telephone,' ')=ISNULL(del.telephone,' ') and ISNULL(ins.email,' ')=ISNULL(del.email,' ') and ISNULL(ins.jobtitle,' ')=ISNULL(del.jobtitle,' ') and ISNULL(ins.managerid,' ')=ISNULL(del.managerid,' ') and ISNULL(ins.status,0)=ISNULL(del.status,0) and ISNULL(ins.loginid,0)=ISNULL(del.loginid,0) and ISNULL(ins.account,0)=ISNULL(del.account,0)) begin
	  update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmResource'
	end
  end
END

GO

CREATE TRIGGER HrmSubCompanyTimesTamp_trigger ON HrmSubCompany FOR INSERT, DELETE, UPDATE  
AS 
BEGIN
  if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin
    update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmSubCompany'
  end
  else begin
	if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.subcompanyname,' ')=ISNULL(del.subcompanyname,' ') and ISNULL(ins.supsubcomid,0)=ISNULL(del.supsubcomid,0) and ISNULL(ins.companyid,0)=ISNULL(del.companyid,0)) begin
	  update mobileSyncInfo set syncLastTime=getdate() where syncTable='HrmSubCompany'
	end
  end
END

GO
