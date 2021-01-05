CREATE TABLE ofpopinfo( 
    id int IDENTITY PRIMARY KEY,
    loginid varchar(60),
    infotitle varchar(200),
    infosubject varchar(1000),
    infourl varchar(200),
    sendtime bigint
)
go
