create table CRM_BusniessInfoSettings(
	id int,
	isopen int,
	appkey varchar(100),
	crmtype varchar(100),
	isCache int,
	cacheDay varchar(20),
	modifyuser varchar(100),
	modifydate varchar(100),
	modifytime varchar(100),
	source varchar(100),
	serviceurl varchar(500)
)
GO
INSERT INTO CRM_BusniessInfoSettings (id, isopen, appkey, crmtype, isCache, cacheDay, modifyuser, modifydate, modifytime, source, serviceurl) VALUES (1, 0, '', '', 0, 30, '', '', '', NULL, '')
GO