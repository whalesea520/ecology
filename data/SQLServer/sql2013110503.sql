ALTER TABLE SysPoppupRemindInfoNew ADD mobilePup INT
GO

UPDATE SysPoppupRemindInfoNew SET mobilePup=1 WHERE 1=1
GO
