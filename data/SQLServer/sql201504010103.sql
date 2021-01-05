create TRIGGER hrmjobtitlesTemplet_getpinyin ON HrmJobTitlesTemplet
    FOR INSERT, UPDATE
AS
    DECLARE @pinyinlastname VARCHAR(4000)
    DECLARE @id_1 INT
    BEGIN
        IF ( UPDATE(jobtitlename) ) 
            BEGIN
                SELECT  @id_1 = id ,
                        @pinyinlastname = LOWER(dbo.getPinYin(jobtitlename))
                FROM    inserted
                UPDATE  hrmjobtitlesTemplet
                SET     ecology_pinyin_search = @pinyinlastname
                WHERE   id = @id_1
            END
    END
GO
