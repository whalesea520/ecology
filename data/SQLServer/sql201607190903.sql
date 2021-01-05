create table QRCodeComInfo (
loginkey varchar(100),
userobject  varbinary(max)
)
GO
create index QRCodeComInfo_key on QRCodeComInfo(loginkey)
GO