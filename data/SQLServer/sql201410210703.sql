DELETE FROM HrmListValidate WHERE tab_type = 2
GO
CREATE TABLE HrmResourceBaseTab
(
id int NOT NULL IDENTITY(1, 1),
groupname varchar (60) NULL,
grouplabel int NULL,
dsporder decimal (10, 2) NULL,
isopen char (1) NULL,
ismand char (1) NULL,
isused char (1) NULL,
issystem char (1) NULL,
linkurl varchar (2000) NULL
) 
GO