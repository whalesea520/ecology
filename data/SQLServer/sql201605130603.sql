ALTER procedure [Meeting_Update] ( @meetingid [int] , @name varchar(4000) , @caller [int] , @contacter [int] , @projectid [int], @address varchar(4000) , @begindate varchar(4000)  , @begintime varchar(4000)  , @enddate varchar(4000)  , @endtime varchar(4000)  , @desc_n varchar(4000)  , @totalmember   int, @othermembers   text, @addressdesc   varchar(4000), @description text, @remindType int, @remindBeforeStart int, @remindBeforeEnd int, @remindTimesBeforeStart int, @remindTimesBeforeEnd int, @customizeAddress   varchar(4000), @flag integer output, @msg varchar(4000) output ) AS Update [Meeting] set [name]=@name , [caller]=@caller , [contacter]=@contacter , [projectid]=@projectid, [address]=@address , [begindate]=@begindate , [begintime]=@begintime , [enddate]=@enddate , [endtime]=@endtime , [desc_n]=@desc_n, totalmember=@totalmember, othermembers=@othermembers, addressdesc=@addressdesc, description=@description, remindType=@remindType, remindBeforeStart=@remindBeforeStart, remindBeforeEnd=@remindBeforeEnd, remindTimesBeforeStart=@remindTimesBeforeStart, remindTimesBeforeEnd=@remindTimesBeforeEnd, customizeAddress = @customizeAddress where id = @meetingid set @flag = 1 set @msg = 'OK!'
GO
