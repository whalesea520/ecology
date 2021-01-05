ALTER TRIGGER Tri_mobile_getpinyin ON HrmResource FOR INSERT, UPDATE
AS
    DECLARE @pinyinlastname VARCHAR(50) 
    DECLARE @id_1 INT ,
        @lastname CHAR(400) ,
        @lastname1 CHAR(400)
    SELECT  @lastname = lastname
    FROM    inserted
    SELECT  @lastname1 = lastname
    FROM    deleted
    BEGIN 
        IF ( @lastname != @lastname1 )
            OR NOT EXISTS ( SELECT  lastname
                            FROM    deleted ) 
            BEGIN
                SELECT  @id_1 = id ,
                        @pinyinlastname = LOWER(dbo.getPinYin(lastname))
                FROM    inserted 
                UPDATE  HrmResource
                SET     pinyinlastname = @pinyinlastname
                WHERE   id = @id_1
            END
    END
GO
update hrmresource set pinyinlastname = ecology_pinyin_search
GO