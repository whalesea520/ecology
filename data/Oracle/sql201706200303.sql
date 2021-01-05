create table CRM_BusniessInfoSettings(
	id number,
	isopen number,
	appkey varchar(100),
	crmtype varchar(100),
	isCache number,
	cacheDay varchar(20),
	modifyuser varchar(100),
	modifydate varchar(100),
	modifytime varchar(100),
	source varchar(100),
	serviceurl varchar(500)
)
/
INSERT INTO CRM_BusniessInfoSettings (id, isopen, appkey, crmtype, isCache, cacheDay, modifyuser, modifydate, modifytime, source, serviceurl) VALUES (1, 0, '', '', 0, 30, '', '', '', NULL, '')
/