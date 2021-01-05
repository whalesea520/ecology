CREATE PROCEDURE Doc_DirAcl_Insert_Type7 (
	@dirid_1 INT,
	@dirtype_1 INT,
	@permissiontype_1 INT,
	@operationcode_1 INT,
	@jobids_1 INT,
	@joblevel_1 INT,
	@jobdepartment_1 INT,
	@jobsubcompany_1 INT,
	@flag INT OUTPUT,
	@msg VARCHAR (4000) OUTPUT
) AS INSERT INTO DirAccessControlList (
	dirid,
	dirtype,
	permissiontype,
	operationcode,
	jobids,
	joblevel,
	jobdepartment,
	jobsubcompany
)
VALUES
	(
		@dirid_1,
		@dirtype_1,
		@permissiontype_1,
		@operationcode_1,
		@jobids_1,
		@joblevel_1,
		@jobdepartment_1,
		@jobsubcompany_1
	)
IF @@error <> 0
BEGIN

SET @flag = 1
SET @msg = '插入目录访问权限主表成功' RETURN
END
ELSE

BEGIN

SET @flag = 0
SET @msg = '插入目录访问权限主表失败' RETURN
END
GO