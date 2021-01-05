ALTER TABLE SysPoppupRemindInfoNew ADD mobilePup INT
/

UPDATE SysPoppupRemindInfoNew SET mobilePup=1 WHERE 1=1
/
