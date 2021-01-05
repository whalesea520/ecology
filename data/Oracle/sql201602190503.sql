ALTER TABLE coworkshare ADD jobtitleid varchar2(1000)
/
ALTER TABLE coworkshare ADD joblevel INT DEFAULT 0
/
ALTER TABLE coworkshare ADD scopeid varchar2(100) DEFAULT '0'
/
ALTER TABLE cotype_sharemanager ADD jobtitleid varchar2(1000)
/
ALTER TABLE cotype_sharemanager ADD joblevel INT DEFAULT 0
/
ALTER TABLE cotype_sharemanager ADD scopeid varchar2(100) DEFAULT '0'
/