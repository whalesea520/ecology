ALTER TABLE SysPoppupRemindInfoNew ADD mobilePup_temp varchar(50)
/

UPDATE SysPoppupRemindInfoNew SET mobilePup_temp=mobilePup
/

UPDATE SysPoppupRemindInfoNew SET mobilePup=null
/

ALTER TABLE SysPoppupRemindInfoNew modify(mobilePup varchar(50))
/

UPDATE SysPoppupRemindInfoNew SET mobilePup=mobilePup_temp
/

ALTER TABLE SysPoppupRemindInfoNew DROP COLUMN mobilePup_temp
/

ALTER TABLE SysPoppupRemindInfoNew ADD checkTime number(20)
/
