CREATE TABLE HrmMessagerTempMsg ( 
    id int IDENTITY PRIMARY KEY,
    loginid varchar(20),
    fromJid varchar(200),
	body varchar(1000),
    receiveTime varchar(20)
) 
GO
