CREATE TABLE tempSysPoppupRemindInfo (value varchar(8000))
go



CREATE PROCEDURE CreateSysPoppupRemindInfo
    @initValue varchar(8000),
    @outputValue varchar(8000) output,
    @outputCount int output
as
declare 
    @sql varchar(8000),
    @tempValue varchar(8000)
DELETE FROM tempSysPoppupRemindInfo
set 
    @sql = 'INSERT tempSysPoppupRemindInfo SELECT ''' + replace(@initValue, ',',''' AS STR UNION SELECT ''') + ''''
exec(@sql)

DECLARE cur CURSOR FOR
    SELECT distinct(value) FROM tempSysPoppupRemindInfo where value <> ''
OPEN cur
FETCH NEXT FROM cur
    INTO @tempValue
WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        set @outputValue = @outputValue + @tempValue + ','
        FETCH NEXT FROM cur
            INTO @tempValue
    END
CLOSE cur
DEALLOCATE cur

SELECT @outputCount = COUNT(distinct(value)) FROM tempSysPoppupRemindInfo where value <> ''

go


DECLARE
@userID int,
@requestIDs varchar(8000),
@finalRequestIDs varchar(8000),
@finalCount int
DECLARE curMain1 CURSOR FOR
    SELECT userID, requestIDs
    FROM SysPoppupRemindInfo 
    WHERE TYPE = 0
    ORDER BY userID 
OPEN curMain1
FETCH NEXT FROM curMain1
    INTO @userID, @requestIDs
WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        set
            @finalRequestIDs = ''
        set
            @finalCount = 0
        exec CreateSysPoppupRemindInfo @requestIDs, @finalRequestIDs output, @finalCount output

        exec('UPDATE SysPoppupRemindInfo SET count = ' + @finalCount + ' , requestIDs = ''' + @finalRequestIDs + ''' WHERE userID = ' + @userID + ' AND type = 0')
    
        FETCH NEXT FROM curMain1
        INTO @userID, @requestIDs
    END
CLOSE curMain1
DEALLOCATE curMain1 
go



DECLARE
@userID int,
@requestIDs varchar(8000),
@finalRequestIDs varchar(8000),
@finalCount int
DECLARE curMain2 CURSOR FOR
    SELECT userID, requestIDs
    FROM SysPoppupRemindInfo 
    WHERE TYPE = 1
    ORDER BY userID 
OPEN curMain2
FETCH NEXT FROM curMain2
    INTO @userID, @requestIDs
WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        set
            @finalRequestIDs = ''
        set
            @finalCount = 0
        exec CreateSysPoppupRemindInfo @requestIDs, @finalRequestIDs output, @finalCount output

        exec('UPDATE SysPoppupRemindInfo SET count = ' + @finalCount + ' , requestIDs = ''' + @finalRequestIDs + ''' WHERE userID = ' + @userID + ' AND type = 1')
    
        FETCH NEXT FROM curMain2
        INTO @userID, @requestIDs
    END
CLOSE curMain2
DEALLOCATE curMain2
go



DROP PROCEDURE CreateSysPoppupRemindInfo
go

DROP TABLE tempSysPoppupRemindInfo
go
