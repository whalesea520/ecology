create table WX_QRCodeComInfo (
	loginkey varchar(100),
	userobject  BLOB
)
/
create index WX_QRCodeComInfo_key on WX_QRCodeComInfo(loginkey)
/