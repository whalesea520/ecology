update workflow_billfield set fielddbtype = 'text' where fieldname = 'description' and fieldlabel = 22462
go
alter table Bill_Meeting alter column description text
GO
alter table Meeting alter column description text
GO

ALTER PROCEDURE Meeting_Insert 
( @meetingtype [int] , 
	@name [varchar] (255) , 
	@caller [int] , 
	@contacter [int] , 
	@projectid[int], 
	@address [int] , 
	@begindate [varchar] (10), 
	@begintime [varchar] (8),
	@enddate [varchar] (10), 
	@endtime [varchar] (8),
	@desc_n [varchar] (4000), 
	@creater [int], 
	@createdate [varchar] (10),
	@createtime [varchar] (8) , 
	@totalmember   int, 
	@othermembers   text, 
	@addressdesc   varchar(255), 
	@description text,
	@remindType int,
	@remindBeforeStart int,
	@remindBeforeEnd int, 
	@remindTimesBeforeStart int,
	@remindTimesBeforeEnd int,
	@customizeAddress   varchar(400), 
	@flag integer output, 
	@msg varchar(80) output) 
 AS 
 INSERT INTO [Meeting] 
( 
[meetingtype] , 
[name] , 
[caller] , 
[contacter] , 
[projectid], 
[address] , 
[begindate]  , 
[begintime] , 
[enddate] , 
[endtime] , 
[desc_n], 
[creater] , 
[createdate] , 
[createtime], 
totalmember, 
othermembers, 
addressdesc,
description,
remindType,
remindBeforeStart,
remindBeforeEnd,
remindTimesBeforeStart,
remindTimesBeforeEnd,
customizeAddress
) 
VALUES 
( 
@meetingtype , 
@name, 
@caller, 
@contacter, 
@projectid, 
@address , 
@begindate , 
@begintime , 
@enddate , 
@endtime , 
@desc_n , 
@creater , 
@createdate , 
@createtime, 
@totalmember, 
@othermembers, 
@addressdesc,
@description,
@remindType,
@remindBeforeStart,
@remindBeforeEnd,
@remindTimesBeforeStart,
@remindTimesBeforeEnd, 
@customizeAddress
) 
 select IDENT_CURRENT('Meeting') set @flag = 1 set @msg = 'OK!'
GO

ALTER PROCEDURE Meeting_Update 
( 
@meetingid [int] , 
@name [varchar] (255) ,
@caller [int] , 
@contacter [int] , 
@projectid [int], 
@address [int] , 
@begindate [varchar] (10)  , 
@begintime [varchar] (8)  , 
@enddate [varchar] (10)  , 
@endtime [varchar] (8)  , 
@desc_n [varchar] (4000)  , 
@totalmember   int, 
@othermembers   text, 
@addressdesc   varchar(255), 
@description text,
@remindType int,
@remindBeforeStart int,
@remindBeforeEnd int, 
@remindTimesBeforeStart int,
@remindTimesBeforeEnd int,
@customizeAddress   varchar(400), 
@flag integer output, 
@msg varchar(80) output
) 
AS 
Update [Meeting] 
set [name]=@name , 
[caller]=@caller , 
[contacter]=@contacter , 
[projectid]=@projectid, 
[address]=@address , 
[begindate]=@begindate , 
[begintime]=@begintime , 
[enddate]=@enddate , 
[endtime]=@endtime , 
[desc_n]=@desc_n, 
totalmember=@totalmember, 
othermembers=@othermembers, 
addressdesc=@addressdesc, 
description=@description, 
remindType=@remindType,
remindBeforeStart=@remindBeforeStart,
remindBeforeEnd=@remindBeforeEnd,
remindTimesBeforeStart=@remindTimesBeforeStart,
remindTimesBeforeEnd=@remindTimesBeforeEnd,
customizeAddress = @customizeAddress 
where id = @meetingid 
set @flag = 1 set @msg = 'OK!'
GO
