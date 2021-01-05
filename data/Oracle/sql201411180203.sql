create table RTXSetting (
	RTXServerIP      varchar2(50),
	RTXServerOutIP  varchar2(50),
	RTXServerPort varchar2(10),
	DomainName  varchar2(200),
	RTXVersion varchar2(10),
	RtxOrOCSType char(1),
	RtxOnload  char(1),
	RtxDenyHrm  char(1),
	IsusedRtx  char(1),
	RtxAlert   char(1),
	CurSmsServerIsValid varchar2(10),
	CurSmsServer varchar2(10)
) 
/