ALTER TABLE cotype_sharemembers ADD jobtitleid varchar(1000)
GO
ALTER TABLE cotype_sharemembers ADD joblevel INT DEFAULT 0
GO
ALTER TABLE cotype_sharemembers ADD scopeid varchar(100) DEFAULT '0'
GO