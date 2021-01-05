ALTER TABLE SystemSet ADD appdetachinit INT
GO
ALTER TABLE SysDetachInfo ADD subcompanyid INT
GO
ALTER TABLE SysDetachInfo ADD departmentid INT
GO
ALTER TABLE SysDetachDetail ADD iscontains INT
GO
ALTER TABLE SysDetachDetail ADD seclevelto INT
GO
UPDATE SysDetachDetail set iscontains=1
GO
UPDATE SysDetachDetail set seclevelto=299
GO
ALTER TABLE SysDetachInfo ALTER COLUMN name VARCHAR(200)
GO
