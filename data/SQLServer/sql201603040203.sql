ALTER TABLE hrm_schedule_personnel
ADD field006 INT
GO
ALTER TABLE hrm_schedule_personnel
ADD field007 VARCHAR(100)
GO
INSERT INTO  hrm_schedule_personnel (delflag,creater,create_time,last_modifier,last_modification_time,sn,field001,field002,field003,field004,field005,field006,field007)
SELECT delflag,creater,create_time,last_modifier,last_modification_time,sn,field001,SUBSTRING(a.field002,number,CHARINDEX(';',a.field002+';',number)-number) as field002,field003,field004,field005,field006,field007
FROM hrm_schedule_personnel a,master..spt_values 
WHERE CHARINDEX(';',field002)>0 AND number >=1 and number<=len(a.field002) and type='p' and substring(';'+a.field002,number,1)=';'
GO
DELETE FROM hrm_schedule_personnel WHERE CHARINDEX(';',field002)>0 
GO
