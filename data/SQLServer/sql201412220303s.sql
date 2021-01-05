ALTER PROCEDURE hrmroles_selectall
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(30) OUTPUT
AS 
    BEGIN
        SET nocount ON
        select * into #temp from hrmroles
        ALTER TABLE #temp add cnt int
        DECLARE roles_cursor CURSOR
        FOR
            SELECT  id
            FROM    hrmroles
        OPEN roles_cursor
        DECLARE @id INT ,
            @cnt INT
        FETCH NEXT FROM roles_cursor INTO @id
        WHILE @@fetch_status = 0 
            BEGIN
                SELECT  @cnt = COUNT(id)
                FROM    HrmRoleMembers
                WHERE   roleid = @id
                UPDATE  #temp
                SET     cnt = @cnt
                WHERE   id = @id
                FETCH NEXT FROM roles_cursor INTO @id
            END
        SELECT  id ,
                rolesmark ,
                rolesname ,
                type ,
                cnt
        FROM    #temp
        CLOSE roles_cursor
        DEALLOCATE roles_cursor
    END 
GO
