ALTER procedure [Meeting_Insert] ( @meetingtype [int] , @name varchar(4000) , @caller [int] , @contacter [int] , @projectid[int], @address varchar(4000) , @begindate varchar(4000), @begintime varchar(4000), @enddate varchar(4000), @endtime varchar(4000), @desc_n varchar(4000), @creater [int], @createdate varchar(4000), @createtime varchar(4000) , @totalmember   int, @othermembers   text, @addressdesc   varchar(4000), @description text, @remindType int, @remindBeforeStart int, @remindBeforeEnd int, @remindTimesBeforeStart int, @remindTimesBeforeEnd int, @customizeAddress   varchar(4000), @flag integer output, @msg varchar(4000) output) AS INSERT INTO [Meeting] ( [meetingtype] , [name] , [caller] , [contacter] , [projectid], [address] , [begindate]  , [begintime] , [enddate] , [endtime] , [desc_n], [creater] , [createdate] , [createtime], totalmember, othermembers, addressdesc, description, remindType, remindBeforeStart, remindBeforeEnd, remindTimesBeforeStart, remindTimesBeforeEnd, customizeAddress ) VALUES ( @meetingtype , @name, @caller, @contacter, @projectid, @address , @begindate , @begintime , @enddate , @endtime , @desc_n , @creater , @createdate , @createtime, @totalmember, @othermembers, @addressdesc, @description, @remindType, @remindBeforeStart, @remindBeforeEnd, @remindTimesBeforeStart, @remindTimesBeforeEnd, @customizeAddress ) select IDENT_CURRENT('Meeting') set @flag = 1 set @msg = 'OK!'
GO
