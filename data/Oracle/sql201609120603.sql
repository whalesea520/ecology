CREATE TABLE clusterMachine
(
ip varchar (50) NULL,
lasttime varchar (100) NULL,
STATUS int NULL
) 
/
ALTER TABLE HrmResource_online ADD serverip VARCHAR(50)
/
ALTER TABLE HrmOnlineAvg ADD serverip VARCHAR(50)
/
ALTER TABLE HrmOnlineCount ADD serverip VARCHAR(50)
/
delete from HrmResource_online
/