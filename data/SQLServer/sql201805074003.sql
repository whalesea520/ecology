ALTER TRIGGER tgr_PrjUpdateDepartment
ON HrmResource
FOR UPDATE
AS
    DECLARE @olddepartmentid INT,
            @newdepartmentid INT,
            @hrmid           INT;

    SELECT @olddepartmentid = departmentid,
           @hrmid = id
    FROM   deleted;

  BEGIN
      SELECT @newdepartmentid = departmentid
      FROM   inserted;

      UPDATE Prj_ProjectInfo
      SET    department = @newdepartmentid
      WHERE  manager = @hrmid;
      
      UPDATE cptcapital
      SET    departmentid = @newdepartmentid
      WHERE  resourceid = @hrmid;
  END
GO