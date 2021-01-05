create table RTXSetting (
	RTXServerIP      varchar(50),
	RTXServerOutIP  varchar(50),
	RTXServerPort varchar(10),
	DomainName  varchar(200),
	RTXVersion varchar(10),
	RtxOrOCSType char(1),
	RtxOnload  char(1),
	RtxDenyHrm  char(1),
	IsusedRtx  char(1),
	RtxAlert   char(1)
) 
GO