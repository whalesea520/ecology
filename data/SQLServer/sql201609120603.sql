CREATE TABLE clusterMachine
(
ip varchar (50) NULL,
lasttime varchar (100) NULL,
STATUS int NULL
) 
GO
ALTER TABLE HrmResource_online ADD serverip VARCHAR(50)
GO
ALTER TABLE HrmOnlineAvg ADD serverip VARCHAR(50)
GO
ALTER TABLE HrmOnlineCount ADD serverip VARCHAR(50)
GO
delete from HrmResource_online
GO