ALTER PROCEDURE MMConfig_U_ByInfoInsert(
	@defaultParentId_1	int,
	@defaultIndex_1     	int
) 
AS
IF @defaultParentId_1=0
	BEGIN
	UPDATE MainMenuConfig SET viewIndex=viewIndex+1 WHERE (parentId=@defaultParentId_1 OR parentId IS NULL) AND viewIndex>=@defaultIndex_1
	END
ELSE
	BEGIN
	UPDATE MainMenuConfig SET viewIndex=viewIndex+1 WHERE parentId=@defaultParentId_1 AND viewIndex>=@defaultIndex_1
	END

GO

ALTER PROCEDURE LMConfig_U_ByInfoInsert(
	@menuLevel_1	int,
    	@parentId_1	int,
    	@defaultIndex_1	int
) 
AS
IF(@menuLevel_1=1)
	BEGIN
	UPDATE LeftMenuConfig SET viewIndex=viewIndex+1 
	WHERE infoId IN (SELECT id FROM LeftMenuInfo WHERE parentId IS NULL) AND viewIndex>=@defaultIndex_1
	END
ELSE
	BEGIN
	UPDATE LeftMenuConfig SET viewIndex=viewIndex+1 
	WHERE infoId IN (SELECT id FROM LeftMenuInfo WHERE parentId=@parentId_1) AND viewIndex>=@defaultIndex_1
	END

GO