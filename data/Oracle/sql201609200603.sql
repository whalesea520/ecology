ALTER TABLE SystemSet ADD appdetachinit INT
/
ALTER TABLE SysDetachInfo ADD subcompanyid INT
/
ALTER TABLE SysDetachInfo ADD departmentid INT
/
ALTER TABLE SysDetachDetail ADD iscontains INT
/
ALTER TABLE SysDetachDetail ADD seclevelto INT
/
UPDATE SysDetachDetail set iscontains=1
/
UPDATE SysDetachDetail set seclevelto=299
/
ALTER TABLE SysDetachInfo modify name VARCHAR(200)
/
