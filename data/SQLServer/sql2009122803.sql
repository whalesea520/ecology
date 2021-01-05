alter table SystemSet add openPasswordLock int
GO
alter table SystemSet add sumPasswordLock int
GO
alter table SystemSet add passwordComplexity int
GO
alter table HrmResource add passwordlock int
GO
alter table HrmResource add sumpasswordwrong int
GO

ALTER TABLE HrmResource ADD oldpassword1 varchar(100) NULL
GO
ALTER TABLE HrmResource ADD oldpassword2 varchar(100) NULL
GO
