CREATE TABLE ofmucusertoken ( 
    id int IDENTITY PRIMARY KEY,
    loginid varchar(100),
    clienttype int,
    token varchar(200),
    userid varchar(200),
    channelid varchar(200)
)
GO