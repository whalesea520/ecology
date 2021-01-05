create table Social_IMSysBroadcast(
  id int IDENTITY,
  permissionType int,
  contents int,
  seclevel int,
  seclevelMax int DEFAULT ((100)),
  jobtitleid varchar(1000),
  joblevel int DEFAULT ((0)),
  scopeid varchar(100)
)
GO

Delete from MainMenuInfo where id=10251
GO