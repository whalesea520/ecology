CREATE TABLE HrmSysMaintenanceLog
(
id INT NOT NULL IDENTITY(1, 1)  PRIMARY KEY,
relatedid int NOT NULL,
relatedname varchar (440) COLLATE Chinese_PRC_CI_AS NULL,
operatetype varchar (2) COLLATE Chinese_PRC_CI_AS NOT NULL,
operatedesc text COLLATE Chinese_PRC_CI_AS NULL,
operateitem varchar (10) COLLATE Chinese_PRC_CI_AS NULL,
operateuserid int NOT NULL,
operatedate char (10) COLLATE Chinese_PRC_CI_AS NOT NULL,
operatetime char (8) COLLATE Chinese_PRC_CI_AS NOT NULL,
clientaddress char (15) COLLATE Chinese_PRC_CI_AS NULL,
istemplate int NULL,
operatesmalltype int NULL,
operateusertype int NULL
) 
GO