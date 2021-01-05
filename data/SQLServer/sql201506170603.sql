ALTER FUNCTION GetSubCpyTree()
returns @t TABLE(
  id             INT,
  subcompanyname VARCHAR(1000),
  supsubcomid    INT,
  code           VARCHAR(50),
  showorder      INT,
  level          INT)
AS
  BEGIN
      INSERT @t
      SELECT id,
             subcompanyname,
             supsubcomid,
             CONVERT(VARCHAR, ( CONVERT(VARCHAR, id) )) AS code,
			 showorder,
             1                                          level
      FROM   HrmSubCompany
      WHERE  supsubcomid = 0
	         AND (canceled IS NULL 
			 OR  canceled!=1)
	  ORDER BY showorder
      WHILE @@rowcount > 0
        INSERT @t
        SELECT hrm.id,
               hrm.subcompanyname,
               hrm.supsubcomid,
               CONVERT(VARCHAR, ( CONVERT(VARCHAR, b.code) + '_'
                                  + CONVERT(VARCHAR, hrm.id) )) AS code,
			   hrm.showorder,
               level + 1
        FROM   HrmSubCompany hrm
               INNER JOIN @t b
                       ON hrm.supsubcomid = b.id
					   AND (hrm.canceled IS NULL 
			           OR  hrm.canceled!=1)
                          AND hrm.id NOT IN(SELECT id
                                            FROM   @t)

      RETURN
  END

GO

ALTER FUNCTION GetdeptTree()
returns @t TABLE(
  id             INT,
  departmentname VARCHAR(1000),
  supdepid       INT,
  subcompanyid1  INT,
  code           VARCHAR(100),
  showorder      INT,
  level          INT )
AS
  BEGIN
      INSERT @t
      SELECT id,
             departmentname,
             supdepid,
             subcompanyid1,
             CONVERT(VARCHAR, ( 'dept_' + CONVERT(VARCHAR, id) )) AS code,
			 showorder,
             1                                                    level
      FROM   HrmDepartment
      WHERE  supdepid = 0
	         AND (canceled IS NULL 
			 OR  canceled!=1)

      WHILE @@rowcount > 0
        INSERT @t
        SELECT dept.id,
               dept.departmentname,
               dept.supdepid,
               dept.subcompanyid1,
               CONVERT(VARCHAR, ( CONVERT(VARCHAR, B.code) + '_'
                                  + CONVERT(VARCHAR, dept.id) )) AS code,
			   dept.showorder,
               level + 1
        FROM   HrmDepartment dept,
               @t B
        WHERE  dept.supdepid = B.id
		       AND (dept.canceled IS NULL 
			   OR  dept.canceled!=1)
               AND dept.id NOT IN(SELECT id
                                  FROM   @t)

      RETURN
  END

GO