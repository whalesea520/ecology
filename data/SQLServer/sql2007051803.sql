ALTER TABLE Meeting
ADD customizeAddress varchar(400)
GO


INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (85,'customizeAddress',20392,'varchar(400)',1,1,16,0,'')
GO

ALTER TABLE Bill_Meeting
ADD customizeAddress varchar(400)
GO

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
set @flag = 1 set @msg = 'OK!' 
GO

alter PROCEDURE Meeting_Update (
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
	@customizeAddress   varchar(400),
	@flag integer output, 
	@msg varchar(80) output) 
AS Update [Meeting] set  
	[name]=@name ,
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
	customizeAddress = @customizeAddress
	where id = @meetingid 
set @flag = 1 set @msg = 'OK!' 
GO
