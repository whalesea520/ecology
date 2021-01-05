create or replace  PROCEDURE MMConfig_U_ByInfoInsert(
	defaultParentId_1	integer,
	defaultIndex_1     	integer
) 
AS
begin
IF defaultParentId_1=0	then
	UPDATE MainMenuConfig SET viewIndex=viewIndex+1 WHERE (parentId=defaultParentId_1 OR parentId IS NULL) AND viewIndex>=defaultIndex_1;
    ELSE
	UPDATE MainMenuConfig SET viewIndex=viewIndex+1 WHERE parentId=defaultParentId_1 AND viewIndex>=defaultIndex_1;
end if;
end;
/

create or replace  PROCEDURE LMConfig_U_ByInfoInsert(
	menuLevel_1	integer,
	parentId_1	integer,
	defaultIndex_1	integer
) 
AS
begin
IF(menuLevel_1=1)
	then
	UPDATE LeftMenuConfig SET viewIndex=viewIndex+1 
	WHERE infoId IN (SELECT id FROM LeftMenuInfo WHERE parentId IS NULL) AND viewIndex>=defaultIndex_1;
	ELSE
	UPDATE LeftMenuConfig SET viewIndex=viewIndex+1 
	WHERE infoId IN (SELECT id FROM LeftMenuInfo WHERE parentId=parentId_1) AND viewIndex>=defaultIndex_1;
end if;
end;
/