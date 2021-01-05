create table QRCodeComInfo (
loginkey varchar(100),
userobject  BLOB
)
/
create index QRCodeComInfo_key on QRCodeComInfo(loginkey)
/