CREATE TABLE CRM_BusniessInfoEache
(
id int identity(1,1) primary key, 
crmid varchar(255),
userid varchar(255),
data nvarchar(max),
modifydate varchar(255),
modifytime varchar(255),
crmname varchar(255)
)
GO
CREATE TABLE CRM_BusniessInfoLog
(
id int identity(1,1) primary key, 
crmid varchar(255),
requesttype varchar(255),
requestdate varchar(255),
requesttime varchar(255),
requestuid varchar(255)
)
GO