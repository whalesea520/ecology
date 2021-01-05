alter table meeting add qrticket VARCHAR(100)
GO
CREATE TABLE meeting_sign(
id int NOT NULL IDENTITY(1,1) ,
meetingid int NOT NULL ,
userid int NOT NULL ,
attendType int NOT NULL ,
signTime varchar(20) NULL ,
signReson varchar(1000) NULL,
flag int NOT NULL,
longitude decimal(20,6) NULL,
latitude decimal(20,6) NULL,
signRemark varchar(1000) NULL
)
Go