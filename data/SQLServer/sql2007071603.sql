alter PROCEDURE Meeting_Insert (
	@meetingtype [int] , 
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
	@customizeAddress   varchar(400),
	@flag integer output, 
	@msg varchar(80) output) 
AS INSERT INTO [Meeting] ( 
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
	customizeAddress) 
VALUES ( 
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
	@customizeAddress) 
select IDENT_CURRENT('Meeting')
set @flag = 1 set @msg = 'OK!' 
GO