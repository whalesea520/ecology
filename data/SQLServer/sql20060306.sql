ALTER PROCEDURE LeftMenuConfig_InsertByUserId(
    @userId_1       int,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
DECLARE @id_1 int,
        @defaultIndex_1 int

    DECLARE leftMenuInfo_cursor CURSOR FOR
    /*只添加系统定义的左菜单*/
    SELECT id, defaultIndex FROM LeftMenuInfo WHERE isCustom='0' OR isCustom IS NULL

    OPEN leftMenuInfo_cursor
    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(@userId_1,@id_1,1,@defaultIndex_1)
        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
        
    END

    CLOSE leftMenuInfo_cursor
    DEALLOCATE leftMenuInfo_cursor
GO