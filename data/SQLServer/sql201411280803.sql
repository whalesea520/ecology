CREATE TABLE HrmUserGroupStatictics(
id int  NOT NULL IDENTITY(1, 1) PRIMARY KEY ,
userid int NULL,
groupid varchar (100),
clickCnt bigint NULL)
GO