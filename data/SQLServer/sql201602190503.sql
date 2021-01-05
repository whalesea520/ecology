ALTER TABLE coworkshare ADD jobtitleid varchar(1000)
go
ALTER TABLE coworkshare ADD joblevel INT DEFAULT 0
go
ALTER TABLE coworkshare ADD scopeid varchar(100) DEFAULT '0'
go

ALTER TABLE cotype_sharemanager ADD jobtitleid varchar(1000)
go
ALTER TABLE cotype_sharemanager ADD joblevel INT DEFAULT 0
go
ALTER TABLE cotype_sharemanager ADD scopeid varchar(100) DEFAULT '0'
go